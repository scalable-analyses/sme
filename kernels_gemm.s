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