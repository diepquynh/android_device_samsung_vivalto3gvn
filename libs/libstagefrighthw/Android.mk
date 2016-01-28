LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	SprdOMXPlugin.cpp \
	SprdOMXComponent.cpp \
	SprdSimpleOMXComponent.cpp

LOCAL_C_INCLUDES:= \
	$(TOP)/frameworks/native/include/media/hardware \
	$(TOP)/frameworks/native/include/media/openmax \
	$(TOP)/frameworks/native/include/binder

LOCAL_SHARED_LIBRARIES :=    \
        libbinder            \
        libutils             \
        libcutils            \
        libui                \
        libdl                \
	libstagefright_foundation

LOCAL_MODULE := libstagefrighthw

LOCAL_MODULE_TAGS := optional
include $(BUILD_SHARED_LIBRARY)
