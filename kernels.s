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
    .global _peak_neon_fmla_fp64_fp64_fp64
_peak_neon_fmla_fp64_fp64_fp64:
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

loop_peak_neon_fmla_fp64_fp64_fp64:
    sub x0,x0, #1
    fmla v0.2d, v30.2d, v31.2d
    fmla v1.2d, v30.2d, v31.2d
    fmla v2.2d, v30.2d, v31.2d
    fmla v3.2d, v30.2d, v31.2d

    fmla v4.2d, v30.2d, v31.2d
    fmla v5.2d, v30.2d, v31.2d
    fmla v6.2d, v30.2d, v31.2d
    fmla v7.2d, v30.2d, v31.2d

    fmla v8.2d, v30.2d, v31.2d
    fmla v9.2d, v30.2d, v31.2d
    fmla v10.2d, v30.2d, v31.2d
    fmla v11.2d, v30.2d, v31.2d
    
    fmla v12.2d, v30.2d, v31.2d
    fmla v13.2d, v30.2d, v31.2d
    fmla v14.2d, v30.2d, v31.2d
    fmla v15.2d, v30.2d, v31.2d
    
    fmla v16.2d, v30.2d, v31.2d
    fmla v17.2d, v30.2d, v31.2d
    fmla v18.2d, v30.2d, v31.2d
    fmla v19.2d, v30.2d, v31.2d

    fmla v20.2d, v30.2d, v31.2d
    fmla v21.2d, v30.2d, v31.2d
    fmla v22.2d, v30.2d, v31.2d
    fmla v23.2d, v30.2d, v31.2d

    fmla v24.2d, v30.2d, v31.2d
    fmla v25.2d, v30.2d, v31.2d
    fmla v26.2d, v30.2d, v31.2d
    fmla v27.2d, v30.2d, v31.2d

    fmla v28.2d, v30.2d, v31.2d
    fmla v29.2d, v30.2d, v31.2d
    

    cbnz x0, loop_peak_neon_fmla_fp64_fp64_fp64

    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    mov x0, 30*4

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
    .global _peak_neon_fmla_fp16_fp16_fp16
_peak_neon_fmla_fp16_fp16_fp16:
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

loop_peak_neon_fmla_fp16_fp16_fp16:
    sub x0,x0, #1
    fmla v0.8h, v30.8h, v31.8h
    fmla v1.8h, v30.8h, v31.8h
    fmla v2.8h, v30.8h, v31.8h
    fmla v3.8h, v30.8h, v31.8h
    
    fmla v4.8h, v30.8h, v31.8h
    fmla v5.8h, v30.8h, v31.8h
    fmla v6.8h, v30.8h, v31.8h
    fmla v7.8h, v30.8h, v31.8h

    fmla v8.8h, v30.8h, v31.8h
    fmla v9.8h, v30.8h, v31.8h
    fmla v10.8h, v30.8h, v31.8h
    fmla v11.8h, v30.8h, v31.8h

    fmla v12.8h, v30.8h, v31.8h
    fmla v13.8h, v30.8h, v31.8h
    fmla v14.8h, v30.8h, v31.8h
    fmla v15.8h, v30.8h, v31.8h

    fmla v16.8h, v30.8h, v31.8h
    fmla v17.8h, v30.8h, v31.8h
    fmla v18.8h, v30.8h, v31.8h
    fmla v19.8h, v30.8h, v31.8h

    fmla v20.8h, v30.8h, v31.8h
    fmla v21.8h, v30.8h, v31.8h
    fmla v22.8h, v30.8h, v31.8h
    fmla v23.8h, v30.8h, v31.8h

    fmla v24.8h, v30.8h, v31.8h
    fmla v25.8h, v30.8h, v31.8h
    fmla v26.8h, v30.8h, v31.8h
    fmla v27.8h, v30.8h, v31.8h
    
    fmla v28.8h, v30.8h, v31.8h
    fmla v29.8h, v30.8h, v31.8h    

    cbnz x0, loop_peak_neon_fmla_fp16_fp16_fp16

    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    mov x0, 30*16

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


    .global _example_ld1w_2_pred
    .align 4
_example_ld1w_2_pred:
    smstart

    mov x2, #0
    mov x3, #31
    whilelt pn8.s, x2, x3, vlx2

    ld1w {z0.s, z1.s}, pn8/z, [x0]
    st1w {z0.s, z1.s}, pn8,   [x1]

    smstop

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


    .global _peak_sme_fmopa_4_fp32_fp32_fp32_predicated_15
    .align 4
_peak_sme_fmopa_4_fp32_fp32_fp32_predicated_15:
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

    smstart
    ptrue p0.b
    mov x10, #1
    mov x11, #16
    whilelt p1.s, x10, x11
loop_peak_sme_fmopa_4_fp32_fp32_fp32_predicated_15:
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

    cbnz x0, loop_peak_sme_fmopa_4_fp32_fp32_fp32_predicated_15

    smstop

    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    mov x0, 32*480

    ret


    .global _peak_sme_fmopa_4_fp32_fp32_fp32_predicated_8
    .align 4
_peak_sme_fmopa_4_fp32_fp32_fp32_predicated_8:
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

    smstart
    ptrue p0.b
    mov x10, #8
    mov x11, #16
    whilelt p1.s, x10, x11
loop_peak_sme_fmopa_4_fp32_fp32_fp32_predicated_8:
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

    cbnz x0, loop_peak_sme_fmopa_4_fp32_fp32_fp32_predicated_8

    smstop

    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    mov x0, 32*256

    ret

    .global _peak_sme_fmla_4_fp32_fp32_fp32
    .align 4
_peak_sme_fmla_4_fp32_fp32_fp32:
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

    smstart
    // zero {za}

    mov w8, #0
    mov w9, #1
    mov w10, #2
    mov w11, #3

loop_peak_sme_fmla_4_fp32_fp32_fp32:
    sub x0, x0, #1

    fmla za.s[w8, #0], {z0.s-z3.s}, z4.s
    fmla za.s[w9, #0], {z0.s-z3.s}, z4.s
    fmla za.s[w10, #0], {z0.s-z3.s}, z4.s
    fmla za.s[w11, #0], {z0.s-z3.s}, z4.s

    fmla za.s[w8, #1], {z0.s-z3.s}, z4.s
    fmla za.s[w9, #1], {z0.s-z3.s}, z4.s
    fmla za.s[w10, #1], {z0.s-z3.s}, z4.s
    fmla za.s[w11, #1], {z0.s-z3.s}, z4.s

    fmla za.s[w8, #2], {z0.s-z3.s}, z4.s
    fmla za.s[w9, #2], {z0.s-z3.s}, z4.s
    fmla za.s[w10, #2], {z0.s-z3.s}, z4.s
    fmla za.s[w11, #2], {z0.s-z3.s}, z4.s

    fmla za.s[w8, #3], {z0.s-z3.s}, z4.s
    fmla za.s[w9, #3], {z0.s-z3.s}, z4.s
    fmla za.s[w10, #3], {z0.s-z3.s}, z4.s
    fmla za.s[w11, #3], {z0.s-z3.s}, z4.s

    fmla za.s[w8, #4], {z0.s-z3.s}, z4.s
    fmla za.s[w9, #4], {z0.s-z3.s}, z4.s
    fmla za.s[w10, #4], {z0.s-z3.s}, z4.s
    fmla za.s[w11, #4], {z0.s-z3.s}, z4.s

    fmla za.s[w8, #5], {z0.s-z3.s}, z4.s
    fmla za.s[w9, #5], {z0.s-z3.s}, z4.s
    fmla za.s[w10, #5], {z0.s-z3.s}, z4.s
    fmla za.s[w11, #5], {z0.s-z3.s}, z4.s

    fmla za.s[w8, #6], {z0.s-z3.s}, z4.s
    fmla za.s[w9, #6], {z0.s-z3.s}, z4.s
    fmla za.s[w10, #6], {z0.s-z3.s}, z4.s
    fmla za.s[w11, #6], {z0.s-z3.s}, z4.s

    fmla za.s[w8, #7], {z0.s-z3.s}, z4.s
    fmla za.s[w9, #7], {z0.s-z3.s}, z4.s
    fmla za.s[w10, #7], {z0.s-z3.s}, z4.s
    fmla za.s[w11, #7], {z0.s-z3.s}, z4.s
        
    cbnz x0, loop_peak_sme_fmla_4_fp32_fp32_fp32

    smstop

    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    mov x0, 32*128

    ret

    .global _peak_sme_fmla_4_bf16_bf16_fp32
    .align 4
_peak_sme_fmla_4_bf16_bf16_fp32:
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

    smstart
    // zero {za}

    mov w8, #0
    mov w9, #1
    mov w10, #2
    mov w11, #3
    
loop_peak_sme_fmla_4_bf16_bf16_fp32:
    sub x0, x0, #1

    bfdot za.s[w8, #0],{z0.h-z3.h}, z4.h
    bfdot za.s[w9, #0],{z0.h-z3.h}, z4.h
    bfdot za.s[w10, #0],{z0.h-z3.h}, z4.h
    bfdot za.s[w11, #0],{z0.h-z3.h}, z4.h

    bfdot za.s[w8, #1],{z0.h-z3.h}, z4.h
    bfdot za.s[w9, #1],{z0.h-z3.h}, z4.h
    bfdot za.s[w10, #1],{z0.h-z3.h}, z4.h
    bfdot za.s[w11, #1],{z0.h-z3.h}, z4.h

    bfdot za.s[w8, #2],{z0.h-z3.h}, z4.h
    bfdot za.s[w9, #2],{z0.h-z3.h}, z4.h
    bfdot za.s[w10, #2],{z0.h-z3.h}, z4.h
    bfdot za.s[w11, #2],{z0.h-z3.h}, z4.h

    bfdot za.s[w8, #3],{z0.h-z3.h}, z4.h
    bfdot za.s[w9, #3],{z0.h-z3.h}, z4.h
    bfdot za.s[w10, #3],{z0.h-z3.h}, z4.h
    bfdot za.s[w11, #3],{z0.h-z3.h}, z4.h

    bfdot za.s[w8, #4],{z0.h-z3.h}, z4.h
    bfdot za.s[w9, #4],{z0.h-z3.h}, z4.h
    bfdot za.s[w10, #4],{z0.h-z3.h}, z4.h
    bfdot za.s[w11, #4],{z0.h-z3.h}, z4.h

    bfdot za.s[w8, #5],{z0.h-z3.h}, z4.h
    bfdot za.s[w9, #5],{z0.h-z3.h}, z4.h
    bfdot za.s[w10, #5],{z0.h-z3.h}, z4.h
    bfdot za.s[w11, #5],{z0.h-z3.h}, z4.h

    bfdot za.s[w8, #6],{z0.h-z3.h}, z4.h
    bfdot za.s[w9, #6],{z0.h-z3.h}, z4.h
    bfdot za.s[w10, #6],{z0.h-z3.h}, z4.h
    bfdot za.s[w11, #6],{z0.h-z3.h}, z4.h

    bfdot za.s[w8, #7],{z0.h-z3.h}, z4.h
    bfdot za.s[w9, #7],{z0.h-z3.h}, z4.h
    bfdot za.s[w10, #7],{z0.h-z3.h}, z4.h
    bfdot za.s[w11, #7],{z0.h-z3.h}, z4.h

    cbnz x0, loop_peak_sme_fmla_4_bf16_bf16_fp32

    smstop

    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    mov x0, 32*256

    ret

    .global _peak_sve_fmla_streaming_fp64_fp64_fp64
    .align 4
_peak_sve_fmla_streaming_fp64_fp64_fp64:
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
loop_peak_sve_fmla_streaming_fp64_fp64_fp64:
    sub x0, x0, #1
    fmla z0.d, p0/m, z30.d, z31.d
    fmla z1.d, p0/m, z30.d, z31.d
    fmla z2.d, p0/m, z30.d, z31.d
    fmla z3.d, p0/m, z30.d, z31.d

    fmla z4.d, p0/m, z30.d, z31.d
    fmla z5.d, p0/m, z30.d, z31.d
    fmla z6.d, p0/m, z30.d, z31.d
    fmla z7.d, p0/m, z30.d, z31.d

    fmla z8.d, p0/m, z30.d, z31.d
    fmla z9.d, p0/m, z30.d, z31.d
    fmla z10.d, p0/m, z30.d, z31.d
    fmla z11.d, p0/m, z30.d, z31.d

    fmla z12.d, p0/m, z30.d, z31.d
    fmla z13.d, p0/m, z30.d, z31.d
    fmla z14.d, p0/m, z30.d, z31.d
    fmla z15.d, p0/m, z30.d, z31.d

    fmla z16.d, p0/m, z30.d, z31.d
    fmla z17.d, p0/m, z30.d, z31.d
    fmla z18.d, p0/m, z30.d, z31.d
    fmla z19.d, p0/m, z30.d, z31.d

    fmla z20.d, p0/m, z30.d, z31.d
    fmla z21.d, p0/m, z30.d, z31.d
    fmla z22.d, p0/m, z30.d, z31.d
    fmla z23.d, p0/m, z30.d, z31.d

    fmla z24.d, p0/m, z30.d, z31.d
    fmla z25.d, p0/m, z30.d, z31.d
    fmla z26.d, p0/m, z30.d, z31.d
    fmla z27.d, p0/m, z30.d, z31.d

    fmla z28.d, p0/m, z30.d, z31.d
    fmla z29.d, p0/m, z30.d, z31.d

    cbnz x0, loop_peak_sve_fmla_streaming_fp64_fp64_fp64

    smstop
    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    mov x0, 30*16

    ret

    .global _peak_sme_fmla_4_fp64_fp64_fp64
    .align 4
_peak_sme_fmla_4_fp64_fp64_fp64:
    stp  d8,  d9, [sp, #-16]!
    stp d10, d11, [sp, #-16]!
    stp d12, d13, [sp, #-16]!
    stp d14, d15, [sp, #-16]!

    smstart
    // zero {za}

    mov w8, #0
    mov w9, #1
    mov w10, #2
    mov w11, #3

loop_peak_sme_fmla_4_fp64_fp64_fp64:
    sub x0, x0, #1

    fmla za.d[w8, #0], {z0.d-z3.d}, z4.d
    fmla za.d[w9, #0], {z0.d-z3.d}, z4.d
    fmla za.d[w10, #0], {z0.d-z3.d}, z4.d
    fmla za.d[w11, #0], {z0.d-z3.d}, z4.d

    fmla za.d[w8, #1], {z0.d-z3.d}, z4.d
    fmla za.d[w9, #1], {z0.d-z3.d}, z4.d
    fmla za.d[w10, #1], {z0.d-z3.d}, z4.d
    fmla za.d[w11, #1], {z0.d-z3.d}, z4.d

    fmla za.d[w8, #2], {z0.d-z3.d}, z4.d
    fmla za.d[w9, #2], {z0.d-z3.d}, z4.d
    fmla za.d[w10, #2], {z0.d-z3.d}, z4.d
    fmla za.d[w11, #2], {z0.d-z3.d}, z4.d

    fmla za.d[w8, #3], {z0.d-z3.d}, z4.d
    fmla za.d[w9, #3], {z0.d-z3.d}, z4.d
    fmla za.d[w10, #3], {z0.d-z3.d}, z4.d
    fmla za.d[w11, #3], {z0.d-z3.d}, z4.d

    fmla za.d[w8, #4], {z0.d-z3.d}, z4.d
    fmla za.d[w9, #4], {z0.d-z3.d}, z4.d
    fmla za.d[w10, #4], {z0.d-z3.d}, z4.d
    fmla za.d[w11, #4], {z0.d-z3.d}, z4.d

    fmla za.d[w8, #5], {z0.d-z3.d}, z4.d
    fmla za.d[w9, #5], {z0.d-z3.d}, z4.d
    fmla za.d[w10, #5], {z0.d-z3.d}, z4.d
    fmla za.d[w11, #5], {z0.d-z3.d}, z4.d

    fmla za.d[w8, #6], {z0.d-z3.d}, z4.d
    fmla za.d[w9, #6], {z0.d-z3.d}, z4.d
    fmla za.d[w10, #6], {z0.d-z3.d}, z4.d
    fmla za.d[w11, #6], {z0.d-z3.d}, z4.d

    fmla za.d[w8, #7], {z0.d-z3.d}, z4.d
    fmla za.d[w9, #7], {z0.d-z3.d}, z4.d
    fmla za.d[w10, #7], {z0.d-z3.d}, z4.d
    fmla za.d[w11, #7], {z0.d-z3.d}, z4.d
        
    cbnz x0, loop_peak_sme_fmla_4_fp64_fp64_fp64

    smstop

    ldp d14, d15, [sp], #16
    ldp d12, d13, [sp], #16
    ldp d10, d11, [sp], #16
    ldp  d8,  d9, [sp], #16

    mov x0, 32*64

    ret