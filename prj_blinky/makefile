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
# Define SDK&BSP directories
#################################################
SDK_DIR = ../../SDK
BSP_DIR = ../BSP
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

##############################################
# Project include directories
##############################################
PRJ_INC_DIR = inc/
$(info PRJ_INC_DIR = $(PRJ_INC_DIR))
##############################################

C_INCLUDES += $(PRJ_INC_DIR)
C_INCLUDES += $(shell find $(BSP_DIR) -maxdepth 2 -name '*.h' -exec dirname {} \; | sort -u | sed 's|$$|/|')
C_INCLUDES := $(addprefix -I, $(C_INCLUDES))
C_SOURCES += $(PRJ_SOURCES)
$(info C_INCLUDES = $(C_INCLUDES))

##############################################
# Linker file directory
##############################################
LDSCRIPT = STM32H743IITX_FLASH.ld
##############################################

include sdk.mk
include ../BSP/bsp.mk
# include programmer.mk

##############################################
# Rules and make targets
##############################################
all: sdk_core bsp_build $(OUT_DIR)/$(TARGET).elf $(OUT_DIR)/$(TARGET).hex $(OUT_DIR)/$(TARGET).bin $(OUT_DIR)/$(TARGET).map

# list of objects
OBJECTS = $(addprefix $(OBJ_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))

$(OBJ_DIR)/%.o: %.c makefile | $(OBJ_DIR)
	$(ARM_CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(OBJ_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

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