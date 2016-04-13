PROJECT_NAME=build_space_project
WORKSPACE_SDK=$(PROJECT_NAME).sdk

PROJECT_DIRECTORY=./
HW_NAME=zed_block_design_wrapper_hw_platform_0
BLOCK_DESIGN_TCL_FILE=bd/zed_block_design.tcl
CONSTRAINT_FILE=constrs/pin_assign.xdc
HWSPEC_FILE=zed_block_design_wrapper.hdf
BIT_FILE=zed_block_design_wrapper.bit
DEVICE_PARTS=xc7z020clg484-1
U_BOOT=u-boot.elf
BOOTIMAGE_DIR=$(WORKSPACE_SDK)/fsbl/bootimage
BOOT_BIN=$(BOOTIMAGE_DIR)/BOOT.bin

PYTHON3=python3

BIF_FILE=$(WORKSPACE_SDK)/fsbl/fsbl.bif
SETTING_FILE=builder/settings.tcl

VIVADO=vivado
VIVADO_OPTIONS=
XILINX_SDK=xsdk
XILINX_SDK_OPTIONS=
BOOTGEN=bootgen
BOOTGEN_OPTIONS=

all: u-boot.elf $(SETTING_FILE) build export_hardware build_fsbl make_bif gen_bootimage upload_bootbin

u-boot.elf:
	@echo
	@echo "********** Create u-boot.elf **********"
	mkdir -p work
	cd work; git clone https://github.com/Xilinx/u-boot-xlnx.git
	cd work/u-boot-xlnx/; git checkout -b xilinx-v2015.4 xilinx-v2015.4
	cd work/u-boot-xlnx/; patch -p0 < ../../sdboot.patch
	make -C work/u-boot-xlnx/ zynq_zed_config CROSS_COMPILE=arm-xilinx-linux-gnueabi- ARCH=arm
	make -C work/u-boot-xlnx/ CROSS_COMPILE=arm-xilinx-linux-gnueabi- ARCH=arm
	cp work/u-boot-xlnx/u-boot ./u-boot.elf

$(SETTING_FILE):
	@echo
	@echo "********** Generate settings.tcl **********"
	@mkdir -p $(WORKSPACE_SDK)/fsbl
	@echo "set project_directory "\"$(PROJECT_DIRECTORY)\" > settings.tcl.tmp
	@echo "set project_name "\"$(PROJECT_NAME)\" >> settings.tcl.tmp
	@echo "set device_parts "\"$(DEVICE_PARTS)\" >> settings.tcl.tmp
	@echo "set hw_name "\"$(HW_NAME)\" >> settings.tcl.tmp
	@echo "set hwspec_file "\"$(HWSPEC_FILE)\" >> settings.tcl.tmp
	@echo "set design_constraint_file "\"$(CONSTRAINT_FILE)\" >> settings.tcl.tmp
	@mv settings.tcl.tmp $(SETTING_FILE)

.PHONY: build
build:
	@echo "********** BUILD **********"
	$(VIVADO) $(VIVADO_OPTIONS) -mode batch -source ./builder/build.tcl

.PHONY: export_hardware
export_hardware:
	@echo "********** EXPORT HARDWARE **********"
	$(VIVADO) $(VIVADO_OPTIONS) -mode batch -source ./builder/hw_export.tcl

.PHONY: build_fsbl
build_fsbl:
	@echo "********** BUILD FSBL **********"
	$(XILINX_SDK) $(XILINX_SDL_OPTIONS) -batch -source ./builder/build_fsbl.tcl

.PHONY: make_bif
make_bif:
	@echo the_ROM_image: > fsbl.bif.tmp
	@echo "{" >> fsbl.bif.tmp
	@echo [bootloader]$(WORKSPACE_SDK)/fsbl/Debug/fsbl.elf >> fsbl.bif.tmp
	@echo $(WORKSPACE_SDK)/$(HW_NAME)/$(BIT_FILE) >> fsbl.bif.tmp
	@echo $(U_BOOT) >> fsbl.bif.tmp
	@echo "}" >> fsbl.bif.tmp
	mv fsbl.bif.tmp $(BIF_FILE)

.PHONY: gen_bootimage
gen_bootimage:
	@echo "********** GENERATE BOOTIMAGE **********"
	mkdir -p $(BOOTIMAGE_DIR)
	$(BOOTGEN) $(BOOTGEN_OPTIONS) -image $(BIF_FILE) -o $(BOOT_BIN) -w on 

.PHONY: upload_bootbin
upload_bootbin:
	cd dropbox; $(PYTHON3) upload.py

.PHONY: clean
clean:
	rm -rf work/
	rm -rf $(PROJECT_NAME).*
	rm -rf *.log *.jou
	rm -f $(BIF_FILE) $(SETTING_FILE)
	rm -f u-boot.elf
