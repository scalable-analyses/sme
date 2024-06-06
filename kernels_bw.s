    .global _copy_ldr_z
    .align 4
_copy_ldr_z:
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

    smstart

loop_copy_ldr_z_outer:
    sub x0, x0, #1

    mov x4, x1
    mov x5, x2
    mov x6, x3

loop_copy_ldr_z_inner_start:
    cmp x4, #16*16
    b.lt loop_copy_ldr_z_inner_end

    ldr z0, [x5]
    add x5, x5, #16*4
    ldr z1, [x5]
    add x5, x5, #16*4
    ldr z2, [x5]
    add x5, x5, #16*4
    ldr z3, [x5]
    add x5, x5, #16*4

    str z0, [x6]
    add x6, x6, #16*4
    str z1, [x6]
    add x6, x6, #16*4
    str z2, [x6]
    add x6, x6, #16*4
    str z3, [x6]
    add x6, x6, #16*4


    ldr z4, [x5]
    add x5, x5, #16*4
    ldr z5, [x5]
    add x5, x5, #16*4
    ldr z6, [x5]
    add x5, x5, #16*4
    ldr z7, [x5]
    add x5, x5, #16*4

    str z4, [x6]
    add x6, x6, #16*4
    str z5, [x6]
    add x6, x6, #16*4
    str z6, [x6]
    add x6, x6, #16*4
    str z7, [x6]
    add x6, x6, #16*4


    ldr z8, [x5]
    add x5, x5, #16*4
    ldr z9, [x5]
    add x5, x5, #16*4
    ldr z10, [x5]
    add x5, x5, #16*4
    ldr z11, [x5]
    add x5, x5, #16*4

    str z8, [x6]
    add x6, x6, #16*4
    str z9, [x6]
    add x6, x6, #16*4
    str z10, [x6]
    add x6, x6, #16*4
    str z11, [x6]
    add x6, x6, #16*4


    ldr z12, [x5]
    add x5, x5, #16*4
    ldr z13, [x5]
    add x5, x5, #16*4
    ldr z14, [x5]
    add x5, x5, #16*4
    ldr z15, [x5]
    add x5, x5, #16*4

    str z12, [x6]
    add x6, x6, #16*4
    str z13, [x6]
    add x6, x6, #16*4
    str z14, [x6]
    add x6, x6, #16*4
    str z15, [x6]
    add x6, x6, #16*4

    sub x4, x4, #16*16

    b loop_copy_ldr_z_inner_start

loop_copy_ldr_z_inner_end:
    cbnz x0, loop_copy_ldr_z_outer

    smstop

    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    ret


    .global _copy_ld1w_z_1
    .align 4
_copy_ld1w_z_1:
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

    smstart

    ptrue p0.b

loop_copy_ld1w_z_1_outer:
    sub x0, x0, #1

    mov x4, x1
    mov x5, x2
    mov x6, x3

loop_copy_ld1w_z_1_inner_start:
    cmp x4, #16*16
    b.lt loop_copy_ld1w_z_1_inner_end

    ld1w { z0.s }, p0/z, [x5]
    add x5, x5, #16*4
    ld1w { z1.s }, p0/z, [x5]
    add x5, x5, #16*4
    ld1w { z2.s }, p0/z, [x5]
    add x5, x5, #16*4
    ld1w { z3.s }, p0/z, [x5]
    add x5, x5, #16*4

    st1w { z0.s }, p0, [x6]
    add x6, x6, #16*4
    st1w { z1.s }, p0, [x6]
    add x6, x6, #16*4
    st1w { z2.s }, p0, [x6]
    add x6, x6, #16*4
    st1w { z3.s }, p0, [x6]
    add x6, x6, #16*4


    ld1w { z4.s }, p0/z, [x5]
    add x5, x5, #16*4
    ld1w { z5.s }, p0/z, [x5]
    add x5, x5, #16*4
    ld1w { z6.s }, p0/z, [x5]
    add x5, x5, #16*4
    ld1w { z7.s }, p0/z, [x5]
    add x5, x5, #16*4

    st1w { z4.s }, p0, [x6]
    add x6, x6, #16*4
    st1w { z5.s }, p0, [x6]
    add x6, x6, #16*4
    st1w { z6.s }, p0, [x6]
    add x6, x6, #16*4
    st1w { z7.s }, p0, [x6]
    add x6, x6, #16*4


    ld1w { z8.s }, p0/z, [x5]
    add x5, x5, #16*4
    ld1w { z9.s }, p0/z, [x5]
    add x5, x5, #16*4
    ld1w { z10.s }, p0/z, [x5]
    add x5, x5, #16*4
    ld1w { z11.s }, p0/z, [x5]
    add x5, x5, #16*4

    st1w { z8.s }, p0, [x6]
    add x6, x6, #16*4
    st1w { z9.s }, p0, [x6]
    add x6, x6, #16*4
    st1w { z10.s }, p0, [x6]
    add x6, x6, #16*4
    st1w { z11.s }, p0, [x6]
    add x6, x6, #16*4


    ld1w { z12.s }, p0/z, [x5]
    add x5, x5, #16*4
    ld1w { z13.s }, p0/z, [x5]
    add x5, x5, #16*4
    ld1w { z14.s }, p0/z, [x5]
    add x5, x5, #16*4
    ld1w { z15.s }, p0/z, [x5]
    add x5, x5, #16*4

    st1w { z12.s }, p0, [x6]
    add x6, x6, #16*4
    st1w { z13.s }, p0, [x6]
    add x6, x6, #16*4
    st1w { z14.s }, p0, [x6]
    add x6, x6, #16*4
    st1w { z15.s }, p0, [x6]
    add x6, x6, #16*4

    sub x4, x4, #16*16

    b loop_copy_ld1w_z_1_inner_start

loop_copy_ld1w_z_1_inner_end:
    cbnz x0, loop_copy_ld1w_z_1_outer

    smstop

    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    ret

    .global _copy_ld1w_z_2
    .align 4
_copy_ld1w_z_2:
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

    smstart

    ptrue pn8.b

loop_copy_ld1w_z_2_outer:
    sub x0, x0, #1

    mov x4, x1
    mov x5, x2
    mov x6, x3

loop_copy_ld1w_z_2_inner_start:
    cmp x4, #16*16
    b.lt loop_copy_ld1w_z_2_inner_end

    ld1w { z0.s, z1.s }, pn8/z, [x5]
    add x5, x5, #32*4
    ld1w { z2.s, z3.s }, pn8/z, [x5]
    add x5, x5, #32*4

    st1w { z0.s, z1.s }, pn8, [x6]
    add x6, x6, #32*4
    st1w { z2.s, z3.s }, pn8, [x6]
    add x6, x6, #32*4

    ld1w { z4.s, z5.s }, pn8/z, [x5]
    add x5, x5, #32*4
    ld1w { z6.s, z7.s }, pn8/z, [x5]
    add x5, x5, #32*4

    st1w { z4.s, z5.s }, pn8, [x6]
    add x6, x6, #32*4
    st1w { z6.s, z7.s }, pn8, [x6]
    add x6, x6, #32*4

    ld1w { z8.s, z9.s }, pn8/z, [x5]
    add x5, x5, #32*4
    ld1w { z10.s, z11.s }, pn8/z, [x5]
    add x5, x5, #32*4

    st1w { z8.s, z9.s }, pn8, [x6]
    add x6, x6, #32*4
    st1w { z10.s, z11.s }, pn8, [x6]
    add x6, x6, #32*4

    ld1w { z12.s, z13.s }, pn8/z, [x5]
    add x5, x5, #32*4
    ld1w { z14.s, z15.s }, pn8/z, [x5]
    add x5, x5, #32*4

    st1w { z12.s, z13.s }, pn8, [x6]
    add x6, x6, #32*4
    st1w { z14.s, z15.s }, pn8, [x6]
    add x6, x6, #32*4

    sub x4, x4, #16*16

    b loop_copy_ld1w_z_2_inner_start

loop_copy_ld1w_z_2_inner_end:
    cbnz x0, loop_copy_ld1w_z_2_outer

    smstop

    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    ret


    .global _copy_ld1w_z_4
    .align 4
_copy_ld1w_z_4:
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

    smstart

    ptrue pn8.b

loop_copy_ld1w_z_4_outer:
    sub x0, x0, #1

    mov x4, x1
    mov x5, x2
    mov x6, x3

loop_copy_ld1w_z_4_inner_start:
    cmp x4, #16*16
    b.lt loop_copy_ld1w_z_4_inner_end

    ld1w { z0.s, z1.s, z2.s, z3.s }, pn8/z, [x5]
    add x5, x5, #64*4
    st1w { z0.s, z1.s, z2.s, z3.s }, pn8, [x6]
    add x6, x6, #64*4

    ld1w { z4.s, z5.s, z6.s, z7.s }, pn8/z, [x5]
    add x5, x5, #64*4
    st1w { z4.s, z5.s, z6.s, z7.s }, pn8, [x6]
    add x6, x6, #64*4

    ld1w { z8.s, z9.s, z10.s, z11.s }, pn8/z, [x5]
    add x5, x5, #64*4
    st1w { z8.s, z9.s, z10.s, z11.s }, pn8, [x6]
    add x6, x6, #64*4

    ld1w { z12.s, z13.s, z14.s, z15.s }, pn8/z, [x5]
    add x5, x5, #64*4
    st1w { z12.s, z13.s, z14.s, z15.s }, pn8, [x6]
    add x6, x6, #64*4

    sub x4, x4, #16*16

    b loop_copy_ld1w_z_4_inner_start

loop_copy_ld1w_z_4_inner_end:
    cbnz x0, loop_copy_ld1w_z_4_outer

    smstop

    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    ret


    .global _copy_ld1w_z_strided_2
    .align 4
_copy_ld1w_z_strided_2:
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

    smstart

    ptrue pn8.b

loop_copy_ld1w_z_strided_2_outer:
    sub x0, x0, #1

    mov x4, x1
    mov x5, x2
    mov x6, x3

loop_copy_ld1w_z_strided_2_inner_start:
    cmp x4, #16*16
    b.lt loop_copy_ld1w_z_strided_2_inner_end

    ld1w { z0.s, z8.s }, pn8/z, [x5]
    add x5, x5, #32*4
    ld1w { z1.s, z9.s }, pn8/z, [x5]
    add x5, x5, #32*4

    st1w { z0.s, z8.s }, pn8, [x6]
    add x6, x6, #32*4
    st1w { z1.s, z9.s }, pn8, [x6]
    add x6, x6, #32*4

    ld1w { z2.s, z10.s }, pn8/z, [x5]
    add x5, x5, #32*4
    ld1w { z3.s, z11.s }, pn8/z, [x5]
    add x5, x5, #32*4

    st1w { z2.s, z10.s }, pn8, [x6]
    add x6, x6, #32*4
    st1w { z3.s, z11.s }, pn8, [x6]
    add x6, x6, #32*4

    ld1w { z4.s, z12.s }, pn8/z, [x5]
    add x5, x5, #32*4
    ld1w { z5.s, z13.s }, pn8/z, [x5]
    add x5, x5, #32*4

    st1w { z4.s, z12.s }, pn8, [x6]
    add x6, x6, #32*4
    st1w { z5.s, z13.s }, pn8, [x6]
    add x6, x6, #32*4

    ld1w { z6.s, z14.s }, pn8/z, [x5]
    add x5, x5, #32*4
    ld1w { z7.s, z15.s }, pn8/z, [x5]
    add x5, x5, #32*4

    st1w { z6.s, z14.s }, pn8, [x6]
    add x6, x6, #32*4
    st1w { z7.s, z15.s }, pn8, [x6]
    add x6, x6, #32*4

    sub x4, x4, #16*16

    b loop_copy_ld1w_z_strided_2_inner_start

loop_copy_ld1w_z_strided_2_inner_end:
    cbnz x0, loop_copy_ld1w_z_strided_2_outer

    smstop

    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    ret


    .global _copy_ld1w_z_strided_4
    .align 4
_copy_ld1w_z_strided_4:
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

    smstart

    ptrue pn8.b

loop_copy_ld1w_z_strided_4_outer:
    sub x0, x0, #1

    mov x4, x1
    mov x5, x2
    mov x6, x3

loop_copy_ld1w_z_strided_4_inner_start:
    cmp x4, #16*16
    b.lt loop_copy_ld1w_z_strided_4_inner_end

    ld1w { z0.s, z4.s, z8.s, z12.s }, pn8/z, [x5]
    add x5, x5, #64*4
    st1w { z0.s, z4.s, z8.s, z12.s }, pn8, [x6]
    add x6, x6, #64*4

    ld1w { z1.s, z5.s, z9.s, z13.s }, pn8/z, [x5]
    add x5, x5, #64*4
    st1w { z1.s, z5.s, z9.s, z13.s }, pn8, [x6]
    add x6, x6, #64*4

    ld1w { z2.s, z6.s, z10.s, z14.s }, pn8/z, [x5]
    add x5, x5, #64*4
    st1w { z2.s, z6.s, z10.s, z14.s }, pn8, [x6]
    add x6, x6, #64*4

    ld1w { z3.s, z7.s, z11.s, z15.s }, pn8/z, [x5]
    add x5, x5, #64*4
    st1w { z3.s, z7.s, z11.s, z15.s }, pn8, [x6]
    add x6, x6, #64*4

    sub x4, x4, #16*16

    b loop_copy_ld1w_z_strided_4_inner_start

loop_copy_ld1w_z_strided_4_inner_end:
    cbnz x0, loop_copy_ld1w_z_strided_4_outer

    smstop

    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    ret


    .global _copy_ldr_za
    .align 4
_copy_ldr_za:
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

loop_copy_ldr_za_outer:
    sub x0, x0, #1

    mov x4, x1

    add x5, x2, #0
    add x6, x2, #16*4
    add x7, x2, #32*4
    add x8, x2, #48*4

    add x16, x3, #0
    add x17, x3, #16*4
    add x19, x3, #32*4
    add x20, x3, #48*4

loop_copy_ldr_za_inner_start:
    cmp x4, #64*16
    b.lt loop_copy_ldr_za_inner_end
    sub x4, x4, #64*16

    mov x9, #16
    mov w12, #0
    mov w13, #1
    mov w14, #2
    mov w15, #3
loop_copy_ldr_za_write:
    sub x9, x9, #1

    ldr za[w12, #0], [x5]
    ldr za[w13, #0], [x6]
    ldr za[w14, #0], [x7]
    ldr za[w15, #0], [x8]

    str za[w12, #0], [x16]
    str za[w13, #0], [x17]
    str za[w14, #0], [x19]
    str za[w15, #0], [x20]

    add w12, w12, #4
    add w13, w13, #4
    add w14, w14, #4
    add w15, w15, #4

    add x5, x5, #64*4
    add x6, x6, #64*4
    add x7, x7, #64*4
    add x8, x8, #64*4

    add x16, x16, #64*4
    add x17, x17, #64*4
    add x19, x19, #64*4
    add x20, x20, #64*4

    cbnz x9, loop_copy_ldr_za_write

    b loop_copy_ldr_za_inner_start

loop_copy_ldr_za_inner_end:
    cbnz x0, loop_copy_ldr_za_outer

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