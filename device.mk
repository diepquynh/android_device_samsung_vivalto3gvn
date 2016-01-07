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

LOCAL_PATH := device/samsung/vivalto3gvn

# The gps config appropriate for this device
$(call inherit-product, device/common/gps/gps_us_supl.mk)

$(call inherit-product-if-exists, vendor/samsung/vivalto3gvn/vivalto3gvn-vendor.mk)

DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

# This device is hdpi
PRODUCT_AAPT_CONFIG := normal hdpi
PRODUCT_AAPT_PREF_CONFIG := hdpi

# Boot animation
TARGET_SCREEN_HEIGHT := 800
TARGET_SCREEN_WIDTH := 480

# languages
PRODUCT_PROPERTY_OVERRIDES += \
    ro.product.locale.language=en \
    ro.product.locale.region=GB

# Init files
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/ramdisk/init.scx15_ss.rc:root/init.scx15_ss.rc \
	$(LOCAL_PATH)/ramdisk/init.vivalto3gvn.rc:root/init.vivalto3gvn.rc \
	$(LOCAL_PATH)/ramdisk/init.vivalto3gvn_base.rc:root/init.vivalto3gvn_base.rc \
	$(LOCAL_PATH)/ramdisk/init.wifi.rc:root/init.wifi.rc \
	$(LOCAL_PATH)/ramdisk/fstab.scx15:root/fstab.scx15 \
	$(LOCAL_PATH)/ramdisk/init.board.rc:root/init.board.rc \
	$(LOCAL_PATH)/ramdisk/init.scx15.rc:root/init.scx15.rc \
	$(LOCAL_PATH)/ramdisk/init.scx15.usb.rc:root/init.scx15.usb.rc \
	$(LOCAL_PATH)/ramdisk/ueventd.scx15.rc:root/ueventd.scx15.rc \
        $(LOCAL_PATH)/ramdisk/init.recovery.scx15.rc:root/init.recovery.scx15.rc

PRODUCT_COPY_FILES += \
    	$(LOCAL_PATH)/ramdisk/etc/extra.fstab:recovery/root/etc/extra.fstab

# Override phone-hdpi-512-dalvik-heap to match value on stock
# - helps pass CTS com.squareup.okhttp.internal.spdy.Spdy3Test#tooLargeDataFrame)
# (property override must come before included property)
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapgrowthlimit=56m \

# sprd telephony
PRODUCT_PACKAGES += \
	Dialer \
	Mms

# sprd HAL modules
PRODUCT_PACKAGES += \
	lights.scx15 \
	gralloc.scx15 \
	camera.scx15 \
	camera2.scx15 \
	audio.primary.scx15 \
	audio_policy.scx15 \
	hwcomposer.scx15

# Mali GPU driver
PRODUCT_PACKAGES += \
	 mali.ko

# Torch
PRODUCT_PACKAGES += \
	Torch

# General config
PRODUCT_COPY_FILES += \
	device/samsung/vivalto3gvn/media_codecs.xml:system/etc/media_codecs.xml \
	device/samsung/vivalto3gvn/media_profiles.xml:system/etc/media_profiles.xml \
	device/samsung/vivalto3gvn/permissions/platform.xml:system/etc/permissions/platform.xml \
	frameworks/native/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
	frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
	frameworks/native/data/etc/android.hardware.camera.autofocus.xml:system/etc/permissions/android.hardware.camera.autofocus.xml \
	frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
	frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
	frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
	frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.xml \
	frameworks/native/data/etc/android.hardware.touchscreen.xml:system/etc/permissions/android.hardware.touchscreen.xml \
	frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
	frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
	frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml


# Dalvik heap config
include frameworks/native/build/phone-hdpi-512-dalvik-heap.mk

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

# For userdebug builds
ADDITIONAL_DEFAULT_PROPERTIES += \
    ro.secure=0 \
    ro.adb.secure=0 \
    ro.debuggable=1 \
    persist.service.adb.enable=1

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0
PRODUCT_NAME := full_vivalto3gvn
PRODUCT_DEVICE := vivalto3gvn
PRODUCT_BRAND := samsung
PRODUCT_MODEL := SM-G313HZ
