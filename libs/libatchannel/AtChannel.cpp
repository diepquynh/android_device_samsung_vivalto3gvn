#define LOG_TAG "IAtChannel"

#include <cstdlib>
#include <cstring>
#include <android/log.h>
#include <binder/IServiceManager.h>
#include <utils/String8.h>
#include <utils/String16.h>
#include <dlfcn.h>
#include <AtChannel.h>
#include <cutils/properties.h>
#include <cutils/sockets.h>
#include <secril-client.h>
#include <telephony/ril.h>

using namespace android;

#define REQ_POOL_SIZE 32
#ifndef MIN
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#endif

typedef enum _req_state {
	REQ_STATE_PENDING,
	REQ_STATE_UNSOL,
	REQ_STATE_COMPLETED
} req_state_t;

typedef struct _req_status {
	HRilClient client;
	req_state_t state;
	void *data;
	size_t data_len;
} req_status_t;

req_status_t *req_status_pool[REQ_POOL_SIZE];

/*
 * Find free slot
 * Return NULL if there is no free slot
 */
static req_status_t *req_status_alloc(int sim_id)
{
	int (*connect_ril)(HRilClient) = sim_id == 0 ? Connect_RILD : Connect_RILD_Second;
	req_status_t *result = NULL;
	for (int i = 0; i < REQ_POOL_SIZE; ++i) {
		if (req_status_pool[i] == NULL &&
				(result = (req_status_t *) malloc(sizeof(req_status_t)))) {
			HRilClient client;
			if ((client = OpenClient_RILD()) && (*connect_ril)(client) == 0) {
				result->client = client;
				result->state = REQ_STATE_PENDING;
				result->data = NULL;
				result->data_len = 0;
				req_status_pool[i] = result;
			} else {
				CloseClient_RILD(client);
				free(result);
				result = NULL;
			}
			break;
		}
	}
	return result;
}

static int req_status_free(req_status_t *req_status)
{
	for (int i = 0; i < REQ_POOL_SIZE; ++i) {
		if (req_status_pool[i] == req_status) {
			req_status_pool[i] = NULL;
			break;
		}
	}
	free(req_status->data);
	CloseClient_RILD(req_status->client);
	free(req_status);
	return 0;
}

static req_status_t *req_status_find_for(HRilClient client)
{
	for (int i = 0; i < REQ_POOL_SIZE; ++i) {
		req_status_t *result = req_status_pool[i];
		if (result && result->client == client)
			return result;
	}
	return NULL;
}

static size_t make_raw_at_req(void *out, int outSize, const char *atCmd, const int atCmdLen)
{
	const char atMagic[] = { 0x30, 0x00 };
	const int atReqSize = sizeof(atMagic) + atCmdLen + 1;
	if (outSize >= atReqSize) {
		char *outPtr = (char *)out;
		memcpy(outPtr, atMagic, sizeof(atMagic));
		outPtr += sizeof(atMagic);
		memcpy(outPtr, atCmd, atCmdLen + 1);
		return atReqSize;
	}
	return 0;
}

static int ril_on_unsolicited_handler(HRilClient handle, const void *data, size_t datalen)
{
	req_status_t *req_status = req_status_find_for(handle);
	if (req_status) {
		req_status->data = malloc(datalen);
		memcpy(req_status->data, data, datalen);
		req_status->data_len = datalen;
		req_status->state = REQ_STATE_UNSOL;
	}
	return 0;
}

static int ril_on_complete_handler(HRilClient handle, const void *data, size_t datalen)
{
	req_status_t *req_status = req_status_find_for(handle);
	if (req_status) {
		req_status->data = malloc(datalen);
		memcpy(req_status->data, data, datalen);
		req_status->data_len = datalen;
		req_status->state = REQ_STATE_COMPLETED;
	}
	return 0;
}

size_t sendAt(void *out, size_t outLen, int simId, const char* atCmd)
{
	req_status_t *req_status = req_status_alloc(simId);
	if (req_status) {
		char raw_at[1024];
		int raw_at_size = make_raw_at_req(raw_at, sizeof(raw_at), atCmd, strlen(atCmd));
		bool completed = false;
		ALOGI("RegisterUnsolicitedHandler: %d\n",
				RegisterUnsolicitedHandler(
						req_status->client,
						RIL_REQUEST_OEM_HOOK_RAW,
						ril_on_unsolicited_handler));
		ALOGI("RegisterRequestCompleteHandler: %d\n",
				RegisterRequestCompleteHandler(
						req_status->client,
						RIL_REQUEST_OEM_HOOK_RAW,
						ril_on_complete_handler));
		ALOGI("InvokeOemRequestHookRaw: %d\n",
				InvokeOemRequestHookRaw(req_status->client, raw_at, raw_at_size));
		do {
			switch (req_status->state) {
			case REQ_STATE_UNSOL:
				;
				break;
			case REQ_STATE_COMPLETED:
				memset(out, 0, outLen);
				memcpy(out, req_status->data, MIN(outLen, req_status->data_len));
				completed = true;
				break;
			case REQ_STATE_PENDING:
			default:
				sleep(1); // TODO Use locking
				ALOGI("Sleeping...");
				break;
			}
		} while (!completed);
	}
	size_t result = req_status->data_len;
	req_status_free(req_status);
	return result;
}
