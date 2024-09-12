# makefile for stm32
TOOLCHAIN_ROOT = ../../../Toolchains/arm-gnu-toolchain-11.3.rel1-x86_64-arm-none-eabi/bin

ARM_AS = $(TOOLCHAIN_ROOT)/arm-none-eabi-gcc -x assembler-with-cpp
ARM_CC = $(TOOLCHAIN_ROOT)/arm-none-eabi-gcc
ARM_DB = $(TOOLCHAIN_ROOT)/arm-none-eabi-gdb
ARM_LD = $(TOOLCHAIN_ROOT)/arm-none-eabi-ld
ARM_CP = $(TOOLCHAIN_ROOT)/arm-none-eabi-objcopy
ARM_SZ = $(TOOLCHAIN_ROOT)/arm-none-eabi-size
HEX = $(ARM_CP) -O ihex
BIN = $(ARM_CP) -O binary -S

TARGET = blinky_h743
BUILD_DIR = build

SDK_DIR = ../../SDK

CMSIS_CORE_DIR = $(SDK_DIR)/cmsis-core
CMSIS_H7_DIR = $(SDK_DIR)/cmsis_device_h7
HAL_LL_DIR = $(SDK_DIR)/stm32h7xx_hal_driver
LDSCRIPT = STM32H743IITX_FLASH.ld

PRJ_SRC_DIR = src/
PRJ_SRCS = $(wildcard $(PRJ_SRC_DIR)*.c)
SDK_SRCS = $(CMSIS_H7_DIR)/Source/Templates/system_stm32h7xx.c
#HAL_LL_SRCS = $(wildcard $(HAL_LL_DIR)/Src/stm32h7xx_ll*.c)
C_SOURCES = $(PRJ_SRCS)
C_SOURCES += $(SDK_SRCS)
C_SOURCES += $(HAL_LL_DIR)/Src/stm32h7xx_ll_exti.c
C_SOURCES += $(HAL_LL_DIR)/Src/stm32h7xx_ll_gpio.c
C_SOURCES += $(HAL_LL_DIR)/Src/stm32h7xx_ll_rcc.c
C_SOURCES += $(HAL_LL_DIR)/Src/stm32h7xx_ll_utils.c
C_SOURCES += $(HAL_LL_DIR)/Src/stm32h7xx_ll_pwr.c

PRJ_INC_DIR = inc/
ASM_FILE_DIR = $(CMSIS_H7_DIR)/Source/Templates/gcc
ASM_FILE = $(ASM_FILE_DIR)/startup_stm32h743xx.s

CPU = -mcpu=cortex-m7
FPU = -mfpu=fpv5-d16
FLOAT-ABI = -mfloat-abi=hard
MCU = $(CPU) -mthumb $(FPU) $(FLOAT-ABI)
OPT = -Og

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

C_INCLUDES =  \
-I$(PRJ_INC_DIR) \
-I$(HAL_LL_DIR)/Inc/ \
-I$(CMSIS_H7_DIR)/Include \
-I$(CMSIS_CORE_DIR)/Include

ASFLAGS = $(MCU) $(AS_DEFS) $(AS_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections
CFLAGS += $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections -g -gdwarf-2

# Generate dependency information
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)"

# libraries
LIBS = -lc -lm -lnosys 
LIBDIR = 
LDFLAGS = $(MCU) -specs=nano.specs -T$(LDSCRIPT) $(LIBDIR) $(LIBS) -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref -Wl,--gc-sections


all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin

# list of objects
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))
# list of ASM program objects
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_FILE:.s=.o)))
vpath %.s $(sort $(dir $(ASM_FILE)))

$(BUILD_DIR)/%.o: %.c makefile | $(BUILD_DIR) 
	$(ARM_CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

$(BUILD_DIR)/%.o: %.s makefile | $(BUILD_DIR)
	$(ARM_AS) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) makefile
	$(ARM_CC) $(OBJECTS) $(LDFLAGS) -o $@
	$(ARM_SZ) $@

$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(HEX) $< $@
	
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(BIN) $< $@	
	
$(BUILD_DIR):
	mkdir $@

clean:
	-rm -fR $(BUILD_DIR)

info:
	@echo "PRJ_SRCS = $(PRJ_SRCS)"
	@echo "ASM_FILE = $(ASM_FILE)"

msg: $(BUILD_DIR)
	$(ARM_LD) --version

load:
	openocd -f interface/stlink.cfg -f target/stm32h7x.cfg -c "program $(BUILD_DIR)/$(TARGET).elf verify reset exit"

debug:
	$(ARM_DB) target remote localhost:3333

.PHONY: info, msg, clean, all, load, debug

-include $(wildcard $(BUILD_DIR)/*.d)