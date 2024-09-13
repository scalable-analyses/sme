#ifndef gemm_h
#define gemm_h

#include <stdio.h>
int hello_libxsmm( int input_m, int input_n, int input_k, int i_lda, int i_ldb, int i_ldc );
float gemm_normal(int input_m, int input_n, int input_k, int i_lda, int i_ldb, int i_ldc, int i_reps);
float gemm_b_transpose(int input_m, int input_n, int input_k, int i_lda, int i_ldb, int i_ldc, int i_reps);
#endif /* gemm_h */
