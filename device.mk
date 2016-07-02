# Copyright (C) 2014 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# The gps config appropriate for this device
$(call inherit-product, device/common/gps/gps_us_supl.mk)

$(call inherit-product-if-exists, vendor/samsung/vivalto3gvn/vivalto3gvn-vendor.mk)

DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := hdpi

# Boot animation
TARGET_SCREEN_HEIGHT := 800
TARGET_SCREEN_WIDTH := 480

# Languages
PRODUCT_PROPERTY_OVERRIDES += \
	ro.product.locale.language=en \
	ro.product.locale.region=GB

# Rootdir files
ROOTDIR_FILES := \
	$(LOCAL_PATH)/rootdir/init.rc \
	$(LOCAL_PATH)/rootdir/init.board.rc \
	$(LOCAL_PATH)/rootdir/init.scx15.rc \
	$(LOCAL_PATH)/rootdir/init.scx15.usb.rc \
	$(LOCAL_PATH)/rootdir/init.scx15_ss.rc \
	$(LOCAL_PATH)/rootdir/init.vivalto3gvn.rc \
	$(LOCAL_PATH)/rootdir/init.vivalto3gvn_base.rc \
	$(LOCAL_PATH)/rootdir/init.wifi.rc \
	$(LOCAL_PATH)/rootdir/init.swap.rc \
	$(LOCAL_PATH)/rootdir/init.recovery.scx15.rc \
	$(LOCAL_PATH)/rootdir/ueventd.scx15.rc \
	$(LOCAL_PATH)/rootdir/fstab.scx15 \
	$(LOCAL_PATH)/rootdir/fstab.swap \
	$(LOCAL_PATH)/rootdir/property_contexts

PRODUCT_COPY_FILES += \
	$(foreach f,$(ROOTDIR_FILES),$(f):root/$(notdir $(f)))

PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/rootdir/etc/extra.fstab:recovery/root/etc/extra.fstab

# Override phone-hdpi-512-dalvik-heap to match value on stock
PRODUCT_PROPERTY_OVERRIDES += \
	dalvik.vm.heapgrowthlimit=48m

# enable Google-specific location features,
# like NetworkLocationProvider and LocationCollector
PRODUCT_PROPERTY_OVERRIDES += \
	ro.com.google.locationfeatures=1 \
	ro.com.google.networklocation=1

# Dalvik heap config
$(call inherit-product, frameworks/native/build/phone-hdpi-512-dalvik-heap.mk)

# For userdebug builds
ADDITIONAL_DEFAULT_PROPERTIES += \
	ro.secure=0 \
	ro.adb.secure=0 \
	ro.debuggable=1 \
	persist.sys.root_access=1 \
	persist.service.adb.enable=1

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0
PRODUCT_NAME := full_vivalto3gvn
PRODUCT_DEVICE := vivalto3gvn
PRODUCT_BRAND := samsung
PRODUCT_MODEL := SM-G313HZ
