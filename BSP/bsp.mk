HAL_LL_INC_DIR = $(SDK_DIR)/stm32h7xx_hal_driver/Inc
HAL_LL_SRC_DIR = $(SDK_DIR)/stm32h7xx_hal_driver/Src

include ../BSP/Assert/bsp_assert.mk
include ../BSP/Led/bsp_led.mk # NOT IMPLEMENTED
include ../BSP/System/bsp_system.mk
include ../BSP/Timer/bsp_timer.mk # NOT IMPLEMENTED

bsp_build: bsp_system bsp_assert
