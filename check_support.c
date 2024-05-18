#include <stdio.h>
#include <unistd.h>
#include "check_support.h"

extern void sve_support();
extern void sve_streaming_support();
extern void sme_support();
extern void sve_streaming_vlength( float * i_a,
                                   float * i_b );

void check_sve_support(){
  printf( "Checking for SVE support...\n" );
  sve_support();
  printf( "SVE is supported\n" );
}

void check_streaming_sve_support(){
  printf( "Checking for SVE streaming support...\n" );
  sve_streaming_support();
  printf( "  Streaming SVE is supported\n"  );
}

void check_sme_support(){
  printf( "Checking for SME support...\n" );
  sme_support();
  printf( "  SME is supported\n" );  
}

int check_sve_streaming_length(){
  printf( "Checking vector length of SVE in streaming mode \n" );
  float l_a[32];
  float l_b[32] = {0};
  for( int l_i = 0; l_i < 32; l_i++ ){
    l_a[l_i] = (float) l_i + 1;
  }
  sve_streaming_vlength( l_a, l_b );

  int l_num_bits = 0;
  for( int l_i = 0; l_i < 32; l_i++ ){
    if( l_b[l_i] > 0 ){
      l_num_bits += 32;
    }
  }
  printf( "  %d bits\n", l_num_bits );

  return l_num_bits;
}
