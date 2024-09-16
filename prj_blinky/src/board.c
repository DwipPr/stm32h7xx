#include "board.h"
#include "SystemApi.h"
//#include "Led/LedApi.h"
//#include "Timer/TimerApi.h"

void BSP_Init(void)
{
    BSP_ClockConfig();
    //BSP_LedConfig(BSP_LED_0);
    //BSP_TimerConfig(BSP_TIMER_0);
    return;
}