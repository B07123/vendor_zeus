# Allow vendor/extra to override any property by setting it first
$(call inherit-product-if-exists, vendor/extra/product.mk)

PRODUCT_BRAND ?= ZenX-OS

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.build.selinux=1

ifeq ($(TARGET_BUILD_VARIANT),eng)
# Disable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=0
else
# Enable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# SetupWizard
PRODUCT_PRODUCT_PROPERTIES += \
    setupwizard.enable_assist_gesture_training=true \
    setupwizard.feature.baseline_setupwizard_enabled=true \
    setupwizard.feature.show_pixel_tos=true \
    setupwizard.feature.show_support_link_in_deferred_setup=false \
    setupwizard.theme=glif_v3_light

# IME
PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.ime.bs_theme=true \
    ro.com.google.ime.theme_id=5

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/zenx/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/zenx/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/zenx/prebuilt/common/bin/50-zenx.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-zenx.sh \
    vendor/zenx/prebuilt/common/bin/blacklist:$(TARGET_COPY_OUT_SYSTEM)/addon.d/blacklist

ifneq ($(AB_OTA_PARTITIONS),)
PRODUCT_COPY_FILES += \
    vendor/zenx/prebuilt/common/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/zenx/prebuilt/common/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/zenx/prebuilt/common/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh
endif

# system mount
PRODUCT_COPY_FILES += \
    vendor/havoc/prebuilt/common/bin/system-mount.sh:install/bin/system-mount.sh

# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/zenx/config/permissions/backup.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/backup.xml

# ZenX-specific broadcast actions whitelist
PRODUCT_COPY_FILES += \
    vendor/zenx/config/permissions/zenx-sysconfig.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/zenx-sysconfig.xml

# Copy all ZenX-specific init rc files
$(foreach f,$(wildcard vendor/zenx/prebuilt/common/etc/init/*.rc),\
	$(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/etc/init/$(notdir $f)))

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/zenx/prebuilt/common/lib/content-types.properties:$(TARGET_COPY_OUT_SYSTEM)/lib/content-types.properties

# Enable Android Beam on all targets
PRODUCT_COPY_FILES += \
    vendor/havoc/config/permissions/android.software.nfc.beam.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.nfc.beam.xml

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/Vendor_045e_Product_0719.kl

# This is ZenX!
PRODUCT_COPY_FILES += \
    vendor/zenx/config/permissions/privapp-permissions-zenx-system.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-zenx.xml \
    vendor/zenx/config/permissions/privapp-permissions-zenx-product.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-zenx.xml

# Hidden API whitelist
PRODUCT_COPY_FILES += \
    vendor/zenx/config/permissions/zenx-hiddenapi-package-whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/zenx-hiddenapi-package-whitelist.xml

# Power whitelist
PRODUCT_COPY_FILES += \
    vendor/zenx/config/permissions/zenx-power-whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/zenx-power-whitelist.xml

# Include Google fonts
include vendor/zenx/config/fonts.mk

# Markup libs
PRODUCT_COPY_FILES += \
    vendor/havoc/prebuilt/common/lib/libsketchology_native.so:system/product/lib/libsketchology_native.so \
    vendor/havoc/prebuilt/common/lib64/libsketchology_native.so:system/product/lib64/libsketchology_native.so

# TWRP
ifeq ($(WITH_TWRP),true)
include vendor/zenx/config/twrp.mk
endif

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

# Bootanimation
PRODUCT_PACKAGES += \
    bootanimation.zip

# AOSP packages
PRODUCT_PACKAGES += \
    ExactCalculator \
    Exchange2 \
    Terminal \
    ThemePicker

# ZenX packages
PRODUCT_PACKAGES += \
    Browser \
    CustomDoze \
    GalleryGoPrebuilt \
    NexusLauncherRelease \
    NexusWallpapersStubPrebuilt2019Static \
    OmniStyle \
    PixelThemesStub2019 \
    SafetyHubPrebuilt \
    SettingsIntelligenceGooglePrebuilt \
    SoundPickerPrebuilt

# Google
PRODUCT_PACKAGES += \
    MarkupGoogle \
    SoundPickerPrebuilt \

# Overlays
PRODUCT_PACKAGES += \
    NexusLauncherReleaseOverlay

# Accents
PRODUCT_PACKAGES += \
    AccentColorYellowOverlay \
    AccentColorVioletOverlay \
    AccentColorTealOverlay \
    AccentColorRedOverlay \
    AccentColorQGreenOverlay \
    AccentColorPinkOverlay \
    AccentColorLightPurpleOverlay \
    AccentColorIndigoOverlay \
    AccentColorFlatPinkOverlay \
    AccentColorCyanOverlay \
    AccentColorBlueGrayOverlay \
    AccentColorMintOverlay

# Extra tools in ZenX
PRODUCT_PACKAGES += \
    7z \
    awk \
    bash \
    bzip2 \
    curl \
    getcap \
    htop \
    lib7z \
    libsepol \
    nano \
    pigz \
    powertop \
    setcap \
    unrar \
    unzip \
    vim \
    wget \
    zip

# Charger
PRODUCT_PACKAGES += \
    charger_res_images

# Custom off-mode charger
ifeq ($(WITH_ZENX_CHARGER),true)
PRODUCT_PACKAGES += \
    zenx_charger_res_images \
    font_log.png \
    libhealthd.zenx
endif

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.exfat \
    fsck.ntfs \
    mke2fs \
    mkfs.exfat \
    mkfs.ntfs \
    mount.ntfs

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# Storage manager
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.storage_manager.enabled=true

# Media
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

# These packages are excluded from user builds
PRODUCT_PACKAGES_DEBUG += \
    procmem

# Conditionally build in su
ifneq ($(TARGET_BUILD_VARIANT),user)
ifeq ($(WITH_SU),true)
PRODUCT_PACKAGES += \
    su
endif
endif

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/zenx/overlay
DEVICE_PACKAGE_OVERLAYS += vendor/zenx/overlay/common

# Bootanimation
include vendor/zenx/config/bootanimation.mk

# Enable ccache
USE_CCACHE := true

-include $(WORKSPACE)/build_env/image-auto-bits.mk
-include vendor/zenx/config/partner_gms.mk
-include vendor/zenx/config/version.mk
