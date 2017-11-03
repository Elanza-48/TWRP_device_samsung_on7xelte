LOCAL_PATH := $(call my-dir)

PREBUILT_DTIMAGE_TARGET := $(LOCAL_PATH)/dt.img
LZMA_RAMDISK := $(PRODUCT_OUT)/ramdisk-recovery-lzma.img
LZMA_BIN := $(shell which lzma)

$(LZMA_RAMDISK): $(recovery_ramdisk)
	 gunzip -f < $(recovery_ramdisk) | $(LZMA_BIN) > $@

FLASH_IMAGE_TARGET ?= $(PRODUCT_OUT)/recovery.tar

$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) $(PREBUILT_DTIMAGE_TARGET) $(recovery_kernel) $(LZMA_RAMDISK)
	@echo -e ${CL_GRN}"----- Making recovery image ------"${CL_RST}
	$(hide) $(MKBOOTIMG) $(INTERNAL_RECOVERYIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@ --ramdisk $(LZMA_RAMDISK)
	@echo -e ${CL_CYN}"Made recovery image: $@"${CL_RST}
	@echo -e ${CL_GRN}"----- Lying about SEAndroid state to Samsung bootloader ------"${CL_RST}
	$(hide) echo -n "SEANDROIDENFORCE" >> $(INSTALLED_RECOVERYIMAGE_TARGET)
	$(hide) $(call assert-max-image-size,$@,$(BOARD_RECOVERYIMAGE_PARTITION_SIZE),raw)
	$(hide) tar -C $(PRODUCT_OUT) -H ustar -c recovery.img > $(FLASH_IMAGE_TARGET)
	@echo -e ${CL_CYN}"Made Odin flashable recovery tar: ${FLASH_IMAGE_TARGET}"${CL_RST}
