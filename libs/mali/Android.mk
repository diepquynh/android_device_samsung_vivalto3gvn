ifneq ($(TARGET_SIMULATOR),true)
LOCAL_PATH:= $(call my-dir)
include $(LOCAL_PATH)/driver/Android.mk
endif
