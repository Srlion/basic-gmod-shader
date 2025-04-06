#include "common.hlsl"

#define P1 Constants0.x
#define P2 Constants0.y
#define P3 Constants0.z
#define P4 Constants0.w
#define P5 Constants1.x
#define P6 Constants1.y
#define P7 Constants1.z
#define P8 Constants1.w
#define P9 Constants2.x
#define P10 Constants2.y
#define P11 Constants2.z
#define P12 Constants2.w
#define P13 Constants3.x
#define P14 Constants3.y
#define P15 Constants3.z
#define P16 Constants3.w

float4 main(PS_INPUT i) : COLOR {
    // return a color based on what the user passes in
    return float4(P1, P2, P3, P4);
}
