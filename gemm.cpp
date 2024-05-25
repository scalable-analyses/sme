#include "gemm.h"
#include "kernels_gemm.h"
#include <iostream>
#include <random>
#include <chrono>
#include <Accelerate/Accelerate.h>

void run_gemm( int i_num_threads,
               int i_qos_type ) {
  std::cout << "Running GEMM benchmark with "
            << i_num_threads << " threads and QoS type "
            << i_qos_type << std::endl;

  float * l_a = nullptr;
  float * l_bt = nullptr;
  float * l_c = nullptr;
  float * l_c_ref = nullptr;

  posix_memalign( (void**)&l_a,     128, 64*2*sizeof(float) );
  posix_memalign( (void**)&l_bt,    128, 2*16*sizeof(float) );
  posix_memalign( (void**)&l_c,     128, 64*16*sizeof(float) );
  posix_memalign( (void**)&l_c_ref, 128, 64*16*sizeof(float) );

  // init the matrices using a normal distribution with mean 0 and variance 1
  std::random_device l_rd;
  std::mt19937 l_gen( l_rd() );
  std::normal_distribution<float> l_dist( 0.0, 1.0 );

  for( int64_t l_en = 0; l_en < 64*2; l_en++ ) {
    l_a[l_en] = l_dist( l_gen );
  }
  for( int64_t l_en = 0; l_en < 2*16; l_en++ ) {
    l_bt[l_en] = l_dist( l_gen );
  }
  for( int64_t l_en = 0; l_en < 64*16; l_en++ ) {
    l_c[l_en] = 0.0;
    l_c_ref[l_en] = l_c[l_en];
  }

  // call the kernel
  gemm_micro_64_16_2( l_a, l_bt, l_c );

  // compute reference
  cblas_sgemm( CblasColMajor,
               CblasNoTrans,
               CblasTrans,
               64,
               16,
               2,
               1,
               l_a,
               64,
               l_bt,
               16,
               0,
               l_c_ref,
               64 );

  // compute maximum absolute and relative error
  double l_max_abs_error = 0;
  double l_max_rel_error = 0;

  for( int64_t l_en = 0; l_en < 64*16; l_en++ ) {
    double l_abs_error = std::abs( l_c[l_en] - l_c_ref[l_en] );
    double l_rel_error = l_abs_error / std::abs( l_c_ref[l_en] );

    if( l_abs_error > l_max_abs_error ) l_max_abs_error = l_abs_error;
    if( l_rel_error > l_max_rel_error ) l_max_rel_error = l_rel_error;
  }

  std::cout << "Max absolute error: " << l_max_abs_error << std::endl;
  std::cout << "Max relative error: " << l_max_rel_error << std::endl;

  std::chrono::steady_clock::time_point l_start = std::chrono::steady_clock::now();
  for( int l_en = 0; l_en < 10000000; l_en++ ) {
    gemm_micro_64_16_2( l_a, l_bt, l_c );
  }
  std::chrono::steady_clock::time_point l_end = std::chrono::steady_clock::now();

  double l_duration = std::chrono::duration_cast< std::chrono::duration< double> >( l_end - l_start ).count();
  double l_gflops = 64*16*2;
  l_gflops *= 10000000;
  l_gflops /= l_duration;
  l_gflops /= 1e9;

  std::cout << "Duration:    " << l_duration << " s" << std::endl;
  std::cout << "Performance: " << l_gflops << " GFLOPS" << std::endl;

  free( l_a );
  free( l_bt );
  free( l_c );
  free( l_c_ref );
}

void run_gemm2() {

  int64_t l_m = 32;
  int64_t l_n = 32;
  int64_t l_k = 32;

  std::cout << "M = " << l_m << std::endl;
  std::cout << "N = " << l_n << std::endl;
  std::cout << "K = " << l_k << std::endl;

  float * l_a     = (float *) malloc( l_m * l_k * sizeof(float));
  float * l_bt    = (float *) malloc( l_k * l_n * sizeof(float));
  float * l_c     = (float *) malloc( l_m * l_n * sizeof(float));
  float * l_c_ref = (float *) malloc( l_m * l_n * sizeof(float));

  srand48( time(NULL) );

  for( int i = 0; i < l_m * l_k; i++) {
    l_a[i] = drand48();
  }
  for( int i = 0; i < l_k * l_n; i++) {
    l_bt[i] = drand48();
  }
  for( int i = 0; i < l_m * l_n; i++) {
    l_c[i] = drand48();
    l_c_ref[i] = l_c[i];
  }
  
  // compute reference
  cblas_sgemm( CblasColMajor,
               CblasNoTrans,
               CblasTrans,
               l_m,
               l_n,
               l_k,
               1,
               l_a,
               32,
               l_bt,
               32,
               1,
               l_c_ref,
               32 );

  gemm_micro_32_32_32( l_a, l_bt, l_c);

  // compute maximum absolute and relative error
  double l_max_abs_error = 0;
  double l_max_rel_error = 0;

  for( int64_t l_en = 0; l_en < l_m*l_n; l_en++ ) {
    double l_abs_error = std::abs( l_c[l_en] - l_c_ref[l_en] );
    double l_rel_error = l_abs_error / std::abs( l_c_ref[l_en] );

    if( l_abs_error > l_max_abs_error ) l_max_abs_error = l_abs_error;
    if( l_rel_error > l_max_rel_error ) l_max_rel_error = l_rel_error;
  }

  std::cout << "Max absolute error: " << l_max_abs_error << std::endl;
  std::cout << "Max relative error: " << l_max_rel_error << std::endl;

  long l_n_rep = 50000000;
  double l_gflops = l_m * l_n * l_k * 2 * l_n_rep;

  /* warming up */
  gemm_micro_32_32_32(l_a, l_bt, l_c);
  std::chrono::steady_clock::time_point l_start = std::chrono::steady_clock::now();
  for( int l_en = 0; l_en < l_n_rep; l_en++ ) {
    gemm_micro_32_32_32( l_a, l_bt, l_c );
  }
  std::chrono::steady_clock::time_point l_end = std::chrono::steady_clock::now();

  double l_duration = std::chrono::duration_cast< std::chrono::duration<double> >( l_end - l_start ).count();
  l_gflops *= 1.0E-9;
  l_gflops /= l_duration;

  std::cout << "Duration:    " << l_duration << " s" << std::endl;
  std::cout << "Performance: " << l_gflops << " GFLOPS" << std::endl;

  free( l_a );
  free( l_bt );
  free( l_c );
  free( l_c_ref );

  std::cout << "Done with 32x32 kernel " << std::endl;
  std::cout << std::endl;
  

  l_m = 31;
  l_n = 32;
  l_k = 32;

  std::cout << "M = " << l_m << std::endl;
  std::cout << "N = " << l_n << std::endl;
  std::cout << "K = " << l_k << std::endl;

  l_a     = (float *) malloc( l_m * l_k * sizeof(float));
  l_bt    = (float *) malloc( l_k * l_n * sizeof(float));
  l_c     = (float *) malloc( l_m * l_n * sizeof(float));
  l_c_ref = (float *) malloc( l_m * l_n * sizeof(float));

  for( int i = 0; i < l_m * l_k; i++) {
    l_a[i] = drand48();
  }
  for( int i = 0; i < l_k * l_n; i++) {
    l_bt[i] = drand48();
  }
  for( int i = 0; i < l_m * l_n; i++) {
    l_c[i] = drand48();
    l_c_ref[i] = l_c[i];
  }

  // compute reference
  cblas_sgemm( CblasColMajor,
               CblasNoTrans,
               CblasTrans,
               l_m,
               l_n,
               l_k,
               1,
               l_a,
               31,
               l_bt,
               32,
               1,
               l_c_ref,
               32 );

  gemm_micro_31_32_32( l_a, l_bt, l_c);

  // compute maximum absolute and relative error
  l_max_abs_error = 0;
  l_max_rel_error = 0;

  for( int64_t l_en = 0; l_en < l_m*l_n; l_en++ ) {
    double l_abs_error = std::abs( l_c[l_en] - l_c_ref[l_en] );
    double l_rel_error = l_abs_error / std::abs( l_c_ref[l_en] );

    if( l_abs_error > l_max_abs_error ) l_max_abs_error = l_abs_error;
    if( l_rel_error > l_max_rel_error ) l_max_rel_error = l_rel_error;
  }

  std::cout << "Max absolute error: " << l_max_abs_error << std::endl;
  std::cout << "Max relative error: " << l_max_rel_error << std::endl;

  l_n_rep = 50000000;
  l_gflops = l_m * l_n * l_k * 2 * l_n_rep;

  /* warming up */
  gemm_micro_31_32_32(l_a, l_bt, l_c);
  l_start = std::chrono::steady_clock::now();
  for( int l_en = 0; l_en < l_n_rep; l_en++ ) {
    gemm_micro_31_32_32( l_a, l_bt, l_c );
  }
  l_end = std::chrono::steady_clock::now();

  l_duration = std::chrono::duration_cast< std::chrono::duration<double> >( l_end - l_start ).count();
  l_gflops *= 1.0E-9;
  l_gflops /= l_duration;

  std::cout << "Duration:    " << l_duration << " s" << std::endl;
  std::cout << "Performance: " << l_gflops << " GFLOPS" << std::endl;

  free( l_a );
  free( l_bt );
  free( l_c );
  free( l_c_ref );

  std::cout << "Done with 31x32 kernel " << std::endl;
}
