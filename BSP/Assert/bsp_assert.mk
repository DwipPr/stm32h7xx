BSP_BLOCK_NAME = Assert

BSP_BLOCK_DIR = ../BSP/$(BSP_BLOCK_NAME)
BSP_BLOCK_IMP_DIR = $(BSP_BLOCK_DIR)

ifeq ($(wildcard $(BSP_BLOCK_IMP_DIR)),)
$(error Folder for project '$(TARGET)' not found in $(BSP_BLOCK_DIR))
endif

BSP_BLOCK_SOURCES = $(wildcard $(BSP_BLOCK_IMP_DIR)/*.c)
BSP_BLOCK_OBJECTS = $(BSP_BLOCK_SOURCES:.c=.o)

BSP_SDK_INCLUDES = $(HAL_LL_INC_DIR)
BSP_BLOCK_INCLUDES = $(BSP_BLOCK_IMP_DIR) #!

$(info BSP_BLOCK_SOURCES (ASSERT) = $(BSP_BLOCK_SOURCES))
$(info BSP_BLOCK_OBJECTS (ASSERT) = $(BSP_BLOCK_OBJECTS))

BSP_BLOCK_OBJECTS = $(addprefix $(OBJ_DIR)/,$(notdir $(BSP_BLOCK_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(BSP_BLOCK_SOURCES)))

C_INCLUDES += -I$(BSP_BLOCK_DIR)
C_INCLUDES += -I$(BSP_BLOCK_IMP_DIR)
C_INCLUDES += -I$(BSP_SDK_INCLUDES)
# при компиляции, необходимо определять заголовочные файлы этого конкретного модуля
# ../BSP/Assert

$(OBJ_DIR)/%.o: %.c makefile | $(OBJ_DIR)
	$(ARM_CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(OBJ_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

bsp_assert: $(BSP_BLOCK_OBJECTS)
	@echo "Building BSP Assert for project: $(TARGET)"