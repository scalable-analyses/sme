#include "benchmark.h"
#include <sys/time.h>
#include <stdint.h>
#include <stdlib.h>
#include <arm_bf16.h>
#include <arm_neon.h>
#include <pthread.h>
#include <Accelerate/Accelerate.h>
#include <stdio.h>

extern int peak_neon_fmla_fp32_fp32_fp32( int64_t i_num_reps );
extern int peak_neon_bfmmla_bf16_bf16_fp32( int64_t i_num_reps );
extern int peak_sve_fmla_streaming_fp32_fp32_fp32( int64_t i_num_reps );
extern int peak_sme_fmopa_1_fp32_fp32_fp32( int64_t i_num_reps );
extern int peak_sme_fmopa_2_fp32_fp32_fp32( int64_t i_num_reps );
extern int peak_sme_fmopa_4_fp32_fp32_fp32( int64_t i_num_reps );
extern int peak_sme_fmopa_4_fp32_fp32_fp32_predicated_15( int64_t i_num_reps);
extern int peak_sme_fmopa_4_fp32_fp32_fp32_predicated_8( int64_t i_num_reps);
extern int peak_sme_fmopa_4_reorder_fp32_fp32_fp32( int64_t i_num_reps );
extern int peak_sme_fmopa_fp64_fp64_fp64( int64_t i_num_reps );
extern int peak_sme_fmopa_smstart_smstop_8_fp32_fp32_fp32( int64_t i_num_reps );
extern int peak_sme_fmopa_smstart_smstop_16_fp32_fp32_fp32( int64_t i_num_reps );
extern int peak_sme_fmopa_smstart_smstop_32_fp32_fp32_fp32( int64_t i_num_reps );
extern int peak_sme_fmopa_smstart_smstop_64_fp32_fp32_fp32( int64_t i_num_reps );
extern int peak_sme_fmopa_smstart_smstop_128_fp32_fp32_fp32( int64_t i_num_reps );
extern int peak_sme_fmopa_fp16_fp16_fp32( int64_t i_num_reps );
extern int peak_sme_fmopa_fp16_fp16_fp16( int64_t i_num_reps );
extern int peak_sme_bfmopa_bf16_bf16_fp32( int64_t i_num_reps );
extern int peak_sme_bfmopa_bf16_bf16_bf16( int64_t i_num_reps );
extern int peak_sme_smopa_i8_i8_i32( int64_t i_num_reps );
extern int peak_sme_smopa_i16_i16_i32( int64_t i_num_reps );
extern int peak_amx_fma_fp32_fp32_fp32( int64_t i_num_reps );
extern void copy_ldr_z( int64_t          i_num_reps,
                        int64_t          i_num_vals,
                        float    const * i_a,
                        float          * o_b );
extern void copy_ld1w_z_1( int64_t          i_num_reps,
                           int64_t          i_num_vals,
                           float    const * i_a,
                           float          * o_b );
extern void copy_ld1w_z_2( int64_t          i_num_reps,
                           int64_t          i_num_vals,
                           float    const * i_a,
                           float          * o_b );
extern void copy_ld1w_z_4( int64_t          i_num_reps,
                           int64_t          i_num_vals,
                           float    const * i_a,
                           float          * o_b );
extern void copy_ld1w_z_strided_2( int64_t          i_num_reps,
                                   int64_t          i_num_vals,
                                   float    const * i_a,
                                   float          * o_b );
extern void copy_ld1w_z_strided_4( int64_t          i_num_reps,
                                   int64_t          i_num_vals,
                                   float    const * i_a,
                                   float          * o_b );
extern void copy_ldr_za( int64_t          i_num_reps,
                         int64_t          i_num_vals,
                         float    const * i_a,
                         float          * o_b );

void bench_micro( int        i_num_threads,
                  int        i_qos_class,
                  int64_t    i_num_reps,
                  int     (* i_kernel)( int64_t ) ) {
  dispatch_qos_class_t l_qos_class = QOS_CLASS_DEFAULT;

  if( i_qos_class == 1 ) {
    l_qos_class = QOS_CLASS_USER_INTERACTIVE;
  }
  else if( i_qos_class == 2 ) {
    l_qos_class = QOS_CLASS_USER_INITIATED;
  }
  else if( i_qos_class == 3 ) {
    l_qos_class = QOS_CLASS_UTILITY;
  }
  else if( i_qos_class == 4 ) {
    l_qos_class = QOS_CLASS_BACKGROUND;
  }

  // set up dispatch
  dispatch_queue_attr_t l_attr = dispatch_queue_attr_make_with_qos_class( DISPATCH_QUEUE_CONCURRENT,
                                                                          l_qos_class,
                                                                          0 );

  dispatch_queue_t l_queue = dispatch_queue_create( "bench_queue",
                                                    l_attr );
  
  dispatch_group_t l_group = dispatch_group_create();

  // benchmarking vars
  double l_gops = 0;
  struct timeval l_start;
  struct timeval l_end;
  long l_seconds = 0;
  long l_useconds = 0;
  double l_total_time = 0;

  // run benchmark
  gettimeofday( &l_start, NULL );
  for( int l_td = 0; l_td < i_num_threads; l_td++ ) {
    dispatch_group_async( l_group,
                          l_queue,
                          ^{ i_kernel( i_num_reps ); } );
  }
  dispatch_group_wait( l_group,
                       DISPATCH_TIME_FOREVER );
  gettimeofday( &l_end, NULL );
  l_seconds  = l_end.tv_sec  - l_start.tv_sec;
  l_useconds = l_end.tv_usec - l_start.tv_usec;
  l_total_time = l_seconds + l_useconds/1000000.0;

  // determine GOPS
  l_gops = i_kernel( 1 );
  l_gops *= i_num_threads;
  l_gops *= i_num_reps;
  l_gops *= 1.0E-9;
  l_gops /= l_total_time;

  printf( "  Repetitions:  %" PRId64 "\n", i_num_reps );
  printf( "  Total time:  %f\n", l_total_time );
  printf( "  GOPS: %f\n", l_gops );
}

void bench_copy( int64_t    i_num_vals,
                 int64_t    i_offset_bytes,
                 int64_t    i_num_reps,
                 void    (* i_kernel)( int64_t,
                                       int64_t,
                                       float const *,
                                       float       * ) ) {
  struct timeval l_start;
  struct timeval l_end;
  long l_seconds = 0;
  long l_useconds = 0;
  double total_time = 0;

  printf( "Running copy benchmark...\n" );

  // allocate memory
  float * l_a = 0;
  float * l_b = 0;

  posix_memalign( (void**) &l_a, 128, i_num_vals * sizeof(float) + 127 );
  posix_memalign( (void**) &l_b, 128, i_num_vals * sizeof(float) + 127 );

  l_a = (float*) ( (char *) l_a + i_offset_bytes );
  l_b = (float*) ( (char *) l_b + i_offset_bytes );

  // init data
  for( int64_t l_en = 0; l_en < i_num_vals; l_en++ ) {
    l_a[l_en] = 7743;
    l_b[l_en] = 0;
  }

  // run copy benchmark
  gettimeofday( &l_start, NULL );
  i_kernel( i_num_reps,
            i_num_vals,
            l_a,
            l_b );
  gettimeofday( &l_end, NULL );

  // check results
  for( int64_t l_en = 0; l_en < i_num_vals; l_en++ ) {
    if( l_b[l_en] != 7743 ){
      printf( "  Error at position %" PRId64 ": %f\n", l_en, l_b[l_en] );
      break;
    }
  }

  // print results
  l_seconds  = l_end.tv_sec  - l_start.tv_sec;
  l_useconds = l_end.tv_usec - l_start.tv_usec;
  total_time = l_seconds + l_useconds/1000000.0;

  double l_num_bytes = 2 * i_num_reps * i_num_vals * 4;
  double l_gibs = l_num_bytes / (1024.0*1024.0*1024.0);
         l_gibs /= total_time;
  
  double l_mib_per_iter = i_num_vals * 4 / (1024.0*1024.0);

  printf( "  #Values:       %" PRId64 "\n", i_num_vals );
  printf( "  Offset:        %" PRId64 "\n", i_offset_bytes );
  printf( "  Repetitions:   %" PRId64 "\n", i_num_reps );
  printf( "  MiB per iter:  %f\n", l_mib_per_iter );
  printf( "  Total time:    %f\n", total_time );
  printf( "  GiB/s:         %f\n", l_gibs );
  printf( "  CSV_DATA: %" PRId64 ",%" PRId64 ",%" PRId64 ",%f,%f,%f\n",
             i_num_vals, i_offset_bytes, i_num_reps, l_mib_per_iter, total_time, l_gibs );

  // free memory
  l_a = (float*) ( (char *) l_a - i_offset_bytes );
  l_b = (float*) ( (char *) l_b - i_offset_bytes );
  free( l_a );
  free( l_b );
}

void bench_cblas( int64_t i_m,
                  int64_t i_n,
                  int64_t i_k,
                  int64_t i_lda,
                  int64_t i_ldb,
                  int64_t i_ldc,
                  int     i_trans_a,
                  int     i_trans_b,
                  int64_t i_num_reps_initial,
                  double  i_target_time ) {
  printf( "Running CBLAS SGEMM...\n" );
  printf( "  M/N/K:         %" PRId64 "/%" PRId64 "/%" PRId64 "\n", i_m, i_n, i_k );
  printf( "  ldA/ldB/ldC:   %" PRId64 "/%" PRId64 "/%" PRId64 "\n", i_lda, i_ldb, i_ldc );
  printf( "  TransA/TransB: %d/%d\n", i_trans_a, i_trans_b );

  // vars
  int64_t l_num_reps = 0;
  int64_t l_num_flops = 0;
  double l_gflops = 0;
  struct timeval l_start;
  struct timeval l_end;
  long l_seconds = 0;
  long l_useconds = 0;
  double l_total_time = 0;

  // allocate memory
  float * l_a = NULL;
  float * l_b = NULL;
  float * l_c = NULL;

  posix_memalign( (void**) &l_a, 128, i_lda * i_k * sizeof(float) );
  posix_memalign( (void**) &l_b, 128, i_ldb * i_n * sizeof(float) );
  posix_memalign( (void**) &l_c, 128, i_ldc * i_n * sizeof(float) );

  // init the matrices
  for( int64_t l_en = 0; l_en < i_lda * i_k; l_en++ ) {
    l_a[l_en] = 1.0f;
  }

  for( int64_t l_en = 0; l_en < i_ldb * i_n; l_en++ ) {
    l_b[l_en] = 1.0f;
  }

  for( int64_t l_en = 0; l_en < i_ldc * i_n; l_en++ ) {
    l_c[l_en] = 1.0f;
  }

  // warmup
  cblas_sgemm( CblasColMajor,
               i_trans_a == 0 ? CblasNoTrans : CblasTrans,
               i_trans_b == 0 ? CblasNoTrans : CblasTrans,
               i_m,
               i_n,
               i_k,
               1,
               l_a,
               i_lda,
               l_b,
               i_ldb,
               1,
               l_c,
               i_ldc );

  gettimeofday( &l_start, NULL );
  for( int64_t l_re = 0; l_re < i_num_reps_initial; l_re++) {
    cblas_sgemm( CblasColMajor,
                 i_trans_a == 0 ? CblasNoTrans : CblasTrans,
                 i_trans_b == 0 ? CblasNoTrans : CblasTrans,
                 i_m,
                 i_n,
                 i_k,
                 1,
                 l_a,
                 i_lda,
                 l_b,
                 i_ldb,
                 1,
                 l_c,
                 i_ldc );
  }
  gettimeofday( &l_end, NULL );

  l_seconds    = l_end.tv_sec  - l_start.tv_sec;
  l_useconds   = l_end.tv_usec - l_start.tv_usec;
  l_total_time = l_seconds + l_useconds/1000000.0;

  l_num_reps = (i_target_time * i_num_reps_initial) / l_total_time;
  l_num_reps = l_num_reps > 1 ? l_num_reps : 1;
  l_num_flops = 2 * i_m * i_n * i_k * l_num_reps;

  gettimeofday( &l_start, NULL );
  for( int64_t l_re = 0; l_re < l_num_reps; l_re++ ) {
    cblas_sgemm( CblasColMajor,
                 i_trans_a == 0 ? CblasNoTrans : CblasTrans,
                 i_trans_b == 0 ? CblasNoTrans : CblasTrans,
                 i_m,
                 i_n,
                 i_k,
                 1,
                 l_a,
                 i_lda,
                 l_b,
                 i_ldb,
                 1,
                 l_c,
                 i_ldc );
  }
  gettimeofday( &l_end, NULL );

  l_seconds    = l_end.tv_sec  - l_start.tv_sec;
  l_useconds   = l_end.tv_usec - l_start.tv_usec;
  l_total_time = l_seconds + l_useconds/1000000.0;
  l_gflops = l_num_flops / l_total_time;
  l_gflops *= 1.0E-9;

  printf( "  Repetitions:   %" PRId64 "\n", l_num_reps );
  printf( "  Total time:    %f\n", l_total_time );
  printf( "  GFLOPS:        %f\n", l_gflops );

  free( l_a );
  free( l_b );
  free( l_c );
}

void run_micro_benchmark( int i_num_threads,
                          int i_qos_class ) {
  printf( "Running benchmarks...\n" );
  printf( "  Threads: %d\n", i_num_threads );
  if( i_qos_class == 1 ) {
    printf( "  QoS: User Interactive\n" );
  }
  else if( i_qos_class == 2 ) {
    printf( "  QoS: User Initiated\n" );
  }
  else if( i_qos_class == 3 ) {
    printf( "  QoS: Utility\n" );
  }
  else if( i_qos_class == 4 ) {
    printf( "  QoS: Background\n" );
  }
  else {
    printf( "  QoS: Default\n" );
  }

  printf( "Determining FP32 Neon FMLA performance...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 1000000000 : 200000000,
               peak_neon_fmla_fp32_fp32_fp32 );

  printf( "Determining BF16-BF16-FP32 BFMMLA Neon performance...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 1000000000 : 200000000,
               peak_neon_bfmmla_bf16_bf16_fp32 );

  printf( "Determining FP32 SSVE FMLA performance...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 100000000 : 20000000,
               peak_sve_fmla_streaming_fp32_fp32_fp32 );

  printf( "Determining FP32 AMX performance...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 100000000 : 20000000,
               peak_amx_fma_fp32_fp32_fp32 );

  printf( "Determining FP32 SME FMOPA performance (1 tile)...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 250000000 : 50000000,
               peak_sme_fmopa_1_fp32_fp32_fp32 );

  printf( "Determining FP32 SME FMOPA performance (2 tiles)...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 250000000 : 50000000,
               peak_sme_fmopa_2_fp32_fp32_fp32 );

  printf( "Determining FP32 SME FMOPA performance (4 tiles)...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 250000000 : 50000000,
               peak_sme_fmopa_4_fp32_fp32_fp32 );

  printf( "Determining FP32 SME predicated (8/16) FMOPA performance (4 tiles) ...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 250000000 : 50000000,
               peak_sme_fmopa_4_fp32_fp32_fp32_predicated_8 );

  printf( "Determining FP32 SME predicated (15/16) FMOPA performance (4 tiles) ...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 250000000 : 50000000,
               peak_sme_fmopa_4_fp32_fp32_fp32_predicated_15 );

  printf( "Determining FP32 SME FMOPA performance (4 tiles, reordering)...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 250000000 : 50000000,
               peak_sme_fmopa_4_reorder_fp32_fp32_fp32 );

  printf( "Determining FP32 SME SMSTART-SMSTOP performance (8 instructions per block)...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 250000000 : 50000000,
               peak_sme_fmopa_smstart_smstop_8_fp32_fp32_fp32 );

  printf( "Determining FP32 SME SMSTART-SMSTOP performance (16 instructions per block)...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 250000000 : 50000000,
               peak_sme_fmopa_smstart_smstop_16_fp32_fp32_fp32 );

  printf( "Determining FP32 SME SMSTART-SMSTOP performance (32 instructions per block)...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 250000000 : 50000000,
               peak_sme_fmopa_smstart_smstop_32_fp32_fp32_fp32 );

  printf( "Determining FP32 SME SMSTART-SMSTOP performance (64 instructions per block)...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 250000000 : 50000000,
               peak_sme_fmopa_smstart_smstop_64_fp32_fp32_fp32 );

  printf( "Determining FP32 SME SMSTART-SMSTOP performance (128 instructions per block)...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 250000000 : 50000000,
               peak_sme_fmopa_smstart_smstop_128_fp32_fp32_fp32 );

  printf( "Determining FP16-FP16-FP32 SME FMOPA performance...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 250000000 : 50000000,
               peak_sme_fmopa_fp16_fp16_fp32 );

  printf( "Determining BF16-BF16-FP32 SME BFMOPA performance...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 250000000 : 50000000,
               peak_sme_bfmopa_bf16_bf16_fp32 );

  printf( "Determining FP64 SME FMOPA performance ...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 250000000 : 50000000,
               peak_sme_fmopa_fp64_fp64_fp64 );

  printf( "Determining I8-I8-I32 SME FMOPA performance...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 250000000 : 50000000,
               peak_sme_smopa_i8_i8_i32 );

  printf( "Determining I16-I16-I32 SME FMOPA performance...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 250000000 : 50000000,
               peak_sme_smopa_i16_i16_i32 );
}

/*
 * Run CBLAS benchmarks
 */
void run_cblas_benchmark(){
  printf( "Running CBLAS benchmarks...\n" );
  int64_t l_size = 16;
  int64_t l_num_reps_initial = 65536;
  double  l_target_time = 1.0;
  for( int64_t l_si = 0; l_si < 10; l_si++ ) {
    bench_cblas( l_size,
                 l_size,
                 l_size,
                 l_size,
                 l_size,
                 l_size,
                 0,
                 0,
                 l_num_reps_initial,
                 l_target_time );

    bench_cblas( l_size,
                 l_size,
                 l_size,
                 l_size,
                 l_size,
                 l_size,
                 0,
                 1,
                 l_num_reps_initial,
                 l_target_time );

    l_size *= 2;
    l_num_reps_initial /= 8;
    l_num_reps_initial = l_num_reps_initial > 1 ? l_num_reps_initial : 1;
  }
}

/*
 * Run copy benchmarks
 */
void run_copy_benchmark( int i_kernel_type,
                         int i_align_bytes,
                         int i_qos_class ){
  printf( "Running copy benchmarks...\n" );
  printf( "  Kernel type: %d\n", i_kernel_type );
  printf( "  Align bytes: %d\n", i_align_bytes );
  printf( "  QoS class: %d\n",    i_qos_class    );

  qos_class_t l_qos_class = QOS_CLASS_DEFAULT;

  if( i_qos_class == 1 ) {
    l_qos_class = QOS_CLASS_USER_INTERACTIVE;
  }
  else if( i_qos_class == 2 ) {
    l_qos_class = QOS_CLASS_USER_INITIATED;
  }
  else if( i_qos_class == 3 ) {
    l_qos_class = QOS_CLASS_UTILITY;
  }
  else if( i_qos_class == 4 ) {
    l_qos_class = QOS_CLASS_BACKGROUND;
  }
  pthread_set_qos_class_self_np( l_qos_class, 0 );

  void (* l_kernel)( int64_t,
                     int64_t,
                     float const *,
                     float       * ) = 0;

  if( i_kernel_type == 0 ) {
    l_kernel = copy_ldr_z;
  }
  else if( i_kernel_type == 1 ) {
    l_kernel = copy_ld1w_z_1;
  }
  else if( i_kernel_type == 2 ) {
    l_kernel = copy_ld1w_z_2;
  }
  else if( i_kernel_type == 3 ) {
    l_kernel = copy_ld1w_z_4;
  }
  else if( i_kernel_type == 4 ) {
    l_kernel = copy_ld1w_z_strided_2;
  }
  else if( i_kernel_type == 5 ) {
    l_kernel = copy_ld1w_z_strided_4;
  }
  else if( i_kernel_type == 6 ) {
    l_kernel = copy_ldr_za;
  }
  else{
    printf( "Unknown kernel type: %d\n", i_kernel_type );
    return;
  }

  int64_t l_off = i_align_bytes % 128;

  int64_t l_num_values = 256;
  int64_t l_num_reps = 1717469184;

  for( int64_t l_si = 0; l_si < 22; l_si++ ) {
    bench_copy( l_num_values,
                l_off,
                l_num_reps,
                l_kernel );

    l_num_values *= 2;
    l_num_reps   /= 2;
  }
}