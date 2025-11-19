#include "PR/os_version.h"

#if LIBULTRA_VERSION >= OS_VER_J
#include "J_L.inc"
#elif LIBULTRA_VERSION >= OS_VER_F
#include "F_I.inc"
#elif LIBULTRA_VERSION >= OS_VER_D
#include "D.inc"
#endif
