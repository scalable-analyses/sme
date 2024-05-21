#include "benchmark.h"
#include <sys/time.h>
#include <stdint.h>
#include <stdlib.h>
#include <arm_bf16.h>
#include <arm_neon.h>
#include <pthread.h>
#include <Accelerate/Accelerate.h>
#include <stdio.h>

extern int peak_neon_fmla( int64_t reps );
extern int peak_sve_fmla_streaming( int64_t reps );
extern int peak_sme_fmopa_1( int64_t reps );
extern int peak_sme_fmopa_2( int64_t reps );
extern int peak_sme_fmopa_4( int64_t reps );
extern int peak_sme_fmopa_4_reorder( int64_t reps );
extern int peak_sme_fmopa_fp64( int64_t reps );
extern int peak_sme_fmopa_smstart_smstop_8( int64_t reps );
extern int peak_sme_fmopa_smstart_smstop_16( int64_t reps );
extern int peak_sme_fmopa_smstart_smstop_32( int64_t reps );
extern int peak_sme_fmopa_smstart_smstop_64( int64_t reps );
extern int peak_sme_fmopa_smstart_smstop_128( int64_t reps );
extern int peak_sme_fmopa_widening( int64_t reps );
extern int peak_sme_fmopa_non_widening( int64_t reps );
extern int peak_sme_bfmopa_widening( int64_t reps );
extern int peak_sme_bfmopa_non_widening( int64_t reps );
extern int peak_amx_fma( int64_t reps );
extern void triad_neon( uint64_t        i_nRepetitions,
                        uint64_t        i_nValues,
                        float    const * i_a,
                        float    const * i_b,
                        float          * o_c );
                

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
  double l_gflops = 0;
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

  // determine GFLOPS
  l_gflops = i_kernel( 1 );
  l_gflops *= i_num_threads;
  l_gflops *= i_num_reps;
  l_gflops *= 1.0E-9;
  l_gflops /= l_total_time;

  printf( "  Repetitions:  %" PRId64 "\n", i_num_reps );
  printf( "  Total time:  %f\n", l_total_time );
  printf( "  GFLOPS: %f\n", l_gflops );
}

void bench_triad( int64_t i_num_values,
                  int64_t i_num_reps ) {
  struct timeval l_start;
  struct timeval l_end;
  long l_seconds = 0;
  long l_useconds = 0;
  double total_time = 0;

  printf( "Running triad with Neon...\n" );

  // allocate memory
  float * l_a = 0;
  float * l_b = 0;
  float * l_c = 0;

  posix_memalign( (void**) &l_a, 128, i_num_values * sizeof(float) );
  posix_memalign( (void**) &l_b, 128, i_num_values * sizeof(float) );
  posix_memalign( (void**) &l_c, 128, i_num_values * sizeof(float) );

  // init data
  for( int64_t l_en = 0; l_en < i_num_values; l_en++ ) {
    l_a[l_en] = 1;
    l_b[l_en] = 2;
    l_c[l_en] = 3;
  }

  gettimeofday( &l_start, NULL );
  triad_neon( i_num_reps,
              i_num_values,
              l_a,
              l_b,
              l_c );
  gettimeofday( &l_end, NULL );

  for( int64_t l_en = 0; l_en < i_num_values; l_en++ ) {
    if( l_c[l_en] != 5 ){
      printf( "  Error at position %" PRId64 ": %f\n", l_en, l_c[l_en] );
      return;
    }
  }

  l_seconds  = l_end.tv_sec  - l_start.tv_sec;
  l_useconds = l_end.tv_usec - l_start.tv_usec;
  total_time = l_seconds + l_useconds/1000000.0;

  double l_num_bytes = 3 * i_num_reps * i_num_values * 4;
  double l_gibs = l_num_bytes / (1024.0*1024.0*1024.0);
         l_gibs /= total_time;
  
  double l_mib_per_array = i_num_values * 4 / (1024.0*1024.0);

  printf( "  Repetitions:   %" PRId64 "\n", i_num_reps );
  printf( "  #Values:       %" PRId64 "\n", i_num_values );
  printf( "  MiB per array: %f\n", l_mib_per_array );
  printf( "  Total time:    %f\n", total_time );
  printf( "  GiB/s:         %f\n", l_gibs );

  free( l_a );
  free( l_b );
  free( l_c );
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

  printf( "Determining FP32 Neon performance...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               1000000000,
               peak_neon_fmla );

  printf( "Determining FP32 SSVE performance...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               100000000,
               peak_sve_fmla_streaming );

  printf( "Determining FP32 AMX performance...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               100000000,
               peak_amx_fma );

  printf( "Determining FP32 SME FMOPA performance (1 tile)...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               250000000,
               peak_sme_fmopa_1 );

  printf( "Determining FP32 SME FMOPA performance (2 tiles)...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               250000000,
               peak_sme_fmopa_2 );

  printf( "Determining FP32 SME FMOPA performance (4 tiles)...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               250000000,
               peak_sme_fmopa_4 );

  printf( "Determining FP32 SME FMOPA performance (4 tiles, reordering)...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               250000000,
               peak_sme_fmopa_4_reorder );

  printf( "Determining FP32 SME SMSTART-SMSTOP performance (8 instructions per block)...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               250000000,
               peak_sme_fmopa_smstart_smstop_8 );

  printf( "Determining FP32 SME SMSTART-SMSTOP performance (16 instructions per block)...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               250000000,
               peak_sme_fmopa_smstart_smstop_16 );

  printf( "Determining FP32 SME SMSTART-SMSTOP performance (32 instructions per block)...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               250000000,
               peak_sme_fmopa_smstart_smstop_32 );

  printf( "Determining FP32 SME SMSTART-SMSTOP performance (64 instructions per block)...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               250000000,
               peak_sme_fmopa_smstart_smstop_64 );

  printf( "Determining FP32 SME SMSTART-SMSTOP performance (128 instructions per block)...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               250000000,
               peak_sme_fmopa_smstart_smstop_128 );

  printf( "Determining FP32 SME FMOPA performance (widening)...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               250000000,
               peak_sme_fmopa_widening );

  printf( "Determining F16 SME FMOPA performance (non-widening)...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               250000000,
               peak_sme_fmopa_non_widening );

  printf( "Determining FP32 SME BFMOPA performance (widening)...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               250000000,
               peak_sme_bfmopa_widening );
  
  printf( "Determining BF16 SME BFMOPA performance (non-widening)...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               250000000,
               peak_sme_bfmopa_non_widening );

  printf( "Determining FP64 SME FMOPA performance ...\n" );
  bench_micro( i_num_threads,
               i_qos_class,
               250000000,
               peak_sme_fmopa_fp64 );
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
 * Run bandwidth benchmarks
 */
void run_bandwidth_benchmark(){
  int64_t l_triad_num_values = 48;
  int64_t l_triad_num_reps = 2147483648;

  for( int64_t l_i = 0; l_i < 24; l_i++ ) {
    bench_triad( l_triad_num_values,
                 l_triad_num_reps );

    l_triad_num_values *= 2;
    l_triad_num_reps   /= 2;
  }
}