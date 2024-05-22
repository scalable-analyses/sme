    .text
    .global _sve_support
    .align 4
_sve_support:
    ptrue p0.b
    fmla z0.s, p0/m, z30.s, z31.s
    ret


    .global _sve_streaming_support
    .align 4
_sve_streaming_support:
    smstart
    ptrue p0.b
    fmla z0.s, p0/m, z30.s, z31.s
    smstop
    ret


    .global _sme_support
    .align 4
_sme_support:
    smstart
    ptrue p0.b
    ptrue p1.b
    fmopa za0.s, p0/m, p1/m, z0.s, z1.s
    smstop
    ret

    .global _sme2_support
    .align 4
_sme2_support:
    smstart
    mov w8, #0
    bfdot za.s[w8, #0], {z0.h, z1.h}, z2.h
    smstop
    ret

    .global _sve_streaming_vlength
    .align 4
_sve_streaming_vlength:
    smstart
    ldr z0, [x0]
    str z0, [x1]
    smstop
    ret


    .global _neon_bf16_support
    .align 4
_neon_bf16_support:
    bfmmla v0.4s, v1.8h, v2.8h
    ret


    .align 4
    .global _peak_neon_fmla_fp32_fp32_fp32
_peak_neon_fmla_fp32_fp32_fp32:
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!
        
    eor v0.16b, v0.16b, v0.16b
    eor v1.16b, v1.16b, v1.16b
    eor v2.16b, v2.16b, v2.16b
    eor v3.16b, v3.16b, v3.16b

    eor v4.16b, v4.16b, v4.16b
    eor v5.16b, v5.16b, v5.16b
    eor v6.16b, v6.16b, v6.16b
    eor v7.16b, v7.16b, v7.16b

    eor v8.16b, v8.16b, v8.16b
    eor v9.16b, v9.16b, v9.16b
    eor v10.16b, v10.16b, v10.16b
    eor v11.16b, v11.16b, v11.16b

    eor v12.16b, v12.16b, v12.16b
    eor v13.16b, v13.16b, v13.16b
    eor v14.16b, v14.16b, v14.16b
    eor v15.16b, v15.16b, v15.16b

    eor v16.16b, v16.16b, v16.16b
    eor v17.16b, v17.16b, v17.16b
    eor v18.16b, v18.16b, v18.16b
    eor v19.16b, v19.16b, v19.16b

    eor v20.16b, v20.16b, v20.16b
    eor v21.16b, v21.16b, v21.16b
    eor v22.16b, v22.16b, v22.16b
    eor v23.16b, v23.16b, v23.16b

    eor v24.16b, v24.16b, v24.16b
    eor v25.16b, v25.16b, v25.16b
    eor v26.16b, v26.16b, v26.16b
    eor v27.16b, v27.16b, v27.16b

    eor v28.16b, v28.16b, v28.16b
    eor v29.16b, v29.16b, v29.16b
    eor v30.16b, v30.16b, v30.16b
    eor v31.16b, v31.16b, v31.16b

loop_peak_neon_fmla_fp32_fp32_fp32:
    sub x0,x0, #1
    fmla v0.4s, v30.4s, v31.4s
    fmla v1.4s, v30.4s, v31.4s
    fmla v2.4s, v30.4s, v31.4s
    fmla v3.4s, v30.4s, v31.4s

    fmla v4.4s, v30.4s, v31.4s
    fmla v5.4s, v30.4s, v31.4s
    fmla v6.4s, v30.4s, v31.4s
    fmla v7.4s, v30.4s, v31.4s

    fmla v8.4s, v30.4s, v31.4s
    fmla v9.4s, v30.4s, v31.4s
    fmla v10.4s, v30.4s, v31.4s
    fmla v11.4s, v30.4s, v31.4s

    fmla v12.4s, v30.4s, v31.4s
    fmla v13.4s, v30.4s, v31.4s
    fmla v14.4s, v30.4s, v31.4s
    fmla v15.4s, v30.4s, v31.4s

    fmla v16.4s, v30.4s, v31.4s
    fmla v17.4s, v30.4s, v31.4s
    fmla v18.4s, v30.4s, v31.4s
    fmla v19.4s, v30.4s, v31.4s

    fmla v20.4s, v30.4s, v31.4s
    fmla v21.4s, v30.4s, v31.4s
    fmla v22.4s, v30.4s, v31.4s
    fmla v23.4s, v30.4s, v31.4s

    fmla v24.4s, v30.4s, v31.4s
    fmla v25.4s, v30.4s, v31.4s
    fmla v26.4s, v30.4s, v31.4s
    fmla v27.4s, v30.4s, v31.4s

    fmla v28.4s, v30.4s, v31.4s
    fmla v29.4s, v30.4s, v31.4s

    cbnz x0, loop_peak_neon_fmla_fp32_fp32_fp32

    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    mov x0, 30*8

    ret


    .align 4
    .global _peak_neon_bfmmla_bf16_bf16_fp32
_peak_neon_bfmmla_bf16_bf16_fp32:
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

    eor v0.16b, v0.16b, v0.16b
    eor v1.16b, v1.16b, v1.16b
    eor v2.16b, v2.16b, v2.16b
    eor v3.16b, v3.16b, v3.16b

    eor v4.16b, v4.16b, v4.16b
    eor v5.16b, v5.16b, v5.16b
    eor v6.16b, v6.16b, v6.16b
    eor v7.16b, v7.16b, v7.16b

    eor v8.16b, v8.16b, v8.16b
    eor v9.16b, v9.16b, v9.16b
    eor v10.16b, v10.16b, v10.16b
    eor v11.16b, v11.16b, v11.16b

    eor v12.16b, v12.16b, v12.16b
    eor v13.16b, v13.16b, v13.16b
    eor v14.16b, v14.16b, v14.16b
    eor v15.16b, v15.16b, v15.16b

    eor v16.16b, v16.16b, v16.16b
    eor v17.16b, v17.16b, v17.16b
    eor v18.16b, v18.16b, v18.16b
    eor v19.16b, v19.16b, v19.16b

    eor v20.16b, v20.16b, v20.16b
    eor v21.16b, v21.16b, v21.16b
    eor v22.16b, v22.16b, v22.16b
    eor v23.16b, v23.16b, v23.16b

    eor v24.16b, v24.16b, v24.16b
    eor v25.16b, v25.16b, v25.16b
    eor v26.16b, v26.16b, v26.16b
    eor v27.16b, v27.16b, v27.16b

    eor v28.16b, v28.16b, v28.16b
    eor v29.16b, v29.16b, v29.16b
    eor v30.16b, v30.16b, v30.16b
    eor v31.16b, v31.16b, v31.16b

loop_peak_neon_bfmmla_bf16_bf16_fp32:
    sub x0,x0, #1
    bfmmla v0.4s, v30.8h, v31.8h
    bfmmla v1.4s, v30.8h, v31.8h
    bfmmla v2.4s, v30.8h, v31.8h
    bfmmla v3.4s, v30.8h, v31.8h

    bfmmla v4.4s, v30.8h, v31.8h
    bfmmla v5.4s, v30.8h, v31.8h
    bfmmla v6.4s, v30.8h, v31.8h
    bfmmla v7.4s, v30.8h, v31.8h

    bfmmla v8.4s, v30.8h, v31.8h
    bfmmla v9.4s, v30.8h, v31.8h
    bfmmla v10.4s, v30.8h, v31.8h
    bfmmla v11.4s, v30.8h, v31.8h

    bfmmla v12.4s, v30.8h, v31.8h
    bfmmla v13.4s, v30.8h, v31.8h
    bfmmla v14.4s, v30.8h, v31.8h
    bfmmla v15.4s, v30.8h, v31.8h

    bfmmla v16.4s, v30.8h, v31.8h
    bfmmla v17.4s, v30.8h, v31.8h
    bfmmla v18.4s, v30.8h, v31.8h
    bfmmla v19.4s, v30.8h, v31.8h

    bfmmla v20.4s, v30.8h, v31.8h
    bfmmla v21.4s, v30.8h, v31.8h
    bfmmla v22.4s, v30.8h, v31.8h
    bfmmla v23.4s, v30.8h, v31.8h

    bfmmla v24.4s, v30.8h, v31.8h
    bfmmla v25.4s, v30.8h, v31.8h
    bfmmla v26.4s, v30.8h, v31.8h
    bfmmla v27.4s, v30.8h, v31.8h

    bfmmla v28.4s, v30.8h, v31.8h
    bfmmla v29.4s, v30.8h, v31.8h

    cbnz x0, loop_peak_neon_bfmmla_bf16_bf16_fp32

    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    mov x0, 30*32

    ret


    .global _peak_sve_fmla_streaming_fp32_fp32_fp32
    .align 4
_peak_sve_fmla_streaming_fp32_fp32_fp32:
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

    smstart
    eor z0.b, z0.b, z0.b
    eor z1.b, z1.b, z1.b
    eor z2.b, z2.b, z2.b
    eor z3.b, z3.b, z3.b
    eor z4.b, z4.b, z4.b
    eor z5.b, z5.b, z5.b
    eor z6.b, z6.b, z6.b
    eor z7.b, z7.b, z7.b
    eor z8.b, z8.b, z8.b
    eor z9.b, z9.b, z9.b
    eor z10.b, z10.b, z10.b
    eor z11.b, z11.b, z11.b
    eor z12.b, z12.b, z12.b
    eor z13.b, z13.b, z13.b
    eor z14.b, z14.b, z14.b
    eor z15.b, z15.b, z15.b
    eor z16.b, z16.b, z16.b
    eor z17.b, z17.b, z17.b
    eor z18.b, z18.b, z18.b
    eor z19.b, z19.b, z19.b
    eor z20.b, z20.b, z20.b
    eor z21.b, z21.b, z21.b
    eor z22.b, z22.b, z22.b
    eor z23.b, z23.b, z23.b
    eor z24.b, z24.b, z24.b
    eor z25.b, z25.b, z25.b
    eor z26.b, z26.b, z26.b
    eor z27.b, z27.b, z27.b
    eor z28.b, z28.b, z28.b
    eor z29.b, z29.b, z29.b
    eor z30.b, z30.b, z30.b
    eor z31.b, z31.b, z31.b

    ptrue p0.b
loop_peak_sve_fmla_streaming_fp32_fp32_fp32:
    sub x0, x0, #1
    fmla z0.s, p0/m, z30.s, z31.s
    fmla z1.s, p0/m, z30.s, z31.s
    fmla z2.s, p0/m, z30.s, z31.s
    fmla z3.s, p0/m, z30.s, z31.s

    fmla z4.s, p0/m, z30.s, z31.s
    fmla z5.s, p0/m, z30.s, z31.s
    fmla z6.s, p0/m, z30.s, z31.s
    fmla z7.s, p0/m, z30.s, z31.s

    fmla z8.s, p0/m, z30.s, z31.s
    fmla z9.s, p0/m, z30.s, z31.s
    fmla z10.s, p0/m, z30.s, z31.s
    fmla z11.s, p0/m, z30.s, z31.s

    fmla z12.s, p0/m, z30.s, z31.s
    fmla z13.s, p0/m, z30.s, z31.s
    fmla z14.s, p0/m, z30.s, z31.s
    fmla z15.s, p0/m, z30.s, z31.s

    fmla z16.s, p0/m, z30.s, z31.s
    fmla z17.s, p0/m, z30.s, z31.s
    fmla z18.s, p0/m, z30.s, z31.s
    fmla z19.s, p0/m, z30.s, z31.s

    fmla z20.s, p0/m, z30.s, z31.s
    fmla z21.s, p0/m, z30.s, z31.s
    fmla z22.s, p0/m, z30.s, z31.s
    fmla z23.s, p0/m, z30.s, z31.s

    fmla z24.s, p0/m, z30.s, z31.s
    fmla z25.s, p0/m, z30.s, z31.s
    fmla z26.s, p0/m, z30.s, z31.s
    fmla z27.s, p0/m, z30.s, z31.s

    fmla z28.s, p0/m, z30.s, z31.s
    fmla z29.s, p0/m, z30.s, z31.s

    cbnz x0, loop_peak_sve_fmla_streaming_fp32_fp32_fp32

    smstop
    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    mov x0, 30*32

    ret


    .global _peak_sme_fmopa_1_fp32_fp32_fp32
    .align 4
_peak_sme_fmopa_1_fp32_fp32_fp32:
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

    smstart
    ptrue p0.b
    ptrue p1.b
loop_peak_sme_fmopa_1_fp32_fp32_fp32:
    sub x0, x0, #1

    fmopa za0.s, p0/m, p1/m, z0.s, z1.s
    fmopa za0.s, p0/m, p1/m, z2.s, z3.s
    fmopa za0.s, p0/m, p1/m, z4.s, z5.s
    fmopa za0.s, p0/m, p1/m, z6.s, z7.s

    fmopa za0.s, p0/m, p1/m, z8.s, z9.s
    fmopa za0.s, p0/m, p1/m, z10.s, z11.s
    fmopa za0.s, p0/m, p1/m, z12.s, z13.s
    fmopa za0.s, p0/m, p1/m, z14.s, z15.s

    fmopa za0.s, p0/m, p1/m, z16.s, z17.s
    fmopa za0.s, p0/m, p1/m, z18.s, z19.s
    fmopa za0.s, p0/m, p1/m, z20.s, z21.s
    fmopa za0.s, p0/m, p1/m, z22.s, z23.s

    fmopa za0.s, p0/m, p1/m, z24.s, z25.s
    fmopa za0.s, p0/m, p1/m, z26.s, z27.s
    fmopa za0.s, p0/m, p1/m, z28.s, z29.s
    fmopa za0.s, p0/m, p1/m, z30.s, z31.s

    fmopa za0.s, p0/m, p1/m, z0.s, z1.s
    fmopa za0.s, p0/m, p1/m, z2.s, z3.s
    fmopa za0.s, p0/m, p1/m, z4.s, z5.s
    fmopa za0.s, p0/m, p1/m, z6.s, z7.s

    fmopa za0.s, p0/m, p1/m, z8.s, z9.s
    fmopa za0.s, p0/m, p1/m, z10.s, z11.s
    fmopa za0.s, p0/m, p1/m, z12.s, z13.s
    fmopa za0.s, p0/m, p1/m, z14.s, z15.s

    fmopa za0.s, p0/m, p1/m, z16.s, z17.s
    fmopa za0.s, p0/m, p1/m, z18.s, z19.s
    fmopa za0.s, p0/m, p1/m, z20.s, z21.s
    fmopa za0.s, p0/m, p1/m, z22.s, z23.s

    fmopa za0.s, p0/m, p1/m, z24.s, z25.s
    fmopa za0.s, p0/m, p1/m, z26.s, z27.s
    fmopa za0.s, p0/m, p1/m, z28.s, z29.s
    fmopa za0.s, p0/m, p1/m, z30.s, z31.s

    cbnz x0, loop_peak_sme_fmopa_1_fp32_fp32_fp32

    smstop

    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    mov x0, 32*512

    ret


    .global _peak_sme_fmopa_2_fp32_fp32_fp32
    .align 4
_peak_sme_fmopa_2_fp32_fp32_fp32:
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

    smstart
    ptrue p0.b
    ptrue p1.b
loop_peak_sme_fmopa_2_fp32_fp32_fp32:
    sub x0, x0, #1

    fmopa za0.s, p0/m, p1/m, z0.s, z1.s
    fmopa za1.s, p0/m, p1/m, z2.s, z3.s
    fmopa za0.s, p0/m, p1/m, z4.s, z5.s
    fmopa za1.s, p0/m, p1/m, z6.s, z7.s

    fmopa za0.s, p0/m, p1/m, z8.s, z9.s
    fmopa za1.s, p0/m, p1/m, z10.s, z11.s
    fmopa za0.s, p0/m, p1/m, z12.s, z13.s
    fmopa za1.s, p0/m, p1/m, z14.s, z15.s

    fmopa za0.s, p0/m, p1/m, z16.s, z17.s
    fmopa za1.s, p0/m, p1/m, z18.s, z19.s
    fmopa za0.s, p0/m, p1/m, z20.s, z21.s
    fmopa za1.s, p0/m, p1/m, z22.s, z23.s

    fmopa za0.s, p0/m, p1/m, z24.s, z25.s
    fmopa za1.s, p0/m, p1/m, z26.s, z27.s
    fmopa za0.s, p0/m, p1/m, z28.s, z29.s
    fmopa za1.s, p0/m, p1/m, z30.s, z31.s

    fmopa za0.s, p0/m, p1/m, z0.s, z1.s
    fmopa za1.s, p0/m, p1/m, z2.s, z3.s
    fmopa za0.s, p0/m, p1/m, z4.s, z5.s
    fmopa za1.s, p0/m, p1/m, z6.s, z7.s

    fmopa za0.s, p0/m, p1/m, z8.s, z9.s
    fmopa za1.s, p0/m, p1/m, z10.s, z11.s
    fmopa za0.s, p0/m, p1/m, z12.s, z13.s
    fmopa za1.s, p0/m, p1/m, z14.s, z15.s

    fmopa za0.s, p0/m, p1/m, z16.s, z17.s
    fmopa za1.s, p0/m, p1/m, z18.s, z19.s
    fmopa za0.s, p0/m, p1/m, z20.s, z21.s
    fmopa za1.s, p0/m, p1/m, z22.s, z23.s

    fmopa za0.s, p0/m, p1/m, z24.s, z25.s
    fmopa za1.s, p0/m, p1/m, z26.s, z27.s
    fmopa za0.s, p0/m, p1/m, z28.s, z29.s
    fmopa za1.s, p0/m, p1/m, z30.s, z31.s

    cbnz x0, loop_peak_sme_fmopa_2_fp32_fp32_fp32

    smstop

    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    mov x0, 32*512

    ret


    .global _peak_sme_fmopa_4_fp32_fp32_fp32
    .align 4
_peak_sme_fmopa_4_fp32_fp32_fp32:
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

    smstart
    ptrue p0.b
    ptrue p1.b
loop_peak_sme_fmopa_4_fp32_fp32_fp32:
    sub x0, x0, #1

    fmopa za0.s, p0/m, p1/m, z0.s, z1.s
    fmopa za1.s, p0/m, p1/m, z2.s, z3.s
    fmopa za2.s, p0/m, p1/m, z4.s, z5.s
    fmopa za3.s, p0/m, p1/m, z6.s, z7.s

    fmopa za0.s, p0/m, p1/m, z8.s, z9.s
    fmopa za1.s, p0/m, p1/m, z10.s, z11.s
    fmopa za2.s, p0/m, p1/m, z12.s, z13.s
    fmopa za3.s, p0/m, p1/m, z14.s, z15.s

    fmopa za0.s, p0/m, p1/m, z16.s, z17.s
    fmopa za1.s, p0/m, p1/m, z18.s, z19.s
    fmopa za2.s, p0/m, p1/m, z20.s, z21.s
    fmopa za3.s, p0/m, p1/m, z22.s, z23.s

    fmopa za0.s, p0/m, p1/m, z24.s, z25.s
    fmopa za1.s, p0/m, p1/m, z26.s, z27.s
    fmopa za2.s, p0/m, p1/m, z28.s, z29.s
    fmopa za3.s, p0/m, p1/m, z30.s, z31.s

    fmopa za0.s, p0/m, p1/m, z0.s, z1.s
    fmopa za1.s, p0/m, p1/m, z2.s, z3.s
    fmopa za2.s, p0/m, p1/m, z4.s, z5.s
    fmopa za3.s, p0/m, p1/m, z6.s, z7.s

    fmopa za0.s, p0/m, p1/m, z8.s, z9.s
    fmopa za1.s, p0/m, p1/m, z10.s, z11.s
    fmopa za2.s, p0/m, p1/m, z12.s, z13.s
    fmopa za3.s, p0/m, p1/m, z14.s, z15.s

    fmopa za0.s, p0/m, p1/m, z16.s, z17.s
    fmopa za1.s, p0/m, p1/m, z18.s, z19.s
    fmopa za2.s, p0/m, p1/m, z20.s, z21.s
    fmopa za3.s, p0/m, p1/m, z22.s, z23.s
    
    fmopa za0.s, p0/m, p1/m, z24.s, z25.s
    fmopa za1.s, p0/m, p1/m, z26.s, z27.s
    fmopa za2.s, p0/m, p1/m, z28.s, z29.s
    fmopa za3.s, p0/m, p1/m, z30.s, z31.s

    cbnz x0, loop_peak_sme_fmopa_4_fp32_fp32_fp32

    smstop

    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    mov x0, 32*512

    ret


    .global _peak_sme_fmopa_4_reorder_fp32_fp32_fp32
    .align 4
_peak_sme_fmopa_4_reorder_fp32_fp32_fp32:
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

    smstart
    ptrue p0.b
    ptrue p1.b
loop_peak_sme_fmopa_4_reorder_fp32_fp32_fp32:
    sub x0, x0, #1

    fmopa za0.s, p0/m, p1/m, z0.s, z1.s
    fmopa za0.s, p0/m, p1/m, z2.s, z3.s
    fmopa za0.s, p0/m, p1/m, z4.s, z5.s
    fmopa za0.s, p0/m, p1/m, z6.s, z7.s

    fmopa za1.s, p0/m, p1/m, z8.s, z9.s
    fmopa za1.s, p0/m, p1/m, z10.s, z11.s
    fmopa za1.s, p0/m, p1/m, z12.s, z13.s
    fmopa za1.s, p0/m, p1/m, z14.s, z15.s

    fmopa za2.s, p0/m, p1/m, z16.s, z17.s
    fmopa za2.s, p0/m, p1/m, z18.s, z19.s
    fmopa za2.s, p0/m, p1/m, z20.s, z21.s
    fmopa za2.s, p0/m, p1/m, z22.s, z23.s

    fmopa za3.s, p0/m, p1/m, z24.s, z25.s
    fmopa za3.s, p0/m, p1/m, z26.s, z27.s
    fmopa za3.s, p0/m, p1/m, z28.s, z29.s
    fmopa za3.s, p0/m, p1/m, z30.s, z31.s

    fmopa za0.s, p0/m, p1/m, z0.s, z1.s
    fmopa za0.s, p0/m, p1/m, z2.s, z3.s
    fmopa za0.s, p0/m, p1/m, z4.s, z5.s
    fmopa za0.s, p0/m, p1/m, z6.s, z7.s

    fmopa za1.s, p0/m, p1/m, z8.s, z9.s
    fmopa za1.s, p0/m, p1/m, z10.s, z11.s
    fmopa za1.s, p0/m, p1/m, z12.s, z13.s
    fmopa za1.s, p0/m, p1/m, z14.s, z15.s

    fmopa za2.s, p0/m, p1/m, z16.s, z17.s
    fmopa za2.s, p0/m, p1/m, z18.s, z19.s
    fmopa za2.s, p0/m, p1/m, z20.s, z21.s
    fmopa za2.s, p0/m, p1/m, z22.s, z23.s

    fmopa za3.s, p0/m, p1/m, z24.s, z25.s
    fmopa za3.s, p0/m, p1/m, z26.s, z27.s
    fmopa za3.s, p0/m, p1/m, z28.s, z29.s
    fmopa za3.s, p0/m, p1/m, z30.s, z31.s

    cbnz x0, loop_peak_sme_fmopa_4_reorder_fp32_fp32_fp32

    smstop

    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    mov x0, 32*512

    ret


    .global _peak_sme_fmopa_fp16_fp16_fp32
    .align 4
_peak_sme_fmopa_fp16_fp16_fp32:
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

    smstart
    ptrue p0.b
    ptrue p1.b
loop_peak_sme_fmopa_fp16_fp16_fp32:
    sub x0, x0, #1

    fmopa za0.s, p0/m, p1/m, z0.h, z1.h
    fmopa za1.s, p0/m, p1/m, z2.h, z3.h
    fmopa za2.s, p0/m, p1/m, z4.h, z5.h
    fmopa za3.s, p0/m, p1/m, z6.h, z7.h

    fmopa za0.s, p0/m, p1/m, z8.h, z9.h
    fmopa za1.s, p0/m, p1/m, z10.h, z11.h
    fmopa za2.s, p0/m, p1/m, z12.h, z13.h
    fmopa za3.s, p0/m, p1/m, z14.h, z15.h

    fmopa za0.s, p0/m, p1/m, z16.h, z17.h
    fmopa za1.s, p0/m, p1/m, z18.h, z19.h
    fmopa za2.s, p0/m, p1/m, z20.h, z21.h
    fmopa za3.s, p0/m, p1/m, z22.h, z23.h

    fmopa za0.s, p0/m, p1/m, z24.h, z25.h
    fmopa za1.s, p0/m, p1/m, z26.h, z27.h
    fmopa za2.s, p0/m, p1/m, z28.h, z29.h
    fmopa za3.s, p0/m, p1/m, z30.h, z31.h

    fmopa za0.s, p0/m, p1/m, z0.h, z1.h
    fmopa za1.s, p0/m, p1/m, z2.h, z3.h
    fmopa za2.s, p0/m, p1/m, z4.h, z5.h
    fmopa za3.s, p0/m, p1/m, z6.h, z7.h

    fmopa za0.s, p0/m, p1/m, z8.h, z9.h
    fmopa za1.s, p0/m, p1/m, z10.h, z11.h
    fmopa za2.s, p0/m, p1/m, z12.h, z13.h
    fmopa za3.s, p0/m, p1/m, z14.h, z15.h

    fmopa za0.s, p0/m, p1/m, z16.h, z17.h
    fmopa za1.s, p0/m, p1/m, z18.h, z19.h
    fmopa za2.s, p0/m, p1/m, z20.h, z21.h
    fmopa za3.s, p0/m, p1/m, z22.h, z23.h
    
    fmopa za0.s, p0/m, p1/m, z24.h, z25.h
    fmopa za1.s, p0/m, p1/m, z26.h, z27.h
    fmopa za2.s, p0/m, p1/m, z28.h, z29.h
    fmopa za3.s, p0/m, p1/m, z30.h, z31.h

    cbnz x0, loop_peak_sme_fmopa_fp16_fp16_fp32

    smstop

    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    mov x0, 32*1024

    ret


    .global _peak_sme_bfmopa_bf16_bf16_fp32
    .align 4
_peak_sme_bfmopa_bf16_bf16_fp32:
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

    smstart
    ptrue p0.b
    ptrue p1.b
loop_peak_sme_bfmopa_bf16_bf16_fp32:
    sub x0, x0, #1

    bfmopa za0.s, p0/m, p1/m, z0.h, z1.h
    bfmopa za1.s, p0/m, p1/m, z2.h, z3.h
    bfmopa za2.s, p0/m, p1/m, z4.h, z5.h
    bfmopa za3.s, p0/m, p1/m, z6.h, z7.h

    bfmopa za0.s, p0/m, p1/m, z8.h, z9.h
    bfmopa za1.s, p0/m, p1/m, z10.h, z11.h
    bfmopa za2.s, p0/m, p1/m, z12.h, z13.h
    bfmopa za3.s, p0/m, p1/m, z14.h, z15.h

    bfmopa za0.s, p0/m, p1/m, z16.h, z17.h
    bfmopa za1.s, p0/m, p1/m, z18.h, z19.h
    bfmopa za2.s, p0/m, p1/m, z20.h, z21.h
    bfmopa za3.s, p0/m, p1/m, z22.h, z23.h

    bfmopa za0.s, p0/m, p1/m, z24.h, z25.h
    bfmopa za1.s, p0/m, p1/m, z26.h, z27.h
    bfmopa za2.s, p0/m, p1/m, z28.h, z29.h
    bfmopa za3.s, p0/m, p1/m, z30.h, z31.h

    bfmopa za0.s, p0/m, p1/m, z0.h, z1.h
    bfmopa za1.s, p0/m, p1/m, z2.h, z3.h
    bfmopa za2.s, p0/m, p1/m, z4.h, z5.h
    bfmopa za3.s, p0/m, p1/m, z6.h, z7.h

    bfmopa za0.s, p0/m, p1/m, z8.h, z9.h
    bfmopa za1.s, p0/m, p1/m, z10.h, z11.h
    bfmopa za2.s, p0/m, p1/m, z12.h, z13.h
    bfmopa za3.s, p0/m, p1/m, z14.h, z15.h

    bfmopa za0.s, p0/m, p1/m, z16.h, z17.h
    bfmopa za1.s, p0/m, p1/m, z18.h, z19.h
    bfmopa za2.s, p0/m, p1/m, z20.h, z21.h
    bfmopa za3.s, p0/m, p1/m, z22.h, z23.h
    
    bfmopa za0.s, p0/m, p1/m, z24.h, z25.h
    bfmopa za1.s, p0/m, p1/m, z26.h, z27.h
    bfmopa za2.s, p0/m, p1/m, z28.h, z29.h
    bfmopa za3.s, p0/m, p1/m, z30.h, z31.h

    cbnz x0, loop_peak_sme_bfmopa_bf16_bf16_fp32

    smstop

    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    mov x0, 32*1024

    ret

    .global _example_sme_fmopa_fp32_fp32_fp32
    .align 4
_example_sme_fmopa_fp32_fp32_fp32:
    smstart

    ptrue p0.b

    ldr z0, [x0]
    ldr z1, [x1]

    fmopa za0.s, p0/m, p0/m, z0.s, z1.s

    mov w12, #0
    mov x3, #16

loop_example_sme_fmopa_fp32_fp32_fp32:
    str za[w12, #0], [x2]

    add w12, w12, #4
    add x2, x2,   #16*4
    sub x3, x3,   #1

    cbnz x3, loop_example_sme_fmopa_fp32_fp32_fp32

    smstop

    ret

    .global _example_sme_bfmopa_bf16_bf16_fp32
    .align 4
_example_sme_bfmopa_bf16_bf16_fp32:
    smstart

    ptrue p0.b

    ldr z0, [x0]
    ldr z1, [x1]

    bfmopa za0.s, p0/m, p0/m, z0.h, z1.h

    mov w12, #0
    mov x3, #16

loop_example_sme_bfmopa_bf16_bf16_fp32:
    str za[w12, #0], [x2]

    add w12, w12, #4
    add x2, x2,   #16*4
    sub x3, x3,   #1

    cbnz x3, loop_example_sme_bfmopa_bf16_bf16_fp32

    smstop

    ret


    .global _example_zip4_fp32
    .align 4
_example_zip4_fp32:
    smstart

    ldr z0, [x0]
    add x0, x0, #16*4
    ldr z1, [x0]
    add x0, x0, #16*4
    ldr z2, [x0]
    add x0, x0, #16*4
    ldr z3, [x0]

    zip {z4.s-z7.s}, {z0.s-z3.s}

    str z4, [x1]
    add x1, x1, #16*4
    str z5, [x1]
    add x1, x1, #16*4
    str z6, [x1]
    add x1, x1, #16*4
    str z7, [x1]

    smstop

    ret


    .text
    .align 4
    .global _triad_neon
_triad_neon:
    str d8, [sp, #-16]!

    fmov v8.4s, #2.000000000000000000e+00

loop_triad_neon_rep:
    mov x5, x1
    mov x6, x2
    mov x7, x3
    mov x8, x4

    // perform triad in chunks of 48 values
loop_triad_neon_val:
    ld1 {v0.4s-v3.4s}, [x6]
    ld1 {v4.4s-v7.4s}, [x7]
    add x6, x6, #0x40
    add x7, x7, #0x40
    fmla v0.4s, v8.4s, v4.4s
    fmla v1.4s, v8.4s, v5.4s
    fmla v2.4s, v8.4s, v6.4s
    fmla v3.4s, v8.4s, v7.4s
    st1 {v0.4s-v3.4s}, [x8]
    add x8, x8, #0x40

    ld1 {v16.4s-v19.4s}, [x6]
    ld1 {v20.4s-v23.4s}, [x7]
    add x6, x6, #0x40
    add x7, x7, #0x40
    fmla v16.4s, v8.4s, v20.4s
    fmla v17.4s, v8.4s, v21.4s
    fmla v18.4s, v8.4s, v22.4s
    fmla v19.4s, v8.4s, v23.4s
    st1 {v16.4s-v19.4s}, [x8]
    add x8, x8, #0x40

    ld1 {v24.4s-v27.4s}, [x6]
    ld1 {v28.4s-v31.4s}, [x7]
    add x6, x6, #0x40
    add x7, x7, #0x40
    fmla v24.4s, v8.4s, v28.4s
    fmla v25.4s, v8.4s, v29.4s
    fmla v26.4s, v8.4s, v30.4s
    fmla v27.4s, v8.4s, v31.4s
    st1 {v24.4s-v27.4s}, [x8]
    add x8, x8, #0x40

    sub x5, x5, #48

    cbnz x5, loop_triad_neon_val

    sub x0, x0, #1
    cbnz x0, loop_triad_neon_rep

    ldr d8, [sp], #16
    ret


    .text
    .align 4
    .global _peak_amx_fma_fp32_fp32_fp32
_peak_amx_fma_fp32_fp32_fp32:
    // enable AMX
    .word 0x00201220

    // argument registers for fmas
    mov x11, #0
    mov x12, #0
    mov x13, #0
    mov x14, #0

    mov x10, #1
    add x12, x12, x10, lsl #20
    add x10, x10, #1
    add x13, x13, x10, lsl #20
    add x10, x10, #1
    add x14, x14, x10, lsl #20

loop_peak_amx_fma_fp32_fp32_fp32:
    // do the 20 amx-ops
    // each doing 16*16 fma ops
    .inst 0x20118b // x11
    .inst 0x20118c // x12
    .inst 0x20118d // x13
    .inst 0x20118e // x14

    .inst 0x20118b // x11
    .inst 0x20118c // x12
    .inst 0x20118d // x13
    .inst 0x20118e // x14

    .inst 0x20118b // x11
    .inst 0x20118c // x12
    .inst 0x20118d // x13
    .inst 0x20118e // x14

    .inst 0x20118b // x11
    .inst 0x20118c // x12
    .inst 0x20118d // x13
    .inst 0x20118e // x14

    .inst 0x20118b // x11
    .inst 0x20118c // x12
    .inst 0x20118d // x13
    .inst 0x20118e // x14

    sub x0, x0, #1
    cbnz x0, loop_peak_amx_fma_fp32_fp32_fp32

    // disable AMX
    .word 0x00201221

    mov x0, #20*512

    ret


    .global _peak_sme_fmopa_smstart_smstop_8_fp32_fp32_fp32
    .align 4
_peak_sme_fmopa_smstart_smstop_8_fp32_fp32_fp32:
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

loop_peak_sme_fmopa_smstart_smstop_8_fp32_fp32_fp32_outer:
    sub x0, x0, #1

    smstart
    ptrue p0.b
    ptrue p1.b

    fmopa za0.s, p0/m, p1/m, z0.s, z1.s
    fmopa za1.s, p0/m, p1/m, z2.s, z3.s
    fmopa za2.s, p0/m, p1/m, z4.s, z5.s
    fmopa za3.s, p0/m, p1/m, z6.s, z7.s

    fmopa za0.s, p0/m, p1/m, z8.s, z9.s
    fmopa za1.s, p0/m, p1/m, z10.s, z11.s
    fmopa za2.s, p0/m, p1/m, z12.s, z13.s
    fmopa za3.s, p0/m, p1/m, z14.s, z15.s

    smstop

    cbnz x0, loop_peak_sme_fmopa_smstart_smstop_8_fp32_fp32_fp32_outer


    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    mov x0, #8*512

    ret


    .global _peak_sme_fmopa_smstart_smstop_16_fp32_fp32_fp32
    .align 4
_peak_sme_fmopa_smstart_smstop_16_fp32_fp32_fp32:
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

loop_peak_sme_fmopa_smstart_smstop_16_fp32_fp32_fp32_outer:
    sub x0, x0, #1

    smstart
    ptrue p0.b
    ptrue p1.b

    fmopa za0.s, p0/m, p1/m, z0.s, z1.s
    fmopa za1.s, p0/m, p1/m, z2.s, z3.s
    fmopa za2.s, p0/m, p1/m, z4.s, z5.s
    fmopa za3.s, p0/m, p1/m, z6.s, z7.s

    fmopa za0.s, p0/m, p1/m, z8.s, z9.s
    fmopa za1.s, p0/m, p1/m, z10.s, z11.s
    fmopa za2.s, p0/m, p1/m, z12.s, z13.s
    fmopa za3.s, p0/m, p1/m, z14.s, z15.s

    fmopa za0.s, p0/m, p1/m, z16.s, z17.s
    fmopa za1.s, p0/m, p1/m, z18.s, z19.s
    fmopa za2.s, p0/m, p1/m, z20.s, z21.s
    fmopa za3.s, p0/m, p1/m, z22.s, z23.s

    fmopa za0.s, p0/m, p1/m, z24.s, z25.s
    fmopa za1.s, p0/m, p1/m, z26.s, z27.s
    fmopa za2.s, p0/m, p1/m, z28.s, z29.s
    fmopa za3.s, p0/m, p1/m, z30.s, z31.s

    smstop

    cbnz x0, loop_peak_sme_fmopa_smstart_smstop_16_fp32_fp32_fp32_outer


    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    mov x0, #16*512

    ret

    .global _peak_sme_fmopa_smstart_smstop_32_fp32_fp32_fp32
    .align 4
_peak_sme_fmopa_smstart_smstop_32_fp32_fp32_fp32:
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

loop_peak_sme_fmopa_smstart_smstop_32_fp32_fp32_fp32_outer:
    sub x0, x0, #1

    smstart
    ptrue p0.b
    ptrue p1.b

    fmopa za0.s, p0/m, p1/m, z0.s, z1.s
    fmopa za1.s, p0/m, p1/m, z2.s, z3.s
    fmopa za2.s, p0/m, p1/m, z4.s, z5.s
    fmopa za3.s, p0/m, p1/m, z6.s, z7.s

    fmopa za0.s, p0/m, p1/m, z8.s, z9.s
    fmopa za1.s, p0/m, p1/m, z10.s, z11.s
    fmopa za2.s, p0/m, p1/m, z12.s, z13.s
    fmopa za3.s, p0/m, p1/m, z14.s, z15.s

    fmopa za0.s, p0/m, p1/m, z16.s, z17.s
    fmopa za1.s, p0/m, p1/m, z18.s, z19.s
    fmopa za2.s, p0/m, p1/m, z20.s, z21.s
    fmopa za3.s, p0/m, p1/m, z22.s, z23.s

    fmopa za0.s, p0/m, p1/m, z24.s, z25.s
    fmopa za1.s, p0/m, p1/m, z26.s, z27.s
    fmopa za2.s, p0/m, p1/m, z28.s, z29.s
    fmopa za3.s, p0/m, p1/m, z30.s, z31.s

    fmopa za0.s, p0/m, p1/m, z0.s, z1.s
    fmopa za1.s, p0/m, p1/m, z2.s, z3.s
    fmopa za2.s, p0/m, p1/m, z4.s, z5.s
    fmopa za3.s, p0/m, p1/m, z6.s, z7.s

    fmopa za0.s, p0/m, p1/m, z8.s, z9.s
    fmopa za1.s, p0/m, p1/m, z10.s, z11.s
    fmopa za2.s, p0/m, p1/m, z12.s, z13.s
    fmopa za3.s, p0/m, p1/m, z14.s, z15.s

    fmopa za0.s, p0/m, p1/m, z16.s, z17.s
    fmopa za1.s, p0/m, p1/m, z18.s, z19.s
    fmopa za2.s, p0/m, p1/m, z20.s, z21.s
    fmopa za3.s, p0/m, p1/m, z22.s, z23.s
    
    fmopa za0.s, p0/m, p1/m, z24.s, z25.s
    fmopa za1.s, p0/m, p1/m, z26.s, z27.s
    fmopa za2.s, p0/m, p1/m, z28.s, z29.s
    fmopa za3.s, p0/m, p1/m, z30.s, z31.s

    smstop

    cbnz x0, loop_peak_sme_fmopa_smstart_smstop_32_fp32_fp32_fp32_outer


    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    mov x0, #32*512

    ret


    .global _peak_sme_fmopa_smstart_smstop_64_fp32_fp32_fp32
    .align 4
_peak_sme_fmopa_smstart_smstop_64_fp32_fp32_fp32:
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

loop_peak_sme_fmopa_smstart_smstop_64_fp32_fp32_fp32_outer:
    sub x0, x0, #1

    smstart
    ptrue p0.b
    ptrue p1.b

    mov x1, #2
loop_peak_sme_fmopa_smstart_smstop_64_fp32_fp32_fp32_inner:
    sub x1, x1, #1

    fmopa za0.s, p0/m, p1/m, z0.s, z1.s
    fmopa za1.s, p0/m, p1/m, z2.s, z3.s
    fmopa za2.s, p0/m, p1/m, z4.s, z5.s
    fmopa za3.s, p0/m, p1/m, z6.s, z7.s

    fmopa za0.s, p0/m, p1/m, z8.s, z9.s
    fmopa za1.s, p0/m, p1/m, z10.s, z11.s
    fmopa za2.s, p0/m, p1/m, z12.s, z13.s
    fmopa za3.s, p0/m, p1/m, z14.s, z15.s

    fmopa za0.s, p0/m, p1/m, z16.s, z17.s
    fmopa za1.s, p0/m, p1/m, z18.s, z19.s
    fmopa za2.s, p0/m, p1/m, z20.s, z21.s
    fmopa za3.s, p0/m, p1/m, z22.s, z23.s

    fmopa za0.s, p0/m, p1/m, z24.s, z25.s
    fmopa za1.s, p0/m, p1/m, z26.s, z27.s
    fmopa za2.s, p0/m, p1/m, z28.s, z29.s
    fmopa za3.s, p0/m, p1/m, z30.s, z31.s

    fmopa za0.s, p0/m, p1/m, z0.s, z1.s
    fmopa za1.s, p0/m, p1/m, z2.s, z3.s
    fmopa za2.s, p0/m, p1/m, z4.s, z5.s
    fmopa za3.s, p0/m, p1/m, z6.s, z7.s

    fmopa za0.s, p0/m, p1/m, z8.s, z9.s
    fmopa za1.s, p0/m, p1/m, z10.s, z11.s
    fmopa za2.s, p0/m, p1/m, z12.s, z13.s
    fmopa za3.s, p0/m, p1/m, z14.s, z15.s

    fmopa za0.s, p0/m, p1/m, z16.s, z17.s
    fmopa za1.s, p0/m, p1/m, z18.s, z19.s
    fmopa za2.s, p0/m, p1/m, z20.s, z21.s
    fmopa za3.s, p0/m, p1/m, z22.s, z23.s
    
    fmopa za0.s, p0/m, p1/m, z24.s, z25.s
    fmopa za1.s, p0/m, p1/m, z26.s, z27.s
    fmopa za2.s, p0/m, p1/m, z28.s, z29.s
    fmopa za3.s, p0/m, p1/m, z30.s, z31.s

    cbnz x1, loop_peak_sme_fmopa_smstart_smstop_64_fp32_fp32_fp32_inner

    smstop

    cbnz x0, loop_peak_sme_fmopa_smstart_smstop_64_fp32_fp32_fp32_outer


    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    mov x0, #64*512

    ret


    .global _peak_sme_fmopa_smstart_smstop_128_fp32_fp32_fp32
    .align 4
_peak_sme_fmopa_smstart_smstop_128_fp32_fp32_fp32:
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

loop_peak_sme_fmopa_smstart_smstop_128_fp32_fp32_fp32_outer:
    sub x0, x0, #1

    smstart
    ptrue p0.b
    ptrue p1.b

    mov x1, #4
loop_peak_sme_fmopa_smstart_smstop_128_fp32_fp32_fp32_inner:
    sub x1, x1, #1

    fmopa za0.s, p0/m, p1/m, z0.s, z1.s
    fmopa za1.s, p0/m, p1/m, z2.s, z3.s
    fmopa za2.s, p0/m, p1/m, z4.s, z5.s
    fmopa za3.s, p0/m, p1/m, z6.s, z7.s

    fmopa za0.s, p0/m, p1/m, z8.s, z9.s
    fmopa za1.s, p0/m, p1/m, z10.s, z11.s
    fmopa za2.s, p0/m, p1/m, z12.s, z13.s
    fmopa za3.s, p0/m, p1/m, z14.s, z15.s

    fmopa za0.s, p0/m, p1/m, z16.s, z17.s
    fmopa za1.s, p0/m, p1/m, z18.s, z19.s
    fmopa za2.s, p0/m, p1/m, z20.s, z21.s
    fmopa za3.s, p0/m, p1/m, z22.s, z23.s

    fmopa za0.s, p0/m, p1/m, z24.s, z25.s
    fmopa za1.s, p0/m, p1/m, z26.s, z27.s
    fmopa za2.s, p0/m, p1/m, z28.s, z29.s
    fmopa za3.s, p0/m, p1/m, z30.s, z31.s

    fmopa za0.s, p0/m, p1/m, z0.s, z1.s
    fmopa za1.s, p0/m, p1/m, z2.s, z3.s
    fmopa za2.s, p0/m, p1/m, z4.s, z5.s
    fmopa za3.s, p0/m, p1/m, z6.s, z7.s

    fmopa za0.s, p0/m, p1/m, z8.s, z9.s
    fmopa za1.s, p0/m, p1/m, z10.s, z11.s
    fmopa za2.s, p0/m, p1/m, z12.s, z13.s
    fmopa za3.s, p0/m, p1/m, z14.s, z15.s

    fmopa za0.s, p0/m, p1/m, z16.s, z17.s
    fmopa za1.s, p0/m, p1/m, z18.s, z19.s
    fmopa za2.s, p0/m, p1/m, z20.s, z21.s
    fmopa za3.s, p0/m, p1/m, z22.s, z23.s
    
    fmopa za0.s, p0/m, p1/m, z24.s, z25.s
    fmopa za1.s, p0/m, p1/m, z26.s, z27.s
    fmopa za2.s, p0/m, p1/m, z28.s, z29.s
    fmopa za3.s, p0/m, p1/m, z30.s, z31.s

    cbnz x1, loop_peak_sme_fmopa_smstart_smstop_128_fp32_fp32_fp32_inner

    smstop

    cbnz x0, loop_peak_sme_fmopa_smstart_smstop_128_fp32_fp32_fp32_outer


    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    mov x0, #128*512

    ret


    .global _peak_sme_fmopa_fp16_fp16_fp16
    .align 4
_peak_sme_fmopa_fp16_fp16_fp16:
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

    smstart
    ptrue p0.b
    ptrue p1.b
loop_peak_sme_fmopa_fp16_fp16_fp16:
    sub x0, x0, #1

    fmopa za0.h, p0/m, p1/m, z0.h, z1.h
    fmopa za1.h, p0/m, p1/m, z2.h, z3.h
    fmopa za0.h, p0/m, p1/m, z4.h, z5.h
    fmopa za1.h, p0/m, p1/m, z6.h, z7.h

    fmopa za0.h, p0/m, p1/m, z8.h, z9.h
    fmopa za1.h, p0/m, p1/m, z10.h, z11.h
    fmopa za0.h, p0/m, p1/m, z12.h, z13.h
    fmopa za1.h, p0/m, p1/m, z14.h, z15.h

    fmopa za0.h, p0/m, p1/m, z16.h, z17.h
    fmopa za1.h, p0/m, p1/m, z18.h, z19.h
    fmopa za0.h, p0/m, p1/m, z20.h, z21.h
    fmopa za1.h, p0/m, p1/m, z22.h, z23.h

    fmopa za0.h, p0/m, p1/m, z24.h, z25.h
    fmopa za1.h, p0/m, p1/m, z26.h, z27.h
    fmopa za0.h, p0/m, p1/m, z28.h, z29.h
    fmopa za1.h, p0/m, p1/m, z30.h, z31.h

    fmopa za0.h, p0/m, p1/m, z0.h, z1.h
    fmopa za1.h, p0/m, p1/m, z2.h, z3.h
    fmopa za0.h, p0/m, p1/m, z4.h, z5.h
    fmopa za1.h, p0/m, p1/m, z6.h, z7.h

    fmopa za0.h, p0/m, p1/m, z8.h, z9.h
    fmopa za1.h, p0/m, p1/m, z10.h, z11.h
    fmopa za0.h, p0/m, p1/m, z12.h, z13.h
    fmopa za1.h, p0/m, p1/m, z14.h, z15.h

    fmopa za0.h, p0/m, p1/m, z16.h, z17.h
    fmopa za1.h, p0/m, p1/m, z18.h, z19.h
    fmopa za0.h, p0/m, p1/m, z20.h, z21.h
    fmopa za1.h, p0/m, p1/m, z22.h, z23.h
    
    fmopa za0.h, p0/m, p1/m, z24.h, z25.h
    fmopa za1.h, p0/m, p1/m, z26.h, z27.h
    fmopa za0.h, p0/m, p1/m, z28.h, z29.h
    fmopa za1.h, p0/m, p1/m, z30.h, z31.h

    cbnz x0, loop_peak_sme_fmopa_fp16_fp16_fp16

    smstop

    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    mov x0, 32*2048

    ret

    .global _peak_sme_bfmopa_bf16_bf16_bf16
    .align 4
_peak_sme_bfmopa_bf16_bf16_bf16:
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

    smstart
    ptrue p0.b
    ptrue p1.b
loop_peak_sme_bfmopa_bf16_bf16_bf16:
    sub x0, x0, #1

    bfmopa za0.h, p0/m, p1/m, z0.h, z1.h
    bfmopa za1.h, p0/m, p1/m, z2.h, z3.h
    bfmopa za0.h, p0/m, p1/m, z4.h, z5.h
    bfmopa za1.h, p0/m, p1/m, z6.h, z7.h

    bfmopa za0.h, p0/m, p1/m, z8.h, z9.h
    bfmopa za1.h, p0/m, p1/m, z10.h, z11.h
    bfmopa za0.h, p0/m, p1/m, z12.h, z13.h
    bfmopa za1.h, p0/m, p1/m, z14.h, z15.h

    bfmopa za0.h, p0/m, p1/m, z16.h, z17.h
    bfmopa za1.h, p0/m, p1/m, z18.h, z19.h
    bfmopa za0.h, p0/m, p1/m, z20.h, z21.h
    bfmopa za1.h, p0/m, p1/m, z22.h, z23.h

    bfmopa za0.h, p0/m, p1/m, z24.h, z25.h
    bfmopa za1.h, p0/m, p1/m, z26.h, z27.h
    bfmopa za0.h, p0/m, p1/m, z28.h, z29.h
    bfmopa za1.h, p0/m, p1/m, z30.h, z31.h

    bfmopa za0.h, p0/m, p1/m, z0.h, z1.h
    bfmopa za1.h, p0/m, p1/m, z2.h, z3.h
    bfmopa za0.h, p0/m, p1/m, z4.h, z5.h
    bfmopa za1.h, p0/m, p1/m, z6.h, z7.h

    bfmopa za0.h, p0/m, p1/m, z8.h, z9.h
    bfmopa za1.h, p0/m, p1/m, z10.h, z11.h
    bfmopa za0.h, p0/m, p1/m, z12.h, z13.h
    bfmopa za1.h, p0/m, p1/m, z14.h, z15.h

    bfmopa za0.h, p0/m, p1/m, z16.h, z17.h
    bfmopa za1.h, p0/m, p1/m, z18.h, z19.h
    bfmopa za0.h, p0/m, p1/m, z20.h, z21.h
    bfmopa za1.h, p0/m, p1/m, z22.h, z23.h
    
    bfmopa za0.h, p0/m, p1/m, z24.h, z25.h
    bfmopa za1.h, p0/m, p1/m, z26.h, z27.h
    bfmopa za0.h, p0/m, p1/m, z28.h, z29.h
    bfmopa za1.h, p0/m, p1/m, z30.h, z31.h

    cbnz x0, loop_peak_sme_bfmopa_bf16_bf16_bf16

    smstop

    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    mov x0, 32*2048

    ret

    .global _peak_sme_fmopa_fp64_fp64_fp64
    .align 4
_peak_sme_fmopa_fp64_fp64_fp64:
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

    smstart
    ptrue p0.b
    ptrue p1.b
loop_peak_sme_fmopa_fp64_fp64_fp64:
    sub x0, x0, #1

    fmopa za0.d, p0/m, p1/m, z0.d, z1.d
    fmopa za1.d, p0/m, p1/m, z2.d, z3.d
    fmopa za2.d, p0/m, p1/m, z4.d, z5.d
    fmopa za3.d, p0/m, p1/m, z6.d, z7.d

    fmopa za4.d, p0/m, p1/m, z8.d, z9.d
    fmopa za5.d, p0/m, p1/m, z10.d, z11.d
    fmopa za6.d, p0/m, p1/m, z12.d, z13.d
    fmopa za7.d, p0/m, p1/m, z14.d, z15.d

    fmopa za0.d, p0/m, p1/m, z16.d, z17.d
    fmopa za1.d, p0/m, p1/m, z18.d, z19.d
    fmopa za2.d, p0/m, p1/m, z20.d, z21.d
    fmopa za3.d, p0/m, p1/m, z22.d, z23.d

    fmopa za4.d, p0/m, p1/m, z24.d, z25.d
    fmopa za5.d, p0/m, p1/m, z26.d, z27.d
    fmopa za6.d, p0/m, p1/m, z28.d, z29.d
    fmopa za7.d, p0/m, p1/m, z30.d, z31.d

    fmopa za0.d, p0/m, p1/m, z0.d, z1.d
    fmopa za1.d, p0/m, p1/m, z2.d, z3.d
    fmopa za2.d, p0/m, p1/m, z4.d, z5.d
    fmopa za3.d, p0/m, p1/m, z6.d, z7.d

    fmopa za4.d, p0/m, p1/m, z8.d, z9.d
    fmopa za5.d, p0/m, p1/m, z10.d, z11.d
    fmopa za6.d, p0/m, p1/m, z12.d, z13.d
    fmopa za7.d, p0/m, p1/m, z14.d, z15.d

    fmopa za0.d, p0/m, p1/m, z16.d, z17.d
    fmopa za1.d, p0/m, p1/m, z18.d, z19.d
    fmopa za2.d, p0/m, p1/m, z20.d, z21.d
    fmopa za3.d, p0/m, p1/m, z22.d, z23.d
    
    fmopa za4.d, p0/m, p1/m, z24.d, z25.d
    fmopa za5.d, p0/m, p1/m, z26.d, z27.d
    fmopa za6.d, p0/m, p1/m, z28.d, z29.d
    fmopa za7.d, p0/m, p1/m, z30.d, z31.d

    cbnz x0, loop_peak_sme_fmopa_fp64_fp64_fp64

    smstop

    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    mov x0, 32*128

    ret


    .global _peak_sme_smopa_i8_i8_i32
    .align 4
_peak_sme_smopa_i8_i8_i32:
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

    smstart
    ptrue p0.b
    ptrue p1.b
loop_peak_sme_smopa_i8_i8_i32:
    sub x0, x0, #1

    smopa za0.s, p0/m, p1/m, z0.b, z1.b
    smopa za1.s, p0/m, p1/m, z2.b, z3.b
    smopa za2.s, p0/m, p1/m, z4.b, z5.b
    smopa za3.s, p0/m, p1/m, z6.b, z7.b

    smopa za0.s, p0/m, p1/m, z8.b, z9.b
    smopa za1.s, p0/m, p1/m, z10.b, z11.b
    smopa za2.s, p0/m, p1/m, z12.b, z13.b
    smopa za3.s, p0/m, p1/m, z14.b, z15.b

    smopa za0.s, p0/m, p1/m, z16.b, z17.b
    smopa za1.s, p0/m, p1/m, z18.b, z19.b
    smopa za2.s, p0/m, p1/m, z20.b, z21.b
    smopa za3.s, p0/m, p1/m, z22.b, z23.b

    smopa za0.s, p0/m, p1/m, z24.b, z25.b
    smopa za1.s, p0/m, p1/m, z26.b, z27.b
    smopa za2.s, p0/m, p1/m, z28.b, z29.b
    smopa za3.s, p0/m, p1/m, z30.b, z31.b

    smopa za0.s, p0/m, p1/m, z0.b, z1.b
    smopa za1.s, p0/m, p1/m, z2.b, z3.b
    smopa za2.s, p0/m, p1/m, z4.b, z5.b
    smopa za3.s, p0/m, p1/m, z6.b, z7.b

    smopa za0.s, p0/m, p1/m, z8.b, z9.b
    smopa za1.s, p0/m, p1/m, z10.b, z11.b
    smopa za2.s, p0/m, p1/m, z12.b, z13.b
    smopa za3.s, p0/m, p1/m, z14.b, z15.b

    smopa za0.s, p0/m, p1/m, z16.b, z17.b
    smopa za1.s, p0/m, p1/m, z18.b, z19.b
    smopa za2.s, p0/m, p1/m, z20.b, z21.b
    smopa za3.s, p0/m, p1/m, z22.b, z23.b

    smopa za0.s, p0/m, p1/m, z24.b, z25.b
    smopa za1.s, p0/m, p1/m, z26.b, z27.b
    smopa za2.s, p0/m, p1/m, z28.b, z29.b
    smopa za3.s, p0/m, p1/m, z30.b, z31.b

    cbnz x0, loop_peak_sme_smopa_i8_i8_i32

    smstop

    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    mov x0, 32*2048

    ret


    .global _peak_sme_smopa_i16_i16_i32
    .align 4
_peak_sme_smopa_i16_i16_i32:
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

    smstart
    ptrue p0.b
    ptrue p1.b
loop_peak_sme_smopa_i16_i16_i32:
    sub x0, x0, #1

    smopa za0.s, p0/m, p1/m, z0.h, z1.h
    smopa za1.s, p0/m, p1/m, z2.h, z3.h
    smopa za2.s, p0/m, p1/m, z4.h, z5.h
    smopa za3.s, p0/m, p1/m, z6.h, z7.h

    smopa za0.s, p0/m, p1/m, z8.h, z9.h
    smopa za1.s, p0/m, p1/m, z10.h, z11.h
    smopa za2.s, p0/m, p1/m, z12.h, z13.h
    smopa za3.s, p0/m, p1/m, z14.h, z15.h

    smopa za0.s, p0/m, p1/m, z16.h, z17.h
    smopa za1.s, p0/m, p1/m, z18.h, z19.h
    smopa za2.s, p0/m, p1/m, z20.h, z21.h
    smopa za3.s, p0/m, p1/m, z22.h, z23.h

    smopa za0.s, p0/m, p1/m, z24.h, z25.h
    smopa za1.s, p0/m, p1/m, z26.h, z27.h
    smopa za2.s, p0/m, p1/m, z28.h, z29.h
    smopa za3.s, p0/m, p1/m, z30.h, z31.h

    smopa za0.s, p0/m, p1/m, z0.h, z1.h
    smopa za1.s, p0/m, p1/m, z2.h, z3.h
    smopa za2.s, p0/m, p1/m, z4.h, z5.h
    smopa za3.s, p0/m, p1/m, z6.h, z7.h

    smopa za0.s, p0/m, p1/m, z8.h, z9.h
    smopa za1.s, p0/m, p1/m, z10.h, z11.h
    smopa za2.s, p0/m, p1/m, z12.h, z13.h
    smopa za3.s, p0/m, p1/m, z14.h, z15.h

    smopa za0.s, p0/m, p1/m, z16.h, z17.h
    smopa za1.s, p0/m, p1/m, z18.h, z19.h
    smopa za2.s, p0/m, p1/m, z20.h, z21.h
    smopa za3.s, p0/m, p1/m, z22.h, z23.h

    smopa za0.s, p0/m, p1/m, z24.h, z25.h
    smopa za1.s, p0/m, p1/m, z26.h, z27.h
    smopa za2.s, p0/m, p1/m, z28.h, z29.h
    smopa za3.s, p0/m, p1/m, z30.h, z31.h

    cbnz x0, loop_peak_sme_smopa_i16_i16_i32

    smstop

    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    mov x0, 32*1024

    ret