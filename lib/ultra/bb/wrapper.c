#include "ultra64.h"

#ifdef BBPLAYER
// Those functions are removed in 2.0J onwards so their
// usage is replaced by __osMotorAccess through a macro.
// iQue adds backs these as a function for some reason,
// so add an underscore to differentiate it from the macro.
s32 __osMotorStart(OSPfs *pfs) {
    return __osMotorAccess(pfs, MOTOR_START);
}

s32 __osMotorStop(OSPfs *pfs) {
    return __osMotorAccess(pfs, MOTOR_STOP);
}

static void osInitializeWrapper(void) {
    __osInitialize_common();
    __osInitialize_autodetect();
}

void osInitialize(void) {
    osInitializeWrapper();
}
#endif
