    .text
    .global _gemm_micro_64_16_2
    .align 4
_gemm_micro_64_16_2:

    // store
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!
    stp x23, x24, [sp, #-16]!
    stp x25, x26, [sp, #-16]!
    stp x27, x28, [sp, #-16]!
    stp x29, x30, [sp, #-16]!

    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

    smstart
    ptrue p0.s
    ptrue p1.s

    // load first column of A
    ldr z0, [x0]
    add x0, x0, #16*4
    ldr z1, [x0]
    add x0, x0, #16*4
    ldr z2, [x0]
    add x0, x0, #16*4
    ldr z3, [x0]
    add x0, x0, #16*4

    // load first row of B
    ldr z30, [x1]
    add x1, x1, #16*4

    // compute outer products
    fmopa za0.s, p0/m, p1/m, z30.s, z0.s
    fmopa za1.s, p0/m, p1/m, z30.s, z1.s
    fmopa za2.s, p0/m, p1/m, z30.s, z2.s
    fmopa za3.s, p0/m, p1/m, z30.s, z3.s

    // load second column of A
    ldr z4, [x0]
    add x0, x0, #16*4
    ldr z5, [x0]
    add x0, x0, #16*4
    ldr z6, [x0]
    add x0, x0, #16*4
    ldr z7, [x0]

    // load second row of B
    ldr z31, [x1]
    add x1, x1, #16*4

    // compute outer products
    fmopa za0.s, p0/m, p1/m, z31.s, z4.s
    fmopa za1.s, p0/m, p1/m, z31.s, z5.s
    fmopa za2.s, p0/m, p1/m, z31.s, z6.s
    fmopa za3.s, p0/m, p1/m, z31.s, z7.s

    // write results
    mov x3, #16

    add x4, x2, #0
    add x5, x2, #16*4
    add x6, x2, #32*4
    add x7, x2, #48*4

    mov w12, #0
    mov w13, #1
    mov w14, #2
    mov w15, #3

loop_write_gemm_micro_64_16_2:
    str za[w12, #0], [x4]
    str za[w13, #0], [x5]
    str za[w14, #0], [x6]
    str za[w15, #0], [x7]

    add w12, w12, #4
    add w13, w13, #4
    add w14, w14, #4
    add w15, w15, #4

    add x4, x4, #64*4
    add x5, x5, #64*4
    add x6, x6, #64*4
    add x7, x7, #64*4

    sub x3, x3, #1

    cbnz x3, loop_write_gemm_micro_64_16_2

    smstop

    // restore
    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    ldp x29, x30, [sp], #16
    ldp x27, x28, [sp], #16
    ldp x25, x26, [sp], #16
    ldp x23, x24, [sp], #16
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16

    ret


    .align 4
    .global _gemm_micro_32_32_32
_gemm_micro_32_32_32:
    // PCS: store
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

    smstart
    // save adress of c
    mov x9, x2

    // k loop register
    mov x6, #32 

    // x4 adress of tile 2
    add x4, x2, #2048

    // load C
    mov w12, #0
    mov w13, #1
    mov w14, #2
    mov w15, #3

    ptrue p0.b
    ptrue p1.b
    ptrue pn8.b

    ld1w { z0.s, z8.s }, pn8/z, [x2]
    add x2, x2, #128
    ld1w { z1.s, z9.s }, pn8/z, [x2]
    add x2, x2, #128
    ld1w { z2.s, z10.s }, pn8/z, [x2]
    add x2, x2, #128
    ld1w { z3.s, z11.s }, pn8/z, [x2]
    add x2, x2, #128

    ld1w { z4.s, z12.s }, pn8/z, [x2]
    add x2, x2, #128
    ld1w { z5.s, z13.s }, pn8/z, [x2]
    add x2, x2, #128
    ld1w { z6.s, z14.s }, pn8/z, [x2]
    add x2, x2, #128
    ld1w { z7.s, z15.s }, pn8/z, [x2]
    add x2, x2, #128

    ld1w { z16.s, z24.s }, pn8/z, [x2]
    add x2, x2, #128
    ld1w { z17.s, z25.s }, pn8/z, [x2]
    add x2, x2, #128
    ld1w { z18.s, z26.s }, pn8/z, [x2]
    add x2, x2, #128
    ld1w { z19.s, z27.s }, pn8/z, [x2]
    add x2, x2, #128

    ld1w { z20.s, z28.s }, pn8/z, [x2]
    add x2, x2, #128
    ld1w { z21.s, z29.s }, pn8/z, [x2]
    add x2, x2, #128
    ld1w { z22.s, z30.s }, pn8/z, [x2]
    add x2, x2, #128
    ld1w { z23.s, z31.s }, pn8/z, [x2]

    mov	za0h.s[w12, 0:3], { z0.s - z3.s }  
    add w12, w12, #4  
    mov	za0h.s[w12, 0:3], { z4.s - z7.s }
    add w12, w12, #4
    mov	za0h.s[w12, 0:3], { z16.s - z19.s }
    add w12, w12, #4
    mov	za0h.s[w12, 0:3], { z20.s - z23.s }

    mov za1h.s[w13, 0:3], { z8.s - z11.s }  
    add w13, w13, #4  
    mov za1h.s[w13, 0:3], { z12.s - z15.s }
    add w13, w13, #4
    mov za1h.s[w13, 0:3], { z24.s - z27.s }
    add w13, w13, #4
    mov za1h.s[w13, 0:3], { z28.s - z31.s }


    ld1w { z0.s, z8.s }, pn8/z, [x4]
    add x4, x4, #128
    ld1w { z1.s, z9.s }, pn8/z, [x4]
    add x4, x4, #128
    ld1w { z2.s, z10.s }, pn8/z, [x4]
    add x4, x4, #128
    ld1w { z3.s, z11.s }, pn8/z, [x4]
    add x4, x4, #128

    ld1w { z4.s, z12.s }, pn8/z, [x4]
    add x4, x4, #128
    ld1w { z5.s, z13.s }, pn8/z, [x4]
    add x4, x4, #128
    ld1w { z6.s, z14.s }, pn8/z, [x4]
    add x4, x4, #128
    ld1w { z7.s, z15.s }, pn8/z, [x4]
    add x4, x4, #128

    ld1w { z16.s, z24.s }, pn8/z, [x4]
    add x4, x4, #128
    ld1w { z17.s, z25.s }, pn8/z, [x4]
    add x4, x4, #128
    ld1w { z18.s, z26.s }, pn8/z, [x4]
    add x4, x4, #128
    ld1w { z19.s, z27.s }, pn8/z, [x4]
    add x4, x4, #128

    ld1w { z20.s, z28.s }, pn8/z, [x4]
    add x4, x4, #128
    ld1w { z21.s, z29.s }, pn8/z, [x4]
    add x4, x4, #128
    ld1w { z22.s, z30.s }, pn8/z, [x4]
    add x4, x4, #128
    ld1w { z23.s, z31.s }, pn8/z, [x4]

    mov	za2h.s[w14, 0:3], { z0.s - z3.s }  
    add w14, w14, #4
    mov	za2h.s[w14, 0:3], { z4.s - z7.s }
    add w14, w14, #4
    mov	za2h.s[w14, 0:3], { z16.s - z19.s }
    add w14, w14, #4
    mov	za2h.s[w14, 0:3], { z20.s - z23.s }

    mov za3h.s[w15, 0:3], { z8.s - z11.s }  
    add w15, w15, #4  
    mov za3h.s[w15, 0:3], { z12.s - z15.s }
    add w15, w15, #4
    mov za3h.s[w15, 0:3], { z24.s - z27.s }
    add w15, w15, #4
    mov za3h.s[w15, 0:3], { z28.s - z31.s }

  
loop_32_32_k:

    sub x6, x6, #1

    // load a
    ldr z0, [x0]
    add x0, x0, #64
    ldr z1, [x0]
    add x0, x0, #64

    // load b
    ldr z2, [x1]
    add x1, x1, #64
    ldr z3, [x1]
    add x1, x1, #64

    //      c                 b     a
    fmopa za0.s, p0/m, p1/m, z2.s, z0.s
    fmopa za1.s, p0/m, p1/m, z2.s, z1.s
    fmopa za2.s, p0/m, p1/m, z3.s, z0.s
    fmopa za3.s, p0/m, p1/m, z3.s, z1.s


    cbnz x6, loop_32_32_k

    mov x2, x9
    add x4, x9, #2048

    // store C
    mov w12, #0
    mov w13, #1
    mov w14, #2
    mov w15, #3


    mov	{ z0.s - z3.s }, za0h.s[w12, 0:3]
    add w12, w12, #4  
    mov	{ z4.s - z7.s }, za0h.s[w12, 0:3]
    add w12, w12, #4
    mov	{ z16.s - z19.s }, za0h.s[w12, 0:3]
    add w12, w12, #4
    mov	{ z20.s - z23.s }, za0h.s[w12, 0:3]

    mov { z8.s - z11.s }, za1h.s[w13, 0:3]
    add w13, w13, #4  
    mov { z12.s - z15.s }, za1h.s[w13, 0:3]
    add w13, w13, #4
    mov { z24.s - z27.s }, za1h.s[w13, 0:3]
    add w13, w13, #4
    mov { z28.s - z31.s }, za1h.s[w13, 0:3]

    st1w { z0.s, z8.s }, pn8, [x2]
    add x2, x2, #128
    st1w { z1.s, z9.s }, pn8, [x2]
    add x2, x2, #128
    st1w { z2.s, z10.s }, pn8, [x2]
    add x2, x2, #128
    st1w { z3.s, z11.s }, pn8, [x2]
    add x2, x2, #128

    st1w { z4.s, z12.s }, pn8, [x2]
    add x2, x2, #128
    st1w { z5.s, z13.s }, pn8, [x2]
    add x2, x2, #128
    st1w { z6.s, z14.s }, pn8, [x2]
    add x2, x2, #128
    st1w { z7.s, z15.s }, pn8, [x2]
    add x2, x2, #128

    st1w { z16.s, z24.s }, pn8, [x2]
    add x2, x2, #128
    st1w { z17.s, z25.s }, pn8, [x2]
    add x2, x2, #128
    st1w { z18.s, z26.s }, pn8, [x2]
    add x2, x2, #128
    st1w { z19.s, z27.s }, pn8, [x2]
    add x2, x2, #128

    st1w { z20.s, z28.s }, pn8, [x2]
    add x2, x2, #128
    st1w { z21.s, z29.s }, pn8, [x2]
    add x2, x2, #128
    st1w { z22.s, z30.s }, pn8, [x2]
    add x2, x2, #128
    st1w { z23.s, z31.s }, pn8, [x2]

    mov	{ z0.s - z3.s }, za2h.s[w14, 0:3]
    add w14, w14, #4  
    mov	{ z4.s - z7.s }, za2h.s[w14, 0:3]
    add w14, w14, #4
    mov	{ z16.s - z19.s }, za2h.s[w14, 0:3]
    add w14, w14, #4
    mov	{ z20.s - z23.s }, za2h.s[w14, 0:3]

    mov { z8.s - z11.s }, za3h.s[w15, 0:3]
    add w15, w15, #4  
    mov { z12.s - z15.s }, za3h.s[w15, 0:3]
    add w15, w15, #4
    mov { z24.s - z27.s }, za3h.s[w15, 0:3]
    add w15, w15, #4
    mov { z28.s - z31.s }, za3h.s[w15, 0:3]

    st1w { z0.s, z8.s }, pn8, [x4]
    add x4, x4, #128
    st1w { z1.s, z9.s }, pn8, [x4]
    add x4, x4, #128
    st1w { z2.s, z10.s }, pn8, [x4]
    add x4, x4, #128
    st1w { z3.s, z11.s }, pn8, [x4]
    add x4, x4, #128

    st1w { z4.s, z12.s }, pn8, [x4]
    add x4, x4, #128
    st1w { z5.s, z13.s }, pn8, [x4]
    add x4, x4, #128
    st1w { z6.s, z14.s }, pn8, [x4]
    add x4, x4, #128
    st1w { z7.s, z15.s }, pn8, [x4]
    add x4, x4, #128

    st1w { z16.s, z24.s }, pn8, [x4]
    add x4, x4, #128
    st1w { z17.s, z25.s }, pn8, [x4]
    add x4, x4, #128
    st1w { z18.s, z26.s }, pn8, [x4]
    add x4, x4, #128
    st1w { z19.s, z27.s }, pn8, [x4]
    add x4, x4, #128

    st1w { z20.s, z28.s }, pn8, [x4]
    add x4, x4, #128
    st1w { z21.s, z29.s }, pn8, [x4]
    add x4, x4, #128
    st1w { z22.s, z30.s }, pn8, [x4]
    add x4, x4, #128
    st1w { z23.s, z31.s }, pn8, [x4]

    smstop

    // PCS: restore
    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    ret 


    .align 4
    .global _gemm_micro_31_32_32
_gemm_micro_31_32_32:

    // PCS: store
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

    smstart
    // save adress of c
    mov x9, x2

    // loop register
    mov x6, #32

    // x2 adress of tile 0
    // x3 adress of tile 1
    add x3, x2, #64

    // x4 adress of tile 2
    add x4, x2, #1984

    // x5 adress of tile 3
    add x5, x2, #2048

    ptrue p0.b
    ptrue pn8.b

    mov x10, #1
    mov x11, #16
    whilelt p1.s, x10, x11


    // load C
    mov w12, #0
    mov w13, #1
    mov w14, #2
    mov w15, #3

    ld1w { z0.s  }, p0/z, [x2]
    add x2, x2, #64
    ld1w { z8.s }, p1/z, [x2]
    add x2, x2, #60
    ld1w { z1.s }, p0/z, [x2]
    add x2, x2, #64
    ld1w { z9.s }, p1/z, [x2]
    add x2, x2, #60
    ld1w { z2.s  }, p0/z, [x2]
    add x2, x2, #64
    ld1w { z10.s }, p1/z, [x2]
    add x2, x2, #60
    ld1w { z3.s }, p0/z, [x2]
    add x2, x2, #64
    ld1w { z11.s }, p1/z, [x2]
    add x2, x2, #60

    ld1w { z4.s  }, p0/z, [x2]
    add x2, x2, #64
    ld1w { z12.s }, p1/z, [x2]
    add x2, x2, #60
    ld1w { z5.s }, p0/z, [x2]
    add x2, x2, #64
    ld1w { z13.s }, p1/z, [x2]
    add x2, x2, #60
    ld1w { z6.s  }, p0/z, [x2]
    add x2, x2, #64
    ld1w { z14.s }, p1/z, [x2]
    add x2, x2, #60
    ld1w { z7.s }, p0/z, [x2]
    add x2, x2, #64
    ld1w { z15.s }, p1/z, [x2]
    add x2, x2, #60

    ld1w { z16.s  }, p0/z, [x2]
    add x2, x2, #64
    ld1w { z24.s }, p1/z, [x2]
    add x2, x2, #60
    ld1w { z17.s }, p0/z, [x2]
    add x2, x2, #64
    ld1w { z25.s }, p1/z, [x2]
    add x2, x2, #60
    ld1w { z18.s  }, p0/z, [x2]
    add x2, x2, #64
    ld1w { z26.s }, p1/z, [x2]
    add x2, x2, #60
    ld1w { z19.s }, p0/z, [x2]
    add x2, x2, #64
    ld1w { z27.s }, p1/z, [x2]
    add x2, x2, #60

    ld1w { z20.s  }, p0/z, [x2]
    add x2, x2, #64
    ld1w { z28.s }, p1/z, [x2]
    add x2, x2, #60
    ld1w { z21.s }, p0/z, [x2]
    add x2, x2, #64
    ld1w { z29.s }, p1/z, [x2]
    add x2, x2, #60
    ld1w { z22.s  }, p0/z, [x2]
    add x2, x2, #64
    ld1w { z30.s }, p1/z, [x2]
    add x2, x2, #60
    ld1w { z23.s }, p0/z, [x2]
    add x2, x2, #64
    ld1w { z31.s }, p1/z, [x2]

    mov	za0h.s[w12, 0:3], { z0.s - z3.s }  
    add w12, w12, #4  
    mov	za0h.s[w12, 0:3], { z4.s - z7.s }
    add w12, w12, #4
    mov	za0h.s[w12, 0:3], { z16.s - z19.s }
    add w12, w12, #4
    mov	za0h.s[w12, 0:3], { z20.s - z23.s }

    mov za1h.s[w13, 0:3], { z8.s - z11.s }  
    add w13, w13, #4  
    mov za1h.s[w13, 0:3], { z12.s - z15.s }
    add w13, w13, #4
    mov za1h.s[w13, 0:3], { z24.s - z27.s }
    add w13, w13, #4
    mov za1h.s[w13, 0:3], { z28.s - z31.s }


    ld1w { z0.s  }, p0/z, [x4]
    add x4, x4, #64
    ld1w { z8.s }, p1/z, [x4]
    add x4, x4, #60
    ld1w { z1.s }, p0/z, [x4]
    add x4, x4, #64
    ld1w { z9.s }, p1/z, [x4]
    add x4, x4, #60
    ld1w { z2.s  }, p0/z, [x4]
    add x4, x4, #64
    ld1w { z10.s }, p1/z, [x4]
    add x4, x4, #60
    ld1w { z3.s }, p0/z, [x4]
    add x4, x4, #64
    ld1w { z11.s }, p1/z, [x4]
    add x4, x4, #60

    ld1w { z4.s  }, p0/z, [x4]
    add x4, x4, #64
    ld1w { z12.s }, p1/z, [x4]
    add x4, x4, #60
    ld1w { z5.s }, p0/z, [x4]
    add x4, x4, #64
    ld1w { z13.s }, p1/z, [x4]
    add x4, x4, #60
    ld1w { z6.s  }, p0/z, [x4]
    add x4, x4, #64
    ld1w { z14.s }, p1/z, [x4]
    add x4, x4, #60
    ld1w { z7.s }, p0/z, [x4]
    add x4, x4, #64
    ld1w { z15.s }, p1/z, [x4]
    add x4, x4, #60

    ld1w { z16.s  }, p0/z, [x4]
    add x4, x4, #64
    ld1w { z24.s }, p1/z, [x4]
    add x4, x4, #60
    ld1w { z17.s }, p0/z, [x4]
    add x4, x4, #64
    ld1w { z25.s }, p1/z, [x4]
    add x4, x4, #60
    ld1w { z18.s  }, p0/z, [x4]
    add x4, x4, #64
    ld1w { z26.s }, p1/z, [x4]
    add x4, x4, #60
    ld1w { z19.s }, p0/z, [x4]
    add x4, x4, #64
    ld1w { z27.s }, p1/z, [x4]
    add x4, x4, #60

    ld1w { z20.s  }, p0/z, [x4]
    add x4, x4, #64
    ld1w { z28.s }, p1/z, [x4]
    add x4, x4, #60
    ld1w { z21.s }, p0/z, [x4]
    add x4, x4, #64
    ld1w { z29.s }, p1/z, [x4]
    add x4, x4, #60
    ld1w { z22.s  }, p0/z, [x4]
    add x4, x4, #64
    ld1w { z30.s }, p1/z, [x4]
    add x4, x4, #60
    ld1w { z23.s }, p0/z, [x4]
    add x4, x4, #64
    ld1w { z31.s }, p1/z, [x4]

    mov	za2h.s[w14, 0:3], { z0.s - z3.s }  
    add w14, w14, #4
    mov	za2h.s[w14, 0:3], { z4.s - z7.s }
    add w14, w14, #4
    mov	za2h.s[w14, 0:3], { z16.s - z19.s }
    add w14, w14, #4
    mov	za2h.s[w14, 0:3], { z20.s - z23.s }

    mov za3h.s[w15, 0:3], { z8.s - z11.s }  
    add w15, w15, #4  
    mov za3h.s[w15, 0:3], { z12.s - z15.s }
    add w15, w15, #4
    mov za3h.s[w15, 0:3], { z24.s - z27.s }
    add w15, w15, #4
    mov za3h.s[w15, 0:3], { z28.s - z31.s }
  
loop_31_32_k:

    sub x6, x6, #1

    // load a
    ld1w { z0.s, z1.s }, pn8/z,  [x0]
    add x0, x0, #124

    // load b
    ld1w { z2.s, z3.s }, pn8/z, [x1]
    add x1, x1, #128

    //      c                 b     a
    fmopa za0.s, p0/m, p0/m, z2.s, z0.s
    fmopa za1.s, p0/m, p1/m, z2.s, z1.s
    fmopa za2.s, p0/m, p0/m, z3.s, z0.s
    fmopa za3.s, p0/m, p1/m, z3.s, z1.s

    cbnz x6, loop_31_32_k

    mov x2, x9
    add x3, x9, #64
    add x4, x9, #1984
    add x5, x9, #2048

    // store C
    mov w12, #0
    mov w13, #1
    mov w14, #2
    mov w15, #3

    mov	{ z0.s - z3.s }, za0h.s[w12, 0:3] 
    add w12, w12, #4  
    mov	{ z4.s - z7.s }, za0h.s[w12, 0:3]
    add w12, w12, #4
    mov	{ z16.s - z19.s }, za0h.s[w12, 0:3]
    add w12, w12, #4
    mov	{ z20.s - z23.s }, za0h.s[w12, 0:3]

    mov { z8.s - z11.s }, za1h.s[w13, 0:3]
    add w13, w13, #4  
    mov { z12.s - z15.s }, za1h.s[w13, 0:3]
    add w13, w13, #4
    mov { z24.s - z27.s }, za1h.s[w13, 0:3]
    add w13, w13, #4
    mov { z28.s - z31.s }, za1h.s[w13, 0:3]

    st1w { z0.s  }, p0, [x2]
    add x2, x2, #64
    st1w { z8.s }, p1, [x2]
    add x2, x2, #60
    st1w { z1.s }, p0, [x2]
    add x2, x2, #64
    st1w { z9.s }, p1, [x2]
    add x2, x2, #60
    st1w { z2.s  }, p0, [x2]
    add x2, x2, #64
    st1w { z10.s }, p1, [x2]
    add x2, x2, #60
    st1w { z3.s }, p0, [x2]
    add x2, x2, #64
    st1w { z11.s }, p1, [x2]
    add x2, x2, #60

    st1w { z4.s  }, p0, [x2]
    add x2, x2, #64
    st1w { z12.s }, p1, [x2]
    add x2, x2, #60
    st1w { z5.s }, p0, [x2]
    add x2, x2, #64
    st1w { z13.s }, p1, [x2]
    add x2, x2, #60
    st1w { z6.s  }, p0, [x2]
    add x2, x2, #64
    st1w { z14.s }, p1, [x2]
    add x2, x2, #60
    st1w { z7.s }, p0, [x2]
    add x2, x2, #64
    st1w { z15.s }, p1, [x2]
    add x2, x2, #60

    st1w { z16.s  }, p0, [x2]
    add x2, x2, #64
    st1w { z24.s }, p1, [x2]
    add x2, x2, #60
    st1w { z17.s }, p0, [x2]
    add x2, x2, #64
    st1w { z25.s }, p1, [x2]
    add x2, x2, #60
    st1w { z18.s  }, p0, [x2]
    add x2, x2, #64
    st1w { z26.s }, p1, [x2]
    add x2, x2, #60
    st1w { z19.s }, p0, [x2]
    add x2, x2, #64
    st1w { z27.s }, p1, [x2]
    add x2, x2, #60

    st1w { z20.s  }, p0, [x2]
    add x2, x2, #64
    st1w { z28.s }, p1, [x2]
    add x2, x2, #60
    st1w { z21.s }, p0, [x2]
    add x2, x2, #64
    st1w { z29.s }, p1, [x2]
    add x2, x2, #60
    st1w { z22.s  }, p0, [x2]
    add x2, x2, #64
    st1w { z30.s }, p1, [x2]
    add x2, x2, #60
    st1w { z23.s }, p0, [x2]
    add x2, x2, #64
    st1w { z31.s }, p1, [x2]

    mov	{ z0.s - z3.s }, za2h.s[w14, 0:3]
    add w14, w14, #4  
    mov	{ z4.s - z7.s }, za2h.s[w14, 0:3]
    add w14, w14, #4
    mov	{ z16.s - z19.s }, za2h.s[w14, 0:3]
    add w14, w14, #4
    mov	{ z20.s - z23.s }, za2h.s[w14, 0:3]

    mov { z8.s - z11.s }, za3h.s[w15, 0:3]
    add w15, w15, #4  
    mov { z12.s - z15.s }, za3h.s[w15, 0:3]
    add w15, w15, #4
    mov { z24.s - z27.s }, za3h.s[w15, 0:3]
    add w15, w15, #4
    mov { z28.s - z31.s }, za3h.s[w15, 0:3]

    st1w { z0.s  }, p0, [x4]
    add x4, x4, #64
    st1w { z8.s }, p1, [x4]
    add x4, x4, #60
    st1w { z1.s }, p0, [x4]
    add x4, x4, #64
    st1w { z9.s }, p1, [x4]
    add x4, x4, #60
    st1w { z2.s  }, p0, [x4]
    add x4, x4, #64
    st1w { z10.s }, p1, [x4]
    add x4, x4, #60
    st1w { z3.s }, p0, [x4]
    add x4, x4, #64
    st1w { z11.s }, p1, [x4]
    add x4, x4, #60

    st1w { z4.s  }, p0, [x4]
    add x4, x4, #64
    st1w { z12.s }, p1, [x4]
    add x4, x4, #60
    st1w { z5.s }, p0, [x4]
    add x4, x4, #64
    st1w { z13.s }, p1, [x4]
    add x4, x4, #60
    st1w { z6.s  }, p0, [x4]
    add x4, x4, #64
    st1w { z14.s }, p1, [x4]
    add x4, x4, #60
    st1w { z7.s }, p0, [x4]
    add x4, x4, #64
    st1w { z15.s }, p1, [x4]
    add x4, x4, #60

    st1w { z16.s  }, p0, [x4]
    add x4, x4, #64
    st1w { z24.s }, p1, [x4]
    add x4, x4, #60
    st1w { z17.s }, p0, [x4]
    add x4, x4, #64
    st1w { z25.s }, p1, [x4]
    add x4, x4, #60
    st1w { z18.s  }, p0, [x4]
    add x4, x4, #64
    st1w { z26.s }, p1, [x4]
    add x4, x4, #60
    st1w { z19.s }, p0, [x4]
    add x4, x4, #64
    st1w { z27.s }, p1, [x4]
    add x4, x4, #60

    st1w { z20.s  }, p0, [x4]
    add x4, x4, #64
    st1w { z28.s }, p1, [x4]
    add x4, x4, #60
    st1w { z21.s }, p0, [x4]
    add x4, x4, #64
    st1w { z29.s }, p1, [x4]
    add x4, x4, #60
    st1w { z22.s  }, p0, [x4]
    add x4, x4, #64
    st1w { z30.s }, p1, [x4]
    add x4, x4, #60
    st1w { z23.s }, p0, [x4]
    add x4, x4, #64
    st1w { z31.s }, p1, [x4]

    smstop

    // PCS: restore
    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    ret

    .align 4
    .global _gemm_micro_32_no_trans 
_gemm_micro_32_no_trans:

    // PCS: store
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!
    mov x17, sp


    smstart
    // save adress of c
    mov x9, x2

    // Transpose B
    ptrue p0.b
    // save b adress
    mov x8, x1

    add x3, x8, #2048
    add x4, x8, #64
    add x5, x8, #2112

    mov w12, #0
    mov w13, #1
    mov w14, #2
    mov w15, #3

    mov x7, #16
    
load_b_for_trans:
    sub x7, x7, #1

    ldr za[w12, #0], [x1]
    ldr za[w13, #0], [x3]
    ldr za[w14, #0], [x4]
    ldr za[w15, #0], [x5]

    add w12, w12, #4
    add w13, w13, #4
    add w14, w14, #4
    add w15, w15, #4


    add x1, x1, #128
    add x3, x3, #128
    add x4, x4, #128
    add x5, x5, #128

    cbnz x7, load_b_for_trans

    mov w12, #0
    mov w13, #1
    mov w14, #2
    mov w15, #3


    mov { z0.s - z3.s }, za0v.s[w12, 0:3]
    add w12, w12, #4  
    mov { z4.s - z7.s }, za0v.s[w12, 0:3]
    add w12, w12, #4
    mov { z8.s - z11.s }, za0v.s[w12, 0:3]
    add w12, w12, #4
    mov { z12.s - z15.s }, za0v.s[w12, 0:3] 

    mov { z16.s - z19.s }, za1v.s[w13, 0:3]
    add w13, w13, #4  
    mov { z20.s - z23.s }, za1v.s[w13, 0:3]
    add w13, w13, #4
    mov { z24.s - z27.s }, za1v.s[w13, 0:3]
    add w13, w13, #4
    mov { z28.s - z31.s }, za1v.s[w13, 0:3] 

    // allocate memory on stack for transposed B 
    sub sp, sp, #64*64
    mov x1, sp
    lsr x1, x1, #7
    lsl x1, x1, #7
    mov sp, x1

    st1w { z0.s }, p0, [sp]
    add sp, sp, #64
    st1w { z16.s }, p0, [sp]
    add sp, sp, #64
    st1w { z1.s }, p0, [sp]
    add sp, sp, #64
    st1w { z17.s }, p0, [sp]
    add sp, sp, #64
    st1w { z2.s  }, p0, [sp]
    add sp, sp, #64
    st1w { z18.s }, p0, [sp]
    add sp, sp, #64
    st1w { z3.s }, p0, [sp]
    add sp, sp, #64
    st1w { z19.s }, p0, [sp]
    add sp, sp, #64

    st1w { z4.s  }, p0, [sp]
    add sp, sp, #64
    st1w { z20.s }, p0, [sp]
    add sp, sp, #64
    st1w { z5.s }, p0, [sp]
    add sp, sp, #64
    st1w { z21.s }, p0, [sp]
    add sp, sp, #64
    st1w { z6.s  }, p0, [sp]
    add sp, sp, #64
    st1w { z22.s }, p0, [sp]
    add sp, sp, #64
    st1w { z7.s }, p0, [sp]
    add sp, sp, #64
    st1w { z23.s }, p0, [sp]
    add sp, sp, #64
    
    st1w { z8.s  }, p0, [sp]
    add sp, sp, #64
    st1w { z24.s }, p0, [sp]
    add sp, sp, #64
    st1w { z9.s }, p0, [sp]
    add sp, sp, #64
    st1w { z25.s }, p0, [sp]
    add sp, sp, #64
    st1w { z10.s  }, p0, [sp]
    add sp, sp, #64
    st1w { z26.s }, p0, [sp]
    add sp, sp, #64
    st1w { z11.s }, p0, [sp]
    add sp, sp, #64
    st1w { z27.s }, p0, [sp]
    add sp, sp, #64

    st1w { z12.s  }, p0, [sp]
    add sp, sp, #64
    st1w { z28.s }, p0, [sp]
    add sp, sp, #64
    st1w { z13.s }, p0, [sp]
    add sp, sp, #64
    st1w { z29.s }, p0, [sp]
    add sp, sp, #64
    st1w { z14.s  }, p0, [sp]
    add sp, sp, #64
    st1w { z30.s }, p0, [sp]
    add sp, sp, #64
    st1w { z15.s }, p0, [sp]
    add sp, sp, #64
    st1w { z31.s }, p0, [sp]
    add sp, sp, #64

    mov { z0.s - z3.s }, za2v.s[w14, 0:3]
    add w14, w14, #4  
    mov { z4.s - z7.s }, za2v.s[w14, 0:3]
    add w14, w14, #4
    mov { z8.s - z11.s }, za2v.s[w14, 0:3]
    add w14, w14, #4
    mov { z12.s - z15.s }, za2v.s[w14, 0:3] 

    mov { z16.s - z19.s }, za3v.s[w15, 0:3]
    add w15, w15, #4  
    mov { z20.s - z23.s }, za3v.s[w15, 0:3]
    add w15, w15, #4
    mov { z24.s - z27.s }, za3v.s[w15, 0:3]
    add w15, w15, #4
    mov { z28.s - z31.s }, za3v.s[w15, 0:3] 

    
    st1w { z0.s  }, p0, [sp]
    add sp, sp, #64
    st1w { z16.s }, p0, [sp]
    add sp, sp, #64
    st1w { z1.s }, p0, [sp]
    add sp, sp, #64
    st1w { z17.s }, p0, [sp]
    add sp, sp, #64
    st1w { z2.s  }, p0, [sp]
    add sp, sp, #64
    st1w { z18.s }, p0, [sp]
    add sp, sp, #64
    st1w { z3.s }, p0, [sp]
    add sp, sp, #64
    st1w { z19.s }, p0, [sp]
    add sp, sp, #64

    st1w { z4.s  }, p0, [sp]
    add sp, sp, #64
    st1w { z20.s }, p0, [sp]
    add sp, sp, #64
    st1w { z5.s }, p0, [sp]
    add sp, sp, #64
    st1w { z21.s }, p0, [sp]
    add sp, sp, #64
    st1w { z6.s  }, p0, [sp]
    add sp, sp, #64
    st1w { z22.s }, p0, [sp]
    add sp, sp, #64
    st1w { z7.s }, p0, [sp]
    add sp, sp, #64
    st1w { z23.s }, p0, [sp]
    add sp, sp, #64

    st1w { z8.s  }, p0, [sp]
    add sp, sp, #64
    st1w { z24.s }, p0, [sp]
    add sp, sp, #64
    st1w { z9.s }, p0, [sp]
    add sp, sp, #64
    st1w { z25.s }, p0, [sp]
    add sp, sp, #64
    st1w { z10.s  }, p0, [sp]
    add sp, sp, #64
    st1w { z26.s }, p0, [sp]
    add sp, sp, #64
    st1w { z11.s }, p0, [sp]
    add sp, sp, #64
    st1w { z27.s }, p0, [sp]
    add sp, sp, #64

    st1w { z12.s  }, p0, [sp]
    add sp, sp, #64
    st1w { z28.s }, p0, [sp]
    add sp, sp, #64
    st1w { z13.s }, p0, [sp]
    add sp, sp, #64
    st1w { z29.s }, p0, [sp]
    add sp, sp, #64
    st1w { z14.s  }, p0, [sp]
    add sp, sp, #64
    st1w { z30.s }, p0, [sp]
    add sp, sp, #64
    st1w { z15.s }, p0, [sp]
    add sp, sp, #64
    st1w { z31.s }, p0, [sp]
    add sp, sp, #64

    // k loop register
    mov x6, #32 

    add x4, x2, #2048

    // load C
    mov w12, #0
    mov w13, #1
    mov w14, #2
    mov w15, #3

    ptrue p0.b
    ptrue p1.b
    ptrue pn8.b

    ld1w { z0.s, z8.s }, pn8/z, [x2]
    add x2, x2, #128
    ld1w { z1.s, z9.s }, pn8/z, [x2]
    add x2, x2, #128
    ld1w { z2.s, z10.s }, pn8/z, [x2]
    add x2, x2, #128
    ld1w { z3.s, z11.s }, pn8/z, [x2]
    add x2, x2, #128

    ld1w { z4.s, z12.s }, pn8/z, [x2]
    add x2, x2, #128
    ld1w { z5.s, z13.s }, pn8/z, [x2]
    add x2, x2, #128
    ld1w { z6.s, z14.s }, pn8/z, [x2]
    add x2, x2, #128
    ld1w { z7.s, z15.s }, pn8/z, [x2]
    add x2, x2, #128

    ld1w { z16.s, z24.s }, pn8/z, [x2]
    add x2, x2, #128
    ld1w { z17.s, z25.s }, pn8/z, [x2]
    add x2, x2, #128
    ld1w { z18.s, z26.s }, pn8/z, [x2]
    add x2, x2, #128
    ld1w { z19.s, z27.s }, pn8/z, [x2]
    add x2, x2, #128

    ld1w { z20.s, z28.s }, pn8/z, [x2]
    add x2, x2, #128
    ld1w { z21.s, z29.s }, pn8/z, [x2]
    add x2, x2, #128
    ld1w { z22.s, z30.s }, pn8/z, [x2]
    add x2, x2, #128
    ld1w { z23.s, z31.s }, pn8/z, [x2]

    mov	za0h.s[w12, 0:3], { z0.s - z3.s }  
    add w12, w12, #4  
    mov	za0h.s[w12, 0:3], { z4.s - z7.s }
    add w12, w12, #4
    mov	za0h.s[w12, 0:3], { z16.s - z19.s }
    add w12, w12, #4
    mov	za0h.s[w12, 0:3], { z20.s - z23.s }

    mov za1h.s[w13, 0:3], { z8.s - z11.s }  
    add w13, w13, #4  
    mov za1h.s[w13, 0:3], { z12.s - z15.s }
    add w13, w13, #4
    mov za1h.s[w13, 0:3], { z24.s - z27.s }
    add w13, w13, #4
    mov za1h.s[w13, 0:3], { z28.s - z31.s }


    ld1w { z0.s, z8.s }, pn8/z, [x4]
    add x4, x4, #128
    ld1w { z1.s, z9.s }, pn8/z, [x4]
    add x4, x4, #128
    ld1w { z2.s, z10.s }, pn8/z, [x4]
    add x4, x4, #128
    ld1w { z3.s, z11.s }, pn8/z, [x4]
    add x4, x4, #128

    ld1w { z4.s, z12.s }, pn8/z, [x4]
    add x4, x4, #128
    ld1w { z5.s, z13.s }, pn8/z, [x4]
    add x4, x4, #128
    ld1w { z6.s, z14.s }, pn8/z, [x4]
    add x4, x4, #128
    ld1w { z7.s, z15.s }, pn8/z, [x4]
    add x4, x4, #128

    ld1w { z16.s, z24.s }, pn8/z, [x4]
    add x4, x4, #128
    ld1w { z17.s, z25.s }, pn8/z, [x4]
    add x4, x4, #128
    ld1w { z18.s, z26.s }, pn8/z, [x4]
    add x4, x4, #128
    ld1w { z19.s, z27.s }, pn8/z, [x4]
    add x4, x4, #128

    ld1w { z20.s, z28.s }, pn8/z, [x4]
    add x4, x4, #128
    ld1w { z21.s, z29.s }, pn8/z, [x4]
    add x4, x4, #128
    ld1w { z22.s, z30.s }, pn8/z, [x4]
    add x4, x4, #128
    ld1w { z23.s, z31.s }, pn8/z, [x4]

    mov	za2h.s[w14, 0:3], { z0.s - z3.s }  
    add w14, w14, #4
    mov	za2h.s[w14, 0:3], { z4.s - z7.s }
    add w14, w14, #4
    mov	za2h.s[w14, 0:3], { z16.s - z19.s }
    add w14, w14, #4
    mov	za2h.s[w14, 0:3], { z20.s - z23.s }

    mov za3h.s[w15, 0:3], { z8.s - z11.s }  
    add w15, w15, #4  
    mov za3h.s[w15, 0:3], { z12.s - z15.s }
    add w15, w15, #4
    mov za3h.s[w15, 0:3], { z24.s - z27.s }
    add w15, w15, #4
    mov za3h.s[w15, 0:3], { z28.s - z31.s }

  
loop_32_no_trans:

    sub x6, x6, #1
    
    ld1w { z0.s, z1.s }, pn8/z,  [x0]
    add x0, x0, #128

    ld1w { z2.s, z3.s }, pn8/z, [x1]
    add x1, x1, #128  
    
    //      c                 b     a
    fmopa za0.s, p0/m, p1/m, z2.s, z0.s
    fmopa za1.s, p0/m, p1/m, z2.s, z1.s
    fmopa za2.s, p0/m, p1/m, z3.s, z0.s
    fmopa za3.s, p0/m, p1/m, z3.s, z1.s

    cbnz x6, loop_32_no_trans

    mov x2, x9
    add x4, x9, #2048

    // store C
    mov w12, #0
    mov w13, #1
    mov w14, #2
    mov w15, #3


    mov	{ z0.s - z3.s }, za0h.s[w12, 0:3]
    add w12, w12, #4  
    mov	{ z4.s - z7.s }, za0h.s[w12, 0:3]
    add w12, w12, #4
    mov	{ z16.s - z19.s }, za0h.s[w12, 0:3]
    add w12, w12, #4
    mov	{ z20.s - z23.s }, za0h.s[w12, 0:3]

    mov { z8.s - z11.s }, za1h.s[w13, 0:3]
    add w13, w13, #4  
    mov { z12.s - z15.s }, za1h.s[w13, 0:3]
    add w13, w13, #4
    mov { z24.s - z27.s }, za1h.s[w13, 0:3]
    add w13, w13, #4
    mov { z28.s - z31.s }, za1h.s[w13, 0:3]

    st1w { z0.s, z8.s }, pn8, [x2]
    add x2, x2, #128
    st1w { z1.s, z9.s }, pn8, [x2]
    add x2, x2, #128
    st1w { z2.s, z10.s }, pn8, [x2]
    add x2, x2, #128
    st1w { z3.s, z11.s }, pn8, [x2]
    add x2, x2, #128

    st1w { z4.s, z12.s }, pn8, [x2]
    add x2, x2, #128
    st1w { z5.s, z13.s }, pn8, [x2]
    add x2, x2, #128
    st1w { z6.s, z14.s }, pn8, [x2]
    add x2, x2, #128
    st1w { z7.s, z15.s }, pn8, [x2]
    add x2, x2, #128

    st1w { z16.s, z24.s }, pn8, [x2]
    add x2, x2, #128
    st1w { z17.s, z25.s }, pn8, [x2]
    add x2, x2, #128
    st1w { z18.s, z26.s }, pn8, [x2]
    add x2, x2, #128
    st1w { z19.s, z27.s }, pn8, [x2]
    add x2, x2, #128

    st1w { z20.s, z28.s }, pn8, [x2]
    add x2, x2, #128
    st1w { z21.s, z29.s }, pn8, [x2]
    add x2, x2, #128
    st1w { z22.s, z30.s }, pn8, [x2]
    add x2, x2, #128
    st1w { z23.s, z31.s }, pn8, [x2]

    mov	{ z0.s - z3.s }, za2h.s[w14, 0:3]
    add w14, w14, #4  
    mov	{ z4.s - z7.s }, za2h.s[w14, 0:3]
    add w14, w14, #4
    mov	{ z16.s - z19.s }, za2h.s[w14, 0:3]
    add w14, w14, #4
    mov	{ z20.s - z23.s }, za2h.s[w14, 0:3]

    mov { z8.s - z11.s }, za3h.s[w15, 0:3]
    add w15, w15, #4  
    mov { z12.s - z15.s }, za3h.s[w15, 0:3]
    add w15, w15, #4
    mov { z24.s - z27.s }, za3h.s[w15, 0:3]
    add w15, w15, #4
    mov { z28.s - z31.s }, za3h.s[w15, 0:3]

    st1w { z0.s, z8.s }, pn8, [x4]
    add x4, x4, #128
    st1w { z1.s, z9.s }, pn8, [x4]
    add x4, x4, #128
    st1w { z2.s, z10.s }, pn8, [x4]
    add x4, x4, #128
    st1w { z3.s, z11.s }, pn8, [x4]
    add x4, x4, #128

    st1w { z4.s, z12.s }, pn8, [x4]
    add x4, x4, #128
    st1w { z5.s, z13.s }, pn8, [x4]
    add x4, x4, #128
    st1w { z6.s, z14.s }, pn8, [x4]
    add x4, x4, #128
    st1w { z7.s, z15.s }, pn8, [x4]
    add x4, x4, #128

    st1w { z16.s, z24.s }, pn8, [x4]
    add x4, x4, #128
    st1w { z17.s, z25.s }, pn8, [x4]
    add x4, x4, #128
    st1w { z18.s, z26.s }, pn8, [x4]
    add x4, x4, #128
    st1w { z19.s, z27.s }, pn8, [x4]
    add x4, x4, #128

    st1w { z20.s, z28.s }, pn8, [x4]
    add x4, x4, #128
    st1w { z21.s, z29.s }, pn8, [x4]
    add x4, x4, #128
    st1w { z22.s, z30.s }, pn8, [x4]
    add x4, x4, #128
    st1w { z23.s, z31.s }, pn8, [x4]

    smstop
    mov sp, x17

    // PCS: restore
    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    ret

    .align 4
    .global _gemm_micro_128_128_128
_gemm_micro_128_128_128:
    // PCS: store
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

    smstart

    // n loop register
    mov x16, #4

loop_3x128_n:
    sub x16, x16, #1
    
    // m loop register
    mov x8, #4

loop_3x128_m:
    sub x8, x8, #1
    // save adress for C, B, A
    mov x9, x2
    mov x10, x1
    mov x11, x0

    // k loop register
    mov x6, #128     

    // x4 adress of tile 2
    add x4, x2, #8192


    // load C
    mov w12, #0
    mov w13, #1
    mov w14, #2
    mov w15, #3

    ptrue p0.b
    ptrue p1.b
    ptrue pn8.b

    ld1w { z0.s, z8.s }, pn8/z, [x2]
    add x2, x2, #128*4
    ld1w { z1.s, z9.s }, pn8/z, [x2]
    add x2, x2, #128*4
    ld1w { z2.s, z10.s }, pn8/z, [x2]
    add x2, x2, #128*4
    ld1w { z3.s, z11.s }, pn8/z, [x2]
    add x2, x2, #128*4

    ld1w { z4.s, z12.s }, pn8/z, [x2]
    add x2, x2, #128*4
    ld1w { z5.s, z13.s }, pn8/z, [x2]
    add x2, x2, #128*4
    ld1w { z6.s, z14.s }, pn8/z, [x2]
    add x2, x2, #128*4
    ld1w { z7.s, z15.s }, pn8/z, [x2]
    add x2, x2, #128*4

    ld1w { z16.s, z24.s }, pn8/z, [x2]
    add x2, x2, #128*4
    ld1w { z17.s, z25.s }, pn8/z, [x2]
    add x2, x2, #128*4
    ld1w { z18.s, z26.s }, pn8/z, [x2]
    add x2, x2, #128*4
    ld1w { z19.s, z27.s }, pn8/z, [x2]
    add x2, x2, #128*4

    ld1w { z20.s, z28.s }, pn8/z, [x2]
    add x2, x2, #128*4
    ld1w { z21.s, z29.s }, pn8/z, [x2]
    add x2, x2, #128*4
    ld1w { z22.s, z30.s }, pn8/z, [x2]
    add x2, x2, #128*4
    ld1w { z23.s, z31.s }, pn8/z, [x2]

    mov	za0h.s[w12, 0:3], { z0.s - z3.s }  
    add w12, w12, #4  
    mov	za0h.s[w12, 0:3], { z4.s - z7.s }
    add w12, w12, #4
    mov	za0h.s[w12, 0:3], { z16.s - z19.s }
    add w12, w12, #4
    mov	za0h.s[w12, 0:3], { z20.s - z23.s }

    mov za1h.s[w13, 0:3], { z8.s - z11.s }  
    add w13, w13, #4  
    mov za1h.s[w13, 0:3], { z12.s - z15.s }
    add w13, w13, #4
    mov za1h.s[w13, 0:3], { z24.s - z27.s }
    add w13, w13, #4
    mov za1h.s[w13, 0:3], { z28.s - z31.s }


    ld1w { z0.s, z8.s }, pn8/z, [x4]
    add x4, x4, #128*4
    ld1w { z1.s, z9.s }, pn8/z, [x4]
    add x4, x4, #128*4
    ld1w { z2.s, z10.s }, pn8/z, [x4]
    add x4, x4, #128*4
    ld1w { z3.s, z11.s }, pn8/z, [x4]
    add x4, x4, #128*4

    ld1w { z4.s, z12.s }, pn8/z, [x4]
    add x4, x4, #128*4
    ld1w { z5.s, z13.s }, pn8/z, [x4]
    add x4, x4, #128*4
    ld1w { z6.s, z14.s }, pn8/z, [x4]
    add x4, x4, #128*4
    ld1w { z7.s, z15.s }, pn8/z, [x4]
    add x4, x4, #128*4

    ld1w { z16.s, z24.s }, pn8/z, [x4]
    add x4, x4, #128*4
    ld1w { z17.s, z25.s }, pn8/z, [x4]
    add x4, x4, #128*4
    ld1w { z18.s, z26.s }, pn8/z, [x4]
    add x4, x4, #128*4
    ld1w { z19.s, z27.s }, pn8/z, [x4]
    add x4, x4, #128*4

    ld1w { z20.s, z28.s }, pn8/z, [x4]
    add x4, x4, #128*4
    ld1w { z21.s, z29.s }, pn8/z, [x4]
    add x4, x4, #128*4
    ld1w { z22.s, z30.s }, pn8/z, [x4]
    add x4, x4, #128*4
    ld1w { z23.s, z31.s }, pn8/z, [x4]

    mov	za2h.s[w14, 0:3], { z0.s - z3.s }  
    add w14, w14, #4
    mov	za2h.s[w14, 0:3], { z4.s - z7.s }
    add w14, w14, #4
    mov	za2h.s[w14, 0:3], { z16.s - z19.s }
    add w14, w14, #4
    mov	za2h.s[w14, 0:3], { z20.s - z23.s }

    mov za3h.s[w15, 0:3], { z8.s - z11.s }  
    add w15, w15, #4  
    mov za3h.s[w15, 0:3], { z12.s - z15.s }
    add w15, w15, #4
    mov za3h.s[w15, 0:3], { z24.s - z27.s }
    add w15, w15, #4
    mov za3h.s[w15, 0:3], { z28.s - z31.s }

  
loop_3x128_k:

    sub x6, x6, #1

    // load a
    ld1w { z0.s, z1.s }, pn8/z,  [x0]
    add x0, x0, #128*4

    // load b
    ld1w { z2.s, z3.s }, pn8/z, [x1]
    add x1, x1, #128*4

    //      c                 b     a
    fmopa za0.s, p0/m, p1/m, z2.s, z0.s
    fmopa za1.s, p0/m, p1/m, z2.s, z1.s
    fmopa za2.s, p0/m, p1/m, z3.s, z0.s
    fmopa za3.s, p0/m, p1/m, z3.s, z1.s


    cbnz x6, loop_3x128_k

    mov x2, x9
    add x4, x9, #8192

    // store C
    mov w12, #0
    mov w13, #1
    mov w14, #2
    mov w15, #3


    mov	{ z0.s - z3.s }, za0h.s[w12, 0:3]
    add w12, w12, #4  
    mov	{ z4.s - z7.s }, za0h.s[w12, 0:3]
    add w12, w12, #4
    mov	{ z16.s - z19.s }, za0h.s[w12, 0:3]
    add w12, w12, #4
    mov	{ z20.s - z23.s }, za0h.s[w12, 0:3]

    mov { z8.s - z11.s }, za1h.s[w13, 0:3]
    add w13, w13, #4  
    mov { z12.s - z15.s }, za1h.s[w13, 0:3]
    add w13, w13, #4
    mov { z24.s - z27.s }, za1h.s[w13, 0:3]
    add w13, w13, #4
    mov { z28.s - z31.s }, za1h.s[w13, 0:3]

    st1w { z0.s, z8.s }, pn8, [x2]
    add x2, x2, #128*4
    st1w { z1.s, z9.s }, pn8, [x2]
    add x2, x2, #128*4
    st1w { z2.s, z10.s }, pn8, [x2]
    add x2, x2, #128*4
    st1w { z3.s, z11.s }, pn8, [x2]
    add x2, x2, #128*4

    st1w { z4.s, z12.s }, pn8, [x2]
    add x2, x2, #128*4
    st1w { z5.s, z13.s }, pn8, [x2]
    add x2, x2, #128*4
    st1w { z6.s, z14.s }, pn8, [x2]
    add x2, x2, #128*4
    st1w { z7.s, z15.s }, pn8, [x2]
    add x2, x2, #128*4

    st1w { z16.s, z24.s }, pn8, [x2]
    add x2, x2, #128*4
    st1w { z17.s, z25.s }, pn8, [x2]
    add x2, x2, #128*4
    st1w { z18.s, z26.s }, pn8, [x2]
    add x2, x2, #128*4
    st1w { z19.s, z27.s }, pn8, [x2]
    add x2, x2, #128*4

    st1w { z20.s, z28.s }, pn8, [x2]
    add x2, x2, #128*4
    st1w { z21.s, z29.s }, pn8, [x2]
    add x2, x2, #128*4
    st1w { z22.s, z30.s }, pn8, [x2]
    add x2, x2, #128*4
    st1w { z23.s, z31.s }, pn8, [x2]

    mov	{ z0.s - z3.s }, za2h.s[w14, 0:3]
    add w14, w14, #4  
    mov	{ z4.s - z7.s }, za2h.s[w14, 0:3]
    add w14, w14, #4
    mov	{ z16.s - z19.s }, za2h.s[w14, 0:3]
    add w14, w14, #4
    mov	{ z20.s - z23.s }, za2h.s[w14, 0:3]

    mov { z8.s - z11.s }, za3h.s[w15, 0:3]
    add w15, w15, #4  
    mov { z12.s - z15.s }, za3h.s[w15, 0:3]
    add w15, w15, #4
    mov { z24.s - z27.s }, za3h.s[w15, 0:3]
    add w15, w15, #4
    mov { z28.s - z31.s }, za3h.s[w15, 0:3]

    st1w { z0.s, z8.s }, pn8, [x4]
    add x4, x4, #128*4
    st1w { z1.s, z9.s }, pn8, [x4]
    add x4, x4, #128*4
    st1w { z2.s, z10.s }, pn8, [x4]
    add x4, x4, #128*4
    st1w { z3.s, z11.s }, pn8, [x4]
    add x4, x4, #128*4

    st1w { z4.s, z12.s }, pn8, [x4]
    add x4, x4, #128*4
    st1w { z5.s, z13.s }, pn8, [x4]
    add x4, x4, #128*4
    st1w { z6.s, z14.s }, pn8, [x4]
    add x4, x4, #128*4
    st1w { z7.s, z15.s }, pn8, [x4]
    add x4, x4, #128*4

    st1w { z16.s, z24.s }, pn8, [x4]
    add x4, x4, #128*4
    st1w { z17.s, z25.s }, pn8, [x4]
    add x4, x4, #128*4
    st1w { z18.s, z26.s }, pn8, [x4]
    add x4, x4, #128*4
    st1w { z19.s, z27.s }, pn8, [x4]
    add x4, x4, #128*4

    st1w { z20.s, z28.s }, pn8, [x4]
    add x4, x4, #128*4
    st1w { z21.s, z29.s }, pn8, [x4]
    add x4, x4, #128*4
    st1w { z22.s, z30.s }, pn8, [x4]
    add x4, x4, #128*4
    st1w { z23.s, z31.s }, pn8, [x4]

    add x2, x9, #128
    mov x1, x10
    add x0, x11, #128
  


    cbnz x8, loop_3x128_m
    
    add x1, x1, #128
    sub x2, x2, #4*128
    add x2, x2, #16384
    sub x0, x0, #4*128

    cbnz x16, loop_3x128_n
     
    smstop

    // PCS: restore
    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    ret 