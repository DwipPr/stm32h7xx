BSP_BLOCK_NAME = System

BSP_BLOCK_DIR = ../BSP/$(BSP_BLOCK_NAME)
BSP_BLOCK_IMP_DIR = $(BSP_BLOCK_DIR)/$(TARGET)

ifeq ($(wildcard $(BSP_BLOCK_IMP_DIR)),)
$(error Folder for project '$(TARGET)' not found in $(BSP_BLOCK_DIR))
endif

BSP_SYSTEM_SDK_SOURCES += $(HAL_LL_SRC_DIR)/stm32h7xx_ll_rcc.c
BSP_SYSTEM_SDK_SOURCES += $(HAL_LL_SRC_DIR)/stm32h7xx_ll_pwr.c
BSP_SYSTEM_SDK_SOURCES += $(HAL_LL_SRC_DIR)/stm32h7xx_ll_utils.c

BSP_BLOCK_SOURCES = $(wildcard $(BSP_BLOCK_IMP_DIR)/*.c)

ifneq ($(BSP_BLOCK_SOURCES), 0)
BSP_BLOCK_SOURCES += $(BSP_SYSTEM_SDK_SOURCES)
endif

BSP_BLOCK_OBJECTS = $(BSP_BLOCK_SOURCES:.c=.o)

BSP_SDK_INCLUDES = $(HAL_LL_INC_DIR)
BSP_BLOCK_INCLUDES = $(BSP_BLOCK_IMP_DIR)

$(info BSP_BLOCK_SOURCES (SYSTEM) = $(BSP_BLOCK_SOURCES))
$(info BSP_BLOCK_OBJECTS (SYSTEM) = $(BSP_BLOCK_OBJECTS))

BSP_BLOCK_OBJECTS = $(addprefix $(OBJ_DIR)/,$(notdir $(BSP_BLOCK_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(BSP_BLOCK_SOURCES)))

C_INCLUDES += -I$(BSP_BLOCK_DIR)
C_INCLUDES += -I$(BSP_BLOCK_IMP_DIR)
C_INCLUDES += -I$(BSP_SDK_INCLUDES)
# при компиляции, необходимо определять пути до заголовочных файлов этого конкретного модуля
# ../BSP/System/$(prj_name)
# ../../SDK/stm32h7xx_hal_driver/Inc
# и тд
# в идеале если в bsp.mk будет определена переменная с путями, а в этих файлах она будет дополняться
# include'ом этого конкретного драйвера

$(OBJ_DIR)/%.o: %.c makefile | $(OBJ_DIR)
	$(ARM_CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(OBJ_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

bsp_system: $(BSP_BLOCK_OBJECTS)
	@echo "Building BSP System for project: $(TARGET)"