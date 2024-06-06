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