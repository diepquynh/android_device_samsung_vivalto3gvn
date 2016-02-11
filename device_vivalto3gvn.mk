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

$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, $(LOCAL_PATH)/device.mk)

# Keylayouts
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/keylayouts/ist30xx_ts_input.kl:system/usr/keylayout/ist30xx_ts_input.kl \
	$(LOCAL_PATH)/keylayouts/sci-keypad.kl:system/usr/keylayout/sci-keypad.kl

# Filesystem management tools
PRODUCT_PACKAGES += \
	setup_fs \
	e2fsck \
	f2fstat \
	fsck.f2fs \
	fibmap.f2fs \
	mkfs.f2fs

# Bluetooth config
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/configs/bluetooth/bt_did.conf:system/etc/bluetooth/bt_did.conf \
	$(LOCAL_PATH)/configs/bluetooth/bt_vendor.conf:system/etc/bluetooth/bt_vendor.conf

# Bluetooth
PRODUCT_PACKAGES += \
	libbluetooth_jni

# HWC
PRODUCT_PACKAGES += \
	libion \
	iontest

# Camera
PRODUCT_PACKAGES += \
	camera.scx15 \
	camera2.scx15

# Codecs
PRODUCT_PACKAGES += \
	libstagefrighthw \
	libstagefright_sprd_soft_mpeg4dec \
	libstagefright_sprd_soft_h264dec \
	libstagefright_sprd_mpeg4dec \
	libstagefright_sprd_mpeg4enc \
	libstagefright_sprd_h264dec \
	libstagefright_sprd_h264enc \
	libstagefright_sprd_vpxdec \
	libstagefright_soft_mjpgdec \
	libstagefright_soft_imaadpcmdec \
	libstagefright_sprd_aacdec \
	libstagefright_sprd_mp3dec \
	libstagefright_sprd_apedec \
	libomx_aacdec_sprd.so \
	libomx_apedec_sprd.so \
	libomx_avcdec_hw_sprd.so \
	libomx_avcdec_sw_sprd.so \
	libomx_avcenc_hw_sprd.so \
	libomx_m4vh263dec_hw_sprd.so \
	libomx_m4vh263dec_sw_sprd.so \
	libomx_m4vh263enc_hw_sprd.so \
	libomx_mp3dec_sprd.so \
	libomx_vpxdec_hw_sprd.so

# Lights
PRODUCT_PACKAGES += \
	lights.scx15

# Device-specific packages
PRODUCT_PACKAGES += \
	Torch \
	SamsungServiceMode

# Bluetooth
PRODUCT_PACKAGES += \
	bluetooth.default \
	audio.a2dp.default

# Audio
PRODUCT_PACKAGES += \
	audio.r_submix.default \
	audio.usb.default \
	libaudio-resampler

# Wifi
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/configs/wifi/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf \
	$(LOCAL_PATH)/configs/wifi/wpa_supplicant_overlay.conf:system/etc/wifi/wpa_supplicant_overlay.conf \
	$(LOCAL_PATH)/configs/wifi/p2p_supplicant_overlay.conf:system/etc/wifi/p2p_supplicant_overlay.conf

# General config
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/permissions/platform.xml:system/etc/permissions/platform.xml \
	$(LOCAL_PATH)/permissions/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
	$(LOCAL_PATH)/permissions/android.hardware.camera.flash.xml:system/etc/permissions/android.hardware.camera.flash.xml \
	frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
	frameworks/native/data/etc/android.hardware.camera.xml:system/etc/permissions/android.hardware.camera.xml \
	frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
	frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
	frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
	frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.xml \
	frameworks/native/data/etc/android.hardware.touchscreen.xml:system/etc/permissions/android.hardware.touchscreen.xml \
	frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
	frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
	frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
	frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml

# Other
PRODUCT_PACKAGES += \
	libnetcmdiface

# Set default USB interface
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
	persist.sys.usb.config=mtp

# Device props
PRODUCT_PROPERTY_OVERRIDES += \
	keyguard.no_require_sim=true \
	ro.kernel.android.checkjni=0 \
	dalvik.vm.checkjni=false

# Something required for dex2oat (ART)
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
	dalvik.vm.dex2oat-Xms=64m \
	dalvik.vm.dex2oat-Xmx=384m \
	dalvik.vm.image-dex2oat-Xms=64m \
	dalvik.vm.image-dex2oat-Xmx=64m

# Support for Browser's saved page feature. This allows
# for pages saved on previous versions of the OS to be
# viewed on the current OS.
PRODUCT_PACKAGES += \
	libskia_legacy

$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Set those variables here to overwrite the inherited values.
PRODUCT_NAME := full_vivalto3gvn
PRODUCT_DEVICE := vivalto3gvn
PRODUCT_BRAND := samsung
PRODUCT_MANUFACTURER := samsung
PRODUCT_MODEL := SM-G313HZ
