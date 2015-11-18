// 64-bit helper from <tgmath.h>
// Extracted because those overrides won't work with Modules.

#import <tgmath.h>

#undef fmin
#define fmin(__x, __y) __tg_fmin(__tg_promote2((__x), (__y))(__x), \
__tg_promote2((__x), (__y))(__y))

#undef fmax
#define fmax(__x, __y) __tg_fmax(__tg_promote2((__x), (__y))(__x), \
__tg_promote2((__x), (__y))(__y))

#undef floor
#define floor(__x) __tg_floor(__tg_promote1((__x))(__x))

#undef ceil
#define ceil(__x) __tg_ceil(__tg_promote1((__x))(__x))

#undef fabs
#define fabs(__x) __tg_fabs(__tg_promote1((__x))(__x))

#undef round
#define round(__x) __tg_round(__tg_promote1((__x))(__x))

#undef sqrt
#define sqrt(__x) __tg_sqrt(__tg_promote1((__x))(__x))

#undef pow
#define pow(__x, __y) __tg_pow(__tg_promote2((__x), (__y))(__x), \
__tg_promote2((__x), (__y))(__y))

#undef cos
#define cos(__x) __tg_cos(__tg_promote1((__x))(__x))

#undef sin
#define sin(__x) __tg_sin(__tg_promote1((__x))(__x))

#undef asin
#define asin(__x) __tg_asin(__tg_promote1((__x))(__x))

#undef acos
#define acos(__x) __tg_acos(__tg_promote1((__x))(__x))

#undef rint
#define rint(__x) __tg_rint(__tg_promote1((__x))(__x))

#undef atan2
#define atan2(__x, __y) __tg_atan2(__tg_promote2((__x), (__y))(__x), \
__tg_promote2((__x), (__y))(__y))
