# Release name
PRODUCT_RELEASE_NAME := SM-G313HZ

# Inherit some stuff.
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base_telephony.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)
$(call inherit-product, device/samsung/vivalto3gvn/device_vivalto3gvn.mk)
$(call inherit-product-if-exists, vendor/samsung/vivalto3gvn/vivalto3gvn-vendor.mk)

## Device identifier. This must come after all inclusions
PRODUCT_DEVICE := vivalto3gvn
PRODUCT_NAME := aosp_vivalto3gvn
PRODUCT_BRAND := samsung
PRODUCT_MANUFACTURER := samsung
PRODUCT_MODEL := SM-G313HZ
PRODUCT_CHARACTERISTICS := phone
