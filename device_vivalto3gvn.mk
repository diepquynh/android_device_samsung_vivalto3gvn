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
	device/samsung/vivalto3gvn/keylayouts/ist30xx_ts_input.kl:system/usr/keylayout/ist30xx_ts_input.kl \
	device/samsung/vivalto3gvn/keylayouts/sci-keypad.kl:system/usr/keylayout/sci-keypad.kl

# board-specific files
PRODUCT_COPY_FILES += \
	device/samsung/vivalto3gvn/audio_params/tiny_hw.xml:system/etc/tiny_hw.xml		\
	device/samsung/vivalto3gvn/audio_params/codec_pga.xml:system/etc/codec_pga.xml		\
	device/samsung/vivalto3gvn/audio_params/audio_hw.xml:system/etc/audio_hw.xml		\
	device/samsung/vivalto3gvn/audio_params/audio_para:system/etc/audio_para		\
	device/samsung/vivalto3gvn/audio_params/audio_policy.conf:system/etc/audio_policy.conf

# Filesystem management tools
PRODUCT_PACKAGES +=	\
	setup_fs	\
	e2fsck		\
	f2fstat		\
	fsck.f2fs	\
	fibmap.f2fs	\
	mkfs.f2fs

# Support for Browser's saved page feature. This allows
# for pages saved on previous versions of the OS to be
# viewed on the current OS.
PRODUCT_PACKAGES += \
	libskia_legacy

$(call inherit-product, hardware/broadcom/wlan/bcmdhd/config/config-bcm.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Set those variables here to overwrite the inherited values.
PRODUCT_NAME := full_vivalto3gvn
PRODUCT_DEVICE := vivalto3gvn
PRODUCT_BRAND := samsung
PRODUCT_MANUFACTURER := samsung
PRODUCT_MODEL := SM-G313HZ
