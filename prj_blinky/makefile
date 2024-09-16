# Toolchain dir
TOOLCHAIN_ROOT = ../../../Toolchains/arm-gnu-toolchain-11.3.rel1-x86_64-arm-none-eabi/bin

#################################################
# Toolchain variables
#################################################
ARM_AS = $(TOOLCHAIN_ROOT)/arm-none-eabi-gcc -x assembler-with-cpp
ARM_CC = $(TOOLCHAIN_ROOT)/arm-none-eabi-gcc
ARM_DB = $(TOOLCHAIN_ROOT)/arm-none-eabi-gdb
ARM_LD = $(TOOLCHAIN_ROOT)/arm-none-eabi-ld
ARM_CP = $(TOOLCHAIN_ROOT)/arm-none-eabi-objcopy
ARM_SZ = $(TOOLCHAIN_ROOT)/arm-none-eabi-size
HEX = $(ARM_CP) -O ihex
BIN = $(ARM_CP) -O binary -S
#################################################

#################################################
# Target and build mode options
#################################################
TARGET = prj_blinky
BUILD_MODE ?= debug
#################################################

#################################################
# Define build directories
#################################################
BUILD_DIR = build
OBJ_DIR = $(BUILD_DIR)/obj
GEN_OUT_DIR = $(BUILD_DIR)/out
DEBUG_DIR = $(GEN_OUT_DIR)/debug
RELEASE_DIR = $(GEN_OUT_DIR)/release
#################################################

#################################################
# Define SDK directories
#################################################
SDK_DIR = ../../SDK
#################################################

#################################################
# Compiler flags and variables for this project
#################################################
CPU = -mcpu=cortex-m7
FPU = -mfpu=fpv5-d16
FLOAT-ABI = -mfloat-abi=hard
MCU = $(CPU) -mthumb $(FPU) $(FLOAT-ABI)

ifeq ($(BUILD_MODE), debug)
	OPT = -Og
	C_FLAGS_BUILD_MODE = $(OPT) -g
	LDFLAGS += -g
	OUT_DIR = $(DEBUG_DIR)
else ifeq ($(BUILD_MODE), release)
	OPT = -O3
	C_FLAGS_BUILD_MODE = $(OPT)
	LDFLAGS +=
	OUT_DIR = $(RELEASE_DIR)
endif

C_DEFS =  \
-DUSE_FULL_LL_DRIVER \
-DHSE_VALUE=8000000 \
-DHSE_STARTUP_TIMEOUT=100 \
-DLSE_STARTUP_TIMEOUT=5000 \
-DLSE_VALUE=32768 \
-DEXTERNAL_CLOCK_VALUE=12288000 \
-DHSI_VALUE=64000000 \
-DLSI_VALUE=32000 \
-DVDD_VALUE=3300 \
-DSTM32H743xx
C_DEFS += -DPRJ_BLINKY
CFLAGS += $(MCU) $(C_DEFS) $(C_INCLUDES) $(C_FLAGS_BUILD_MODE) -Wall -fdata-sections -ffunction-sections -MMD -MP -MF"$(@:%.o=%.d)"
#################################################

#################################################
# Assembler flags for this project
#################################################
AS_DEFS =
ASFLAGS = $(MCU) $(AS_DEFS) $(AS_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections
#################################################

#################################################
# Linker flags for this project
#################################################
LIBS = -lc -lm -lnosys 
LIBDIR = 
LDFLAGS = $(MCU) -specs=nano.specs -T$(LDSCRIPT) $(LIBDIR) $(LIBS) -Wl,-Map=$(OUT_DIR)/$(TARGET).map,--cref -Wl,--gc-sections
#################################################

##############################################
# Project source files/directories
##############################################
PRJ_SRC_DIR = src
PRJ_SOURCES = $(wildcard $(PRJ_SRC_DIR)/*.c)
$(info PRJ_SOURCES = $(PRJ_SOURCES))
##############################################
# Project include directories
##############################################
PRJ_INC_DIR = inc/
$(info PRJ_INC_DIR = $(PRJ_INC_DIR))
##############################################


##############################################
# SDK include directories
##############################################
# SDK_DIR = ../../SDK
# CMSIS_CORE_DIR = $(SDK_DIR)/cmsis-core/Include
# CMSIS_H7_DIR = $(SDK_DIR)/cmsis_device_h7/Include
# HAL_LL_INC_DIR = $(SDK_DIR)/stm32h7xx_hal_driver/Inc
##############################################
# SDK/ASM source files/directories
##############################################
# ASM_FILE_DIR = $(CMSIS_H7_DIR)/Source/Templates/gcc/startup_stm32h743xx.s
# SDK_SRC_DIR = $(SDK_DIR)/stm32h7xx_hal_driver/Src
# SDK_SOURCES = $(wildcard $(SDK_SRC_DIR)*.c)
# SDK_SOURCES += $(CMSIS_H7_DIR)/Source/Templates/system_stm32h7xx.c
##############################################

C_INCLUDES += $(PRJ_INC_DIR)
C_INCLUDES := $(addprefix -I, $(C_INCLUDES))
# C_INCLUDES += $(CMSIS_H7_DIR)
# C_INCLUDES += $(HAL_LL_INC_DIR)
# C_INCLUDES += $(CMSIS_CORE_DIR)
# C_SOURCES += $(SDK_SOURCES)
C_SOURCES += $(PRJ_SOURCES)

##############################################
# Linker file directory
##############################################
LDSCRIPT = STM32H743IITX_FLASH.ld
##############################################

include sdk.mk
include ../BSP/bsp.mk
# а также добавить путь до cmsis'а
# include programmer.mk
# а вот тут описывать цели зависящие от программатора

##############################################
# Rules and make targets
##############################################
all: sdk_core bsp_build $(OUT_DIR)/$(TARGET).elf $(OUT_DIR)/$(TARGET).hex $(OUT_DIR)/$(TARGET).bin $(OUT_DIR)/$(TARGET).map

# list of objects
OBJECTS = $(addprefix $(OBJ_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))
# list of ASM program objects
# OBJECTS += $(addprefix $(OBJ_DIR)/,$(notdir $(ASM_FILE_DIR:.s=.o)))
# vpath %.s $(sort $(dir $(ASM_FILE_DIR)))

$(OBJ_DIR)/%.o: %.c makefile | $(OBJ_DIR)
	$(ARM_CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(OBJ_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

# $(OBJ_DIR)/%.o: %.s makefile | $(OBJ_DIR)
# 	$(ARM_AS) -c $(CFLAGS) $< -o $@

$(OUT_DIR)/$(TARGET).elf: $(OBJECTS) makefile | $(OUT_DIR) $(OBJ_DIR)
	$(ARM_CC) $(OBJECTS) $(LDFLAGS) -o $@
	$(ARM_SZ) $@

$(OUT_DIR)/%.hex: $(OUT_DIR)/%.elf | $(OUT_DIR)
	$(HEX) $< $@
	
$(OUT_DIR)/%.bin: $(OUT_DIR)/%.elf | $(OUT_DIR)
	$(BIN) $< $@

$(OUT_DIR):
	@mkdir -p $@

$(OBJ_DIR):
	@mkdir -p $@
##############################################

# call programmer make targets from programmer.mk
# output log rules
# generate logfile in $(OUT_DIR)

-include $(wildcard $(OBJ_DIR)/*.d)