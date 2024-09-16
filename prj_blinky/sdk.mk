
CMSIS_CORE_DIR = $(SDK_DIR)/cmsis-core
CMSIS_H7_DIR = $(SDK_DIR)/cmsis_device_h7

ASM_CORE_SOURCES += $(CMSIS_H7_DIR)/Source/Templates/gcc/startup_stm32h743xx.s
SDK_CORE_SOURCES += $(CMSIS_H7_DIR)/Source/Templates/system_stm32h7xx.c

C_INCLUDES += -I$(CMSIS_CORE_DIR)/Include
C_INCLUDES += -I$(CMSIS_H7_DIR)/Include

# list of objects
SDK_CORE_OBJECTS = $(addprefix $(OBJ_DIR)/,$(notdir $(SDK_CORE_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(SDK_CORE_SOURCES)))
# list of ASM program objects
SDK_CORE_OBJECTS += $(addprefix $(OBJ_DIR)/,$(notdir $(ASM_CORE_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_CORE_SOURCES)))

$(info ASM_CORE_SOURCES (SDK) = $(ASM_CORE_SOURCES))
$(info SDK_CORE_SOURCES (SDK) = $(SDK_CORE_SOURCES))
$(info SDK_CORE_OBJECTS (SDK) = $(SDK_CORE_OBJECTS))

$(OBJ_DIR)/%.o: %.c sdk.mk | $(OBJ_DIR)
	$(ARM_CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(OBJ_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

$(OBJ_DIR)/%.o: %.s sdk.mk | $(OBJ_DIR)
	$(ARM_AS) -c $(CFLAGS) $< -o $@

sdk_core: $(SDK_CORE_OBJECTS)
	@echo "Building SDK Core for project: $(TARGET)"
