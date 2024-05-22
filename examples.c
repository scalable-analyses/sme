#include <stdio.h>
#include <unistd.h>
#include <stdint.h>
#include <arm_bf16.h>
#include <arm_neon.h>
#include <sys/time.h>
#include "examples.h"

extern void example_sme_fmopa_fp32_fp32_fp32( float * i_a,
                                              float * i_b,
                                              float * i_c );
extern void example_sme_bfmopa_bf16_bf16_fp32( bfloat16_t * i_a,
                                               bfloat16_t * i_b,
                                               float      * i_c );
extern void example_zip4_fp32( float * i_a,
                               float * o_b );
extern void example_trans16x16_fp32( float * i_a,
                                     float * o_b );

void showcase_fmopa_fp32_fp32_fp32() {
    printf( "Running example FP32 SME FMOPA...\n" );
    float l_a_sme_fmopa[32];
    float l_b_sme_fmopa[32];
    float l_c_sme_fmopa[32*32] = {0};

    for( int64_t l_i = 0; l_i < 32; l_i++ ){
      l_a_sme_fmopa[l_i] = l_i + 1;
      l_b_sme_fmopa[l_i] = l_i + 1;
    }

    example_sme_fmopa_fp32_fp32_fp32( l_a_sme_fmopa,
                       l_b_sme_fmopa,
                       l_c_sme_fmopa );

    for( int64_t l_i = 0; l_i < 32; l_i++ ){
      for( int64_t l_j = 0; l_j < 16; l_j++ ){
        printf( "  %f", l_c_sme_fmopa[l_i*16+l_j] );
      }
      printf( "\n" );
    }
}

void showcase_bfmopa_bf16_bf16_fp32() {
    printf( "Running example BF16-BF16-FP32 SME BFMOPA...\n" );
    bfloat16_t l_a_bf16[16*2];
    bfloat16_t l_b_bf16[16*2];
    float      l_c_fp32[16*16] = {0};

    for( int64_t l_i = 0; l_i < 16*2; l_i++ ){
      float l_val = (float) l_i + 1;
      l_a_bf16[l_i] = vcvth_bf16_f32( l_val );
      l_b_bf16[l_i] = vcvth_bf16_f32( l_val );
    }

    example_sme_bfmopa_bf16_bf16_fp32( l_a_bf16,
                                       l_b_bf16,
                                       l_c_fp32 );

    for( int64_t l_i = 0; l_i < 16; l_i++ ){
      for( int64_t l_j = 0; l_j < 16; l_j++ ){
        printf( "  %f", l_c_fp32[l_i*16+l_j] );
      }
      printf( "\n" );
    }
}

void showcase_zip4_fp32() {
    printf( "Running FP32 example ZIP 4...\n" );
    float l_a[4*16];
    float l_b[4*16] = {0};

    for( int64_t l_en = 0; l_en < 4*16; l_en++ ) {
      l_a[l_en] = l_en + 1;
    }

    printf(  "  input:\n");
    for( int64_t l_i = 0; l_i < 4; l_i++ ){
      for( int64_t l_j = 0; l_j < 16; l_j++ ){
        printf( "  %f", l_a[l_i*16+l_j] );
      }
      printf( "\n" );
    }

    example_zip4_fp32( l_a, l_b );

    printf(  "  output:\n");
    for( int64_t l_i = 0; l_i < 4; l_i++ ){
      for( int64_t l_j = 0; l_j < 16; l_j++ ){
        printf( "  %f", l_b[l_i*16+l_j] );
      }
      printf( "\n" );
    }
}