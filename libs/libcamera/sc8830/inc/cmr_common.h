/*
 * Copyright (C) 2012 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#ifndef _CMR_COMMON_H_
#define _CMR_COMMON_H_

#ifdef __cplusplus
extern "C"
{
#endif

#include <sys/types.h>
#include <utils/Log.h>
#include <utils/Timers.h>

//#define NCMRDBG 1
#ifndef LOG_NDEBUG
#ifdef NCMRDBG
#define LOG_NDEBUG 1
#else
#define LOG_NDEBUG 0
#endif
#endif

//#define DEBUG_STR     "%s(L %d), %s: "
//#define DEBUG_ARGS    __FILE__,__LINE__,__FUNCTION__
#define DEBUG_STR     "L %d, %s: "
#define DEBUG_ARGS    __LINE__,__FUNCTION__

#define CMR_LOGE(format,...) ALOGE(DEBUG_STR format, DEBUG_ARGS, ##__VA_ARGS__)
#define CMR_LOGW(format,...) ALOGW(DEBUG_STR format, DEBUG_ARGS, ##__VA_ARGS__)
#define CMR_LOGI(format,...) ALOGI(DEBUG_STR format, DEBUG_ARGS, ##__VA_ARGS__)
#define CMR_LOGD(format,...) ALOGD(DEBUG_STR format, DEBUG_ARGS, ##__VA_ARGS__)
#define CMR_LOGV(format,...) ALOGV(DEBUG_STR format, DEBUG_ARGS, ##__VA_ARGS__)

#define CMR_EVT_V4L2_BASE                  (1 << 16)
#define CMR_EVT_CVT_BASE                   (1 << 17)
#define CMR_EVT_ISP_BASE                   (1 << 18)
#define CMR_EVT_SENSOR_BASE                (1 << 19)
#define CMR_EVT_JPEG_BASE                  (1 << 20)
#define CMR_EVT_OEM_BASE                   (1 << 21)

#define RAWRGB_BIT_WIDTH                   10
#define CMR_ZOOM_FACTOR                    2
#define CMR_SLICE_HEIGHT                   256
#define CMR_SHARK_SCALING_TH               2048
#define CMR_DOLPHIN_SCALING_TH             1280
#define CMR_IMG_CNT_MAX                    8
#define CMR_JPEG_COMPRESS_FACTOR           5
#define CMR_JPEG_SZIE(w,h)                 (uint32_t)((w)*(h))
#define CMR_EVT_MASK_BITS                  (uint32_t)(CMR_EVT_V4L2_BASE | CMR_EVT_CVT_BASE | \
					CMR_EVT_ISP_BASE | CMR_EVT_SENSOR_BASE | \
					CMR_EVT_JPEG_BASE | CMR_EVT_OEM_BASE)

#define CMR_RTN_IF_ERR(n)                                              \
		do {                                                   \
			if (n) {                                       \
				CMR_LOGW("ret %d", n);                 \
				goto exit;                             \
			}                                              \
		} while(0)

#define CMR_PRINT_TIME                                                     \
		do {                                                       \
                        nsecs_t timestamp = systemTime(CLOCK_MONOTONIC);   \
                        CMR_LOGI("timestamp = %lld.", timestamp/1000000);  \
		} while(0)

#define CMR_PRINT_TIME_V                                                     \
		do {                                                       \
                        nsecs_t timestamp = systemTime(CLOCK_MONOTONIC);   \
                        CMR_LOGV("timestamp = %lld.", timestamp/1000000);  \
		} while(0)


#ifndef MIN
#define MIN(x,y) (((x)<(y))?(x):(y))
#endif

#ifndef MAX
#define MAX(x,y) (((x)>(y))?(x):(y))
#endif

enum img_rot_angle {
	IMG_ROT_0 = 0,
	IMG_ROT_90,
	IMG_ROT_270,
	IMG_ROT_180,
	IMG_ROT_MIRROR,
	IMG_ROT_MAX
};

enum img_data_type_e {
	IMG_DATA_TYPE_JPEG = 0,
	IMG_DATA_TYPE_YUV422,
	IMG_DATA_TYPE_YUV420,
	IMG_DATA_TYPE_RGB565,
	IMG_DATA_TYPE_RGB888,
	IMG_DATA_TYPE_RAW,
	IMG_DATA_TYPE_MAX
};

enum img_skip_mode {
	IMG_SKIP_HW = 0,
	IMG_SKIP_SW
};

enum restart_mode {
	RESTART_LIGHTLY = 0,
	RESTART_MIDDLE,
	RESTART_HEAVY,
	RESTART_ZOOM,
	RESTART_ZOOM_RECT,
	RESTART_MAX
};

struct img_size {
	uint32_t                            width;
	uint32_t                            height;
};

struct img_rect {
	uint32_t                            start_x;
	uint32_t                            start_y;
	uint32_t                            width;
	uint32_t                            height;
};

struct img_addr {
	uint32_t                            addr_y;
	uint32_t                            addr_u;
	uint32_t                            addr_v;
};

struct img_data_end {
	uint8_t                             y_endian;
	uint8_t                             uv_endian;
	uint8_t                             reserved0;
	uint8_t                             reserved1;
};

struct img_frm {
	uint32_t                            fmt;
	uint32_t                            buf_size;
	struct img_size                     size;
	struct img_addr                     addr_phy;
	struct img_addr                     addr_vir;
	struct img_data_end                 data_end;
	void*                               reserved;
};

struct ccir_if {
	uint8_t                             v_sync_pol;
	uint8_t                             h_sync_pol;
	uint8_t                             pclk_pol;
	uint8_t                             res1;
};

struct mipi_if {
	uint8_t                             use_href;
	uint8_t                             bits_per_pxl;
	uint8_t                             is_loose;
	uint8_t                             lane_num;
	uint32_t                           pclk;
};

struct  sensor_if {
	uint8_t                             if_type;
	uint8_t                             img_fmt;
	uint8_t                             img_ptn;
	uint8_t                             frm_deci;
	uint8_t                             res[4];
	union  {
		struct ccir_if              ccir;
		struct mipi_if              mipi;
	}if_spec;
};

typedef void (*cmr_evt_cb)(int evt, void* data);
typedef int  (*cmr_before_set_cb)(enum restart_mode re_mode);
typedef int  (*cmr_after_set_cb)(enum restart_mode re_mode, enum img_skip_mode skip_mode, uint32_t skip_number);

#ifdef __cplusplus
}
#endif

#endif //for _CMR_COMMON_H_

