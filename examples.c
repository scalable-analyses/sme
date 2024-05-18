#include <stdio.h>
#include <unistd.h>
#include <stdint.h>
#include <arm_bf16.h>
#include <arm_neon.h>
#include <sys/time.h>
#include "examples.h"

extern void example_sme_fmopa( float * i_a,
                               float * i_b,
                               float * i_c );
extern void example_sme_bfmopa_widening( bfloat16_t * i_a,
                                         bfloat16_t * i_b,
                                         float      * i_c );
extern void example_sme_fmopa_64_16_6( float * i_a,
                                       float * i_b,
                                       float * io_c);

void showcase_fmopa() {
    printf( "Running example SME FMOPA...\n" );
    float l_a_sme_fmopa[32];
    float l_b_sme_fmopa[32];
    float l_c_sme_fmopa[32*32] = {0};

    for( int64_t l_i = 0; l_i < 32; l_i++ ){
      l_a_sme_fmopa[l_i] = l_i + 1;
      l_b_sme_fmopa[l_i] = l_i + 1;
    }

    example_sme_fmopa( l_a_sme_fmopa,
                       l_b_sme_fmopa,
                       l_c_sme_fmopa );

    for( int64_t l_i = 0; l_i < 32; l_i++ ){
      for( int64_t l_j = 0; l_j < 16; l_j++ ){
        printf( "  %f", l_c_sme_fmopa[l_i*16+l_j] );
      }
      printf( "\n" );
    }
}

void showcase_bfmopa_widening() {
    printf( "Running example SME BFMOPA(widening)...\n" );
    bfloat16_t l_a_bf16[16*2];
    bfloat16_t l_b_bf16[16*2];
    float      l_c_fp32[16*16] = {0};

    for( int64_t l_i = 0; l_i < 16*2; l_i++ ){
      float l_val = (float) l_i + 1;
      l_a_bf16[l_i] = vcvth_bf16_f32( l_val );
      l_b_bf16[l_i] = vcvth_bf16_f32( l_val );
    }

    example_sme_bfmopa_widening( l_a_bf16,
                                 l_b_bf16,
                                 l_c_fp32 );

    for( int64_t l_i = 0; l_i < 16; l_i++ ){
      for( int64_t l_j = 0; l_j < 16; l_j++ ){
        printf( "  %f", l_c_fp32[l_i*16+l_j] );
      }
      printf( "\n" );
    }
}