## Specify phone tech before including full_phone	
$(call inherit-product, vendor/cm/config/gsm.mk)

# Release name
PRODUCT_RELEASE_NAME := vivalto3gvn

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_full_phone.mk)

# Inherit device configuration
$(call inherit-product, $(LOCAL_PATH)/device_vivalto3gvn.mk)

## Device identifier. This must come after all inclusions
PRODUCT_DEVICE := vivalto3gvn
PRODUCT_NAME := cm_vivalto3gvn
PRODUCT_BRAND := samsung
PRODUCT_MODEL := SM-G313HZ
PRODUCT_MANUFACTURER := samsung
PRODUCT_CHARACTERISTICS := phone
