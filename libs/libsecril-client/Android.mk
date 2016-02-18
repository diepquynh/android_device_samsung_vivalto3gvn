# Copyright 2006 The Android Open Source Project

LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE_TAGS := eng

LOCAL_SRC_FILES:= \
    secril-client.cpp

LOCAL_SHARED_LIBRARIES := \
    libutils \
    libbinder \
    libcutils \
    libhardware_legacy

LOCAL_CFLAGS := 

ifeq ($(TARGET_BOARD_PLATFORM),exynos4)
LOCAL_CFLAGS += -DRIL_CALL_AUIO_PATH_EXTRAVOLUME
endif


LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_PATH)

# XXX MOVE ME TO BoardConfig.mk
LOCAL_CFLAGS += -DSEC_PRODUCT_FEATURE_RIL_CALL_DUALMODE_CDMAGSM

LOCAL_MODULE:= libsecril-client
LOCAL_PRELINK_MODULE := false

include $(BUILD_SHARED_LIBRARY)
