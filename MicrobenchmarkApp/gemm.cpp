#include "gemm.h"
#include "kernels_gemm.h"
#include <iostream>
#include <random>
#include <chrono>
#include <cstdint>
#include <Accelerate/Accelerate.h>

void rep_accelerate( int64_t         i_num_reps,
                     int64_t         i_m,
                     int64_t         i_n,
                     int64_t         i_k,
                     float   const * i_a,
                     float   const * i_bt,
                     float         * io_c,
                     CBLAS_TRANSPOSE i_b_trans ) {
  for( int64_t l_re = 0; l_re < i_num_reps; l_re++ ) {
    cblas_sgemm( CblasColMajor,
                 CblasNoTrans,
                 i_b_trans,
                 i_m,
                 i_n,
                 i_k,
                 1,
                 i_a,
                 i_m,
                 i_bt,
                 i_n,
                 1,
                 io_c,
                 i_m );
  }
}

void rep_kernel( int64_t    i_num_reps,
                 int64_t    i_m,
                 int64_t    i_n,
                 int64_t    i_k,
                 void    (* i_kernel)( float const *,
                                       float const *,
                                       float       * ),
                 float    * i_a,
                 float    * i_bt,
                 float    * io_c ) {
  for( int64_t l_re = 0; l_re < i_num_reps; l_re++ ) {
    i_kernel( i_a,
              i_bt,
              io_c );
  }
}

void bench_gemm( int        i_num_threads,
                 int        i_qos_class,
                 int64_t    i_num_reps,
                 int64_t    i_m,
                 int64_t    i_n,
                 int64_t    i_k,
                 void    (* i_kernel)( float const *,
                                       float const *,
                                       float       * ) ) {
  CBLAS_TRANSPOSE l_b_trans = CblasTrans;
  if( i_kernel == gemm_micro_32_no_trans ){
    std::cout << "Running C+=AB benchmark" << std::endl;
    l_b_trans = CblasNoTrans;
  } else {
    std::cout << "Running C+=AB^T benchmark" << std::endl;
  }
  std::cout << "  num_threads: " << i_num_threads << std::endl;

  // set up parallelization
  dispatch_qos_class_t l_qos_class = QOS_CLASS_DEFAULT;

  if( i_qos_class == 1 ) {
    l_qos_class = QOS_CLASS_USER_INTERACTIVE;
    std::cout << "  QoS: User Interactive" << std::endl;
  }
  else if( i_qos_class == 2 ) {
    l_qos_class = QOS_CLASS_USER_INITIATED;
    std::cout << "  QoS: User Initiated" << std::endl;
  }
  else if( i_qos_class == 3 ) {
    l_qos_class = QOS_CLASS_UTILITY;
    std::cout << "  QoS: Utility" << std::endl;
  }
  else if( i_qos_class == 4 ) {
    l_qos_class = QOS_CLASS_BACKGROUND;
    std::cout << "  QoS: Background" << std::endl;
  }
  else {
    std::cout << "  QoS: Default" << std::endl;
  }
  std::cout << "  num_reps: "    << i_num_reps << std::endl;
  std::cout << "  M: "           << i_m << std::endl;
  std::cout << "  N: "           << i_n << std::endl;
  std::cout << "  K: "           << i_k << std::endl;


  // set up dispatch
  dispatch_queue_attr_t l_attr = dispatch_queue_attr_make_with_qos_class( DISPATCH_QUEUE_CONCURRENT,
                                                                          l_qos_class,
                                                                          0 );

  dispatch_queue_t l_queue = dispatch_queue_create( "bench_queue",
                                                    l_attr );

  dispatch_group_t l_group = dispatch_group_create();

  // allocate memory for the matrices
  float ** l_a     = new float*[i_num_threads];
  float ** l_bt    = new float*[i_num_threads];
  float ** l_c     = new float*[i_num_threads];
  float ** l_c_ref = new float*[i_num_threads];

  for( int l_td = 0; l_td < i_num_threads; l_td++ ) {
    posix_memalign( (void**)&l_a[l_td],     128, i_m * i_k * sizeof(float) );
    posix_memalign( (void**)&l_bt[l_td],    128, i_k * i_n * sizeof(float) );
    posix_memalign( (void**)&l_c[l_td],     128, i_m * i_n * sizeof(float) );
    posix_memalign( (void**)&l_c_ref[l_td], 128, i_m * i_n * sizeof(float) );
  }

  // init the matrices using a normal distribution with mean 0 and variance 1
  std::random_device l_rd;
  std::mt19937 l_gen( l_rd() );
  std::normal_distribution<float> l_dist( 0.0,
                                          1.0 );

  for( int l_td = 0; l_td < i_num_threads; l_td++ ) {
    for( int64_t l_en = 0; l_en < i_m * i_k; l_en++ ) {
      l_a[l_td][l_en] = l_dist( l_gen );
    }
    for( int64_t l_en = 0; l_en < i_k * i_n; l_en++ ) {
      l_bt[l_td][l_en] = l_dist( l_gen );
    }
    for( int64_t l_en = 0; l_en < i_m * i_n; l_en++ ) {
      l_c[l_td][l_en] = l_dist( l_gen );
      l_c_ref[l_td][l_en] = l_c[l_td][l_en];
    }
  }

  // compute reference
  for( int l_td = 0; l_td < i_num_threads; l_td++ ) {
    dispatch_group_async( l_group,
                          l_queue,
                          ^{
                            rep_accelerate( 1,
                                            i_m,
                                            i_n,
                                            i_k,
                                            l_a[l_td],
                                            l_bt[l_td],
                                            l_c_ref[l_td],
                                            l_b_trans );
                          } );
  }
  dispatch_group_wait( l_group,
                       DISPATCH_TIME_FOREVER );

  // compute kernel results
  for( int l_td = 0; l_td < i_num_threads; l_td++ ) {
    dispatch_group_async( l_group,
                          l_queue,
                          ^{
                            rep_kernel( 1,
                                        i_m,
                                        i_n,
                                        i_k,
                                        i_kernel,
                                        l_a[l_td],
                                        l_bt[l_td],
                                        l_c[l_td] );
                          } );
  }
  dispatch_group_wait( l_group,
                       DISPATCH_TIME_FOREVER );

  // compute maximum absolute and relative error
  double l_max_abs_error = 0;
  double l_max_rel_error = 0;

  for( int l_td = 0; l_td < i_num_threads; l_td++ ) {
    for( int64_t l_en = 0; l_en < i_m * i_n; l_en++ ) {
      double l_abs_error = std::abs( l_c[l_td][l_en] - l_c_ref[l_td][l_en] );
      double l_rel_error = l_abs_error / std::abs( l_c_ref[l_td][l_en] );

      if( l_abs_error > l_max_abs_error ) l_max_abs_error = l_abs_error;
      if( l_rel_error > l_max_rel_error ) l_max_rel_error = l_rel_error;
    }
  }

  std::cout << "  Max absolute error: " << l_max_abs_error << std::endl;
  std::cout << "  Max relative error: " << l_max_rel_error << std::endl;

  /*
   * benchmark Accelerate
   */
  std::chrono::steady_clock::time_point l_start = std::chrono::steady_clock::now();
  for( int l_td = 0; l_td < i_num_threads; l_td++ ) {
    dispatch_group_async( l_group,
                          l_queue,
                          ^{
                            rep_accelerate( i_num_reps,
                                            i_m,
                                            i_n,
                                            i_k,
                                            l_a[l_td],
                                            l_bt[l_td],
                                            l_c[l_td],
                                            l_b_trans );
                          } );
  }
  dispatch_group_wait( l_group,
                       DISPATCH_TIME_FOREVER );
  std::chrono::steady_clock::time_point l_end = std::chrono::steady_clock::now();

  int64_t l_num_flops = i_m * i_n * i_k * 2 * i_num_reps * i_num_threads;
  double l_duration = std::chrono::duration_cast< std::chrono::duration<double> >( l_end - l_start ).count();
  double l_gflops = l_num_flops * 1.0E-9;
  l_gflops /= l_duration;

  std::cout << "  Accelerate Duration:    " << l_duration << " s" << std::endl;
  std::cout << "  Accelerate Performance: " << l_gflops << " GFLOPS" << std::endl;

  /*
   * benchmark kernel
   */
  l_start = std::chrono::steady_clock::now();
  for( int l_td = 0; l_td < i_num_threads; l_td++ ) {
    dispatch_group_async( l_group,
                          l_queue,
                          ^{
                            rep_kernel( i_num_reps,
                                        i_m,
                                        i_n,
                                        i_k,
                                        i_kernel,
                                        l_a[l_td],
                                        l_bt[l_td],
                                        l_c[l_td] );
                          } );
  }
  dispatch_group_wait( l_group,
                       DISPATCH_TIME_FOREVER );
  l_end = std::chrono::steady_clock::now();

  l_num_flops = i_m * i_n * i_k * 2 * i_num_reps * i_num_threads;
  l_duration = std::chrono::duration_cast< std::chrono::duration<double> >( l_end - l_start ).count();
  l_gflops = l_num_flops * 1.0E-9;
  l_gflops /= l_duration;

  std::cout << "  Kernel Duration:        " << l_duration << " s" << std::endl;
  std::cout << "  Kernel Performance:     " << l_gflops << " GFLOPS" << std::endl;

  // free memory
  for( int l_td = 0; l_td < i_num_threads; l_td++ ) {
    free( l_a[l_td] );
    free( l_bt[l_td] );
    free( l_c[l_td] );
    free( l_c_ref[l_td] );
  }

  delete[] l_a;
  delete[] l_bt;
  delete[] l_c;
  delete[] l_c_ref;
}

void run_gemm( int i_num_threads,
               int i_qos_type ) {
  bench_gemm( i_num_threads,
              i_qos_type,
              20000000,
              32,
              32,
              32,
              gemm_micro_32_32_32 );

  bench_gemm( i_num_threads,
              i_qos_type,
              10000000,
              31,
              32,
              32,
              gemm_micro_31_32_32 );

  bench_gemm( i_num_threads,
              i_qos_type,
              1000000,
              128,
              128,
              128,
              gemm_128_128_128 );

  bench_gemm( i_num_threads,
              i_qos_type,
              10000000,
              32,
              32,
              32,
              gemm_micro_32_no_trans );
}