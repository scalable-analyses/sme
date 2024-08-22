#include "benchmark.h"
#include <cstdint>
#include <cstdlib>
#include <arm_bf16.h>
#include <arm_neon.h>
#include <pthread.h>
#include <chrono>
#include <thread>
#include <Accelerate/Accelerate.h>
#include <iostream>
#include <string>
#include <os/proc.h>

extern "C" {
  int peak_neon_fmla_fp32_fp32_fp32( int64_t i_num_reps );
  int peak_neon_fmla_fp64_fp64_fp64( int64_t i_num_reps );
  int peak_neon_fmla_fp16_fp16_fp16( int64_t i_num_reps );
  int peak_neon_bfmmla_bf16_bf16_fp32( int64_t i_num_reps );
  int peak_sve_fmla_streaming_fp32_fp32_fp32( int64_t i_num_reps );
  int peak_sve_fmla_streaming_fp64_fp64_fp64( int64_t i_num_reps );
  int peak_sme_fmopa_1_fp32_fp32_fp32( int64_t i_num_reps );
  int peak_sme_fmopa_2_fp32_fp32_fp32( int64_t i_num_reps );
  int peak_sme_fmopa_4_fp32_fp32_fp32( int64_t i_num_reps );
  int peak_sme_fmopa_4_fp32_fp32_fp32_predicated_15( int64_t i_num_reps);
  int peak_sme_fmopa_4_fp32_fp32_fp32_predicated_8( int64_t i_num_reps);
  int peak_sme_fmopa_4_reorder_fp32_fp32_fp32( int64_t i_num_reps );
  int peak_sme_fmopa_fp64_fp64_fp64( int64_t i_num_reps );
  int peak_sme_fmopa_smstart_smstop_8_fp32_fp32_fp32( int64_t i_num_reps );
  int peak_sme_fmopa_smstart_smstop_16_fp32_fp32_fp32( int64_t i_num_reps );
  int peak_sme_fmopa_smstart_smstop_32_fp32_fp32_fp32( int64_t i_num_reps );
  int peak_sme_fmopa_smstart_smstop_64_fp32_fp32_fp32( int64_t i_num_reps );
  int peak_sme_fmopa_smstart_smstop_128_fp32_fp32_fp32( int64_t i_num_reps );
  int peak_sme_fmopa_fp16_fp16_fp32( int64_t i_num_reps );
  int peak_sme_fmopa_fp16_fp16_fp16( int64_t i_num_reps );
  int peak_sme_bfmopa_bf16_bf16_fp32( int64_t i_num_reps );
  int peak_sme_bfmopa_bf16_bf16_bf16( int64_t i_num_reps );
  int peak_sme_smopa_i8_i8_i32( int64_t i_num_reps );
  int peak_sme_smopa_i16_i16_i32( int64_t i_num_reps );
  int peak_amx_fma_fp32_fp32_fp32( int64_t i_num_reps );
  int peak_sme_fmla_4_fp32_fp32_fp32( int64_t i_num_reps );
  int peak_sme_fmla_4_bf16_bf16_fp32( int64_t i_num_reps );
  int peak_sme_fmla_4_fp64_fp64_fp64( int64_t i_num_reps );


  void load_data_sme_ldr_za( int64_t  i_num_reps,
                             int64_t  i_num_vals,
                             float  * i_a  );
  void load_data_sme_ldr( int64_t  i_num_reps,
                          int64_t  i_num_vals,
                          float  * i_a  );
  void load_data_sme_1_z( int64_t  i_num_reps,
                          int64_t  i_num_vals,
                          float  * i_a  );
  void load_data_sme_2_z( int64_t  i_num_reps,
                          int64_t  i_num_vals,
                          float  * i_a  );
  void load_data_sme_4_z( int64_t  i_num_reps,
                          int64_t  i_num_vals,
                          float  * i_a  );
  void load_data_sme_2_z_strided( int64_t  i_num_reps,
                                  int64_t  i_num_vals,
                                  float  * i_a  );
  void load_data_sme_4_z_strided( int64_t    i_num_reps,
                                  int64_t    i_num_vals,
                                  float    * i_a  );

  void store_data_sme_str_za( int64_t  i_num_reps,
                              int64_t  i_num_vals,
                              float  * o_b  );
  void store_data_sme_str( int64_t  i_num_reps,
                           int64_t  i_num_vals,
                           float  * o_b  );
  void store_data_sme_1_z( int64_t  i_num_reps,
                           int64_t  i_num_vals,
                           float  * o_b  );
  void store_data_sme_2_z( int64_t  i_num_reps,
                           int64_t  i_num_vals,
                           float  * o_b  );
  void store_data_sme_4_z( int64_t  i_num_reps,
                           int64_t  i_num_vals,
                           float  * o_b  );
  void store_data_sme_2_z_strided( int64_t  i_num_reps,
                                   int64_t  i_num_vals,
                                   float  * o_b  );
  void store_data_sme_4_z_strided( int64_t  i_num_reps,
                                   int64_t  i_num_vals,
                                   float  * o_b  );
}

enum bandwidth_kernel {
  LDR_Z            = 0,
  LD1W_Z_1         = 1,
  LD1W_Z_2         = 2,
  LD1W_Z_4         = 3,
  LD1W_Z_STRIDED_2 = 4,
  LD1W_Z_STRIDED_4 = 5,
  LDR_ZA           = 6,
  STR_Z            = 7,
  ST1W_Z_1         = 8,
  ST1W_Z_2         = 9,
  ST1W_Z_4         = 10,
  ST1W_Z_STRIDED_2 = 11,
  ST1W_Z_STRIDED_4 = 12,
  STR_ZA           = 13
};

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
  std::chrono::steady_clock::time_point l_start;
  std::chrono::steady_clock::time_point l_end;
  double l_duration = 0;

  // run benchmark
  l_start = std::chrono::steady_clock::now();
  for( int l_td = 0; l_td < i_num_threads; l_td++ ) {
    dispatch_group_async( l_group,
                          l_queue,
                          ^{ i_kernel( i_num_reps ); } );
  }
  dispatch_group_wait( l_group,
                       DISPATCH_TIME_FOREVER );
  l_end = std::chrono::steady_clock::now();
  l_duration = std::chrono::duration_cast< std::chrono::duration<double> >( l_end - l_start ).count();

  // determine GOPS
  l_gops = i_kernel( 1 );
  l_gops *= i_num_threads;
  l_gops *= i_num_reps;
  l_gops *= 1.0E-9;
  l_gops /= l_duration;

  std::cout << "  Repetitions:  " << i_num_reps << std::endl;
  std::cout << "  Duration (s): " << l_duration << std::endl;
  std::cout << "  GOPS:         " << l_gops     << std::endl;
}

void bench_bandwidth( int64_t     i_num_vals,
                      int64_t     i_offset_bytes,
                      int64_t     i_num_reps,
                      bandwidth_kernel i_kernel_type ) {
  std::cout << "Running bandwidth benchmark..." << std::endl;

  std::chrono::steady_clock::time_point l_start;
  std::chrono::steady_clock::time_point l_end;
  double l_duration = 0;
  void (* l_kernel)( int64_t,
                     int64_t,
                     float  * ) = 0;

  std::string l_kernel_name = "";
  // load instructions
  if( i_kernel_type == bandwidth_kernel::LDR_Z ) {
    l_kernel_name = "LDR_Z";
    l_kernel = load_data_sme_ldr;
  }
  else if( i_kernel_type == bandwidth_kernel::LD1W_Z_1 ) {
    l_kernel_name = "LD1W_Z_1";
    l_kernel = load_data_sme_1_z;
  }
  else if( i_kernel_type == bandwidth_kernel::LD1W_Z_2 ) {
    l_kernel_name = "LD1W_Z_2";
    l_kernel = load_data_sme_2_z;
  }
  else if( i_kernel_type == bandwidth_kernel::LD1W_Z_4 ) {
    l_kernel_name = "LD1W_Z_4";
    l_kernel = load_data_sme_4_z;
  }
  else if( i_kernel_type == bandwidth_kernel::LD1W_Z_STRIDED_2 ) {
    l_kernel_name = "LD1W_Z_STRIDED_2";
    l_kernel = load_data_sme_2_z_strided;
  }
  else if( i_kernel_type == bandwidth_kernel::LD1W_Z_STRIDED_4 ) {
    l_kernel_name = "LD1W_Z_STRIDED_4";
    l_kernel = load_data_sme_4_z_strided;
  }
  else if( i_kernel_type == bandwidth_kernel::LDR_ZA ) {
    l_kernel_name = "LDR_ZA";
    l_kernel = load_data_sme_ldr_za;
  }
  // store instructions
  else if( i_kernel_type == bandwidth_kernel::STR_Z ) {
    l_kernel_name = "STR_Z";
    l_kernel = store_data_sme_str;
  }
  else if( i_kernel_type == bandwidth_kernel::ST1W_Z_1 ) {
    l_kernel_name = "ST1W_Z_1";
    l_kernel = store_data_sme_1_z;
  }
  else if( i_kernel_type == bandwidth_kernel::ST1W_Z_2 ) {
    l_kernel_name = "ST1W_Z_2";
    l_kernel = store_data_sme_2_z;
  }
  else if( i_kernel_type == bandwidth_kernel::ST1W_Z_4 ) {
    l_kernel_name = "ST1W_Z_4";
    l_kernel = store_data_sme_4_z;
  }
  else if( i_kernel_type == bandwidth_kernel::ST1W_Z_STRIDED_2 ) {
    l_kernel_name = "ST1W_Z_STRIDED_2";
    l_kernel = store_data_sme_2_z_strided;
  }
  else if( i_kernel_type == bandwidth_kernel::ST1W_Z_STRIDED_4 ) {
    l_kernel_name = "ST1W_Z_STRIDED_4";
    l_kernel = store_data_sme_4_z_strided;
  }
  else if( i_kernel_type == bandwidth_kernel::STR_ZA ) {
    l_kernel_name = "STR_ZA";
    l_kernel = store_data_sme_str_za;
  }
  else {
    std::cerr << "Unknown kernel type: " << i_kernel_type << std::endl;
    return;
  }

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

  // run bandwidth benchmark
  l_start = std::chrono::steady_clock::now();
  l_kernel( i_num_reps,
            i_num_vals,
            l_a );
  l_end = std::chrono::steady_clock::now();
  l_duration = std::chrono::duration_cast< std::chrono::duration<double> >( l_end - l_start ).count();

  // print results
  double l_num_bytes = i_num_reps * i_num_vals * 4;
  double l_gibs = l_num_bytes / (1024.0*1024.0*1024.0);
         l_gibs /= l_duration;
  
  double l_mib_per_iter = i_num_vals * 4 / (1024.0*1024.0);

  std::cout << "  Kernel:       " << l_kernel_name << std::endl;
  std::cout << "  #Values:      " << i_num_vals << std::endl;
  std::cout << "  Offset:       " << i_offset_bytes << std::endl;
  std::cout << "  Repetitions:  " << i_num_reps << std::endl;
  std::cout << "  MiB per iter: " << l_mib_per_iter << std::endl;
  std::cout << "  Duration (s): " << l_duration << std::endl;
  std::cout << "  GiB/s:        " << l_gibs << std::endl;
  std::cout << "  CSV_DATA: " << l_kernel_name  << ","
                              << i_num_vals     << ","
                              << i_offset_bytes << ","
                              << i_num_reps     << ","
                              << l_mib_per_iter << ","
                              << l_duration     << ","
                              << l_gibs         << std::endl;

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
  std::cout << "Running CBLAS SGEMM..." << std::endl;
  std::cout << "  M/N/K:         " << i_m << "/" << i_n << "/" << i_k << std::endl;
  std::cout << "  ldA/ldB/ldC:   " << i_lda << "/" << i_ldb << "/" << i_ldc << std::endl;
  std::cout << "  TransA/TransB: " << i_trans_a << "/" << i_trans_b << std::endl;

  // vars
  int64_t l_num_reps = 0;
  int64_t l_num_flops = 0;
  double l_gflops = 0;
  std::chrono::steady_clock::time_point l_start;
  std::chrono::steady_clock::time_point l_end;
  double l_duration = 0;

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

  l_start = std::chrono::steady_clock::now();
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
  l_end = std::chrono::steady_clock::now();

  l_duration = std::chrono::duration_cast< std::chrono::duration<double> >( l_end - l_start ).count();

  l_num_reps = (i_target_time * i_num_reps_initial) / l_duration;
  l_num_reps = l_num_reps > 1 ? l_num_reps : 1;
  l_num_flops = 2 * i_m * i_n * i_k * l_num_reps;

  l_start = std::chrono::steady_clock::now();
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
  l_end = std::chrono::steady_clock::now();
  l_duration = std::chrono::duration_cast< std::chrono::duration<double> >( l_end - l_start ).count();

  l_gflops = l_num_flops / l_duration;
  l_gflops *= 1.0E-9;

  std::cout << "  Repetitions:  " << l_num_reps << std::endl;
  std::cout << "  Duration (s): " << l_duration << std::endl;
  std::cout << "  GFLOPS:       " << l_gflops   << std::endl;

  free( l_a );
  free( l_b );
  free( l_c );
}

void run_micro_benchmark( int i_num_threads,
                          int i_qos_class ) {
  std::cout << "Running benchmarks..." << std::endl;
  std::cout << "  Threads: " << i_num_threads << std::endl;
  if( i_qos_class == 1 ) {
    std::cout << "  QoS: User Interactive" << std::endl;
  }
  else if( i_qos_class == 2 ) {
    std::cout << "  QoS: User Initiated" << std::endl;
  }
  else if( i_qos_class == 3 ) {
    std::cout << "  QoS: Utility" << std::endl;
  }
  else if( i_qos_class == 4 ) {
    std::cout << "  QoS: Background" << std::endl;
  }
  else {
    std::cout << "  QoS: Default" << std::endl;
  }

  std::cout << "Determining FP64 Neon FMLA performance..." << std::endl;
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 1000000000 : 200000000,
               peak_neon_fmla_fp64_fp64_fp64 );

  std::cout << "Determining FP32 Neon FMLA performance..." << std::endl;
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 1000000000 : 200000000,
               peak_neon_fmla_fp32_fp32_fp32 );

  std::cout << "Determining FP16 Neon FMLA performance..." << std::endl;
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 2000000000 : 400000000,
               peak_neon_fmla_fp16_fp16_fp16 );

  std::cout << "Determining BF16-BF16-FP32 BFMMLA Neon performance" << std::endl;
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 200000000 : 40000000,
               peak_neon_bfmmla_bf16_bf16_fp32 );

  std::cout << "Determining FP32 SSVE FMLA (Z accumulation) performance..." << std::endl;
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 100000000 : 20000000,
               peak_sve_fmla_streaming_fp32_fp32_fp32 );

  std::cout << "Detemining FP64 SSVE FMLA (Z accumulation) performance..." << std::endl;
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 100000000 : 20000000,
                peak_sve_fmla_streaming_fp64_fp64_fp64);

  std::cout << "Determining FP32 AMX performance..." << std::endl;
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 100000000 : 2000000,
               peak_amx_fma_fp32_fp32_fp32 );

  std::cout << "Determining FP32 SME FMOPA performance (1 tile)..." << std::endl;
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 25000000 : 5000000,
               peak_sme_fmopa_1_fp32_fp32_fp32 );

  std::cout << "Determining FP32 SME FMOPA performance (2 tiles)..." << std::endl;
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 25000000 : 5000000,
               peak_sme_fmopa_2_fp32_fp32_fp32 );

  std::cout << "Determining FP32 SME FMOPA performance (4 tiles)..." << std::endl;
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 25000000 : 5000000,
               peak_sme_fmopa_4_fp32_fp32_fp32 );

  std::cout << "Determining FP32 SME predicated (8/16) FMOPA performance (4 tiles)..." << std::endl;
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 25000000 : 5000000,
               peak_sme_fmopa_4_fp32_fp32_fp32_predicated_8 );

  std::cout << "Determining FP32 SME predicated (15/16) FMOPA performance (4 tiles)..." << std::endl;
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 25000000 : 5000000,
               peak_sme_fmopa_4_fp32_fp32_fp32_predicated_15 );

  std::cout << "Determining FP32 SME FMOPA performance (4 tiles, reordering)..." << std::endl;
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 25000000 : 5000000,
               peak_sme_fmopa_4_reorder_fp32_fp32_fp32 );

  std::cout << "Determining FP32 SME SMSTART-SMSTOP performance (8 instructions per block).." << std::endl;
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 25000000 : 15000000,
               peak_sme_fmopa_smstart_smstop_8_fp32_fp32_fp32 );

  std::cout << "Determining FP32 SME SMSTART-SMSTOP performance (16 instructions per block)..." << std::endl;
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 25000000 : 15000000,
               peak_sme_fmopa_smstart_smstop_16_fp32_fp32_fp32 );

  std::cout << "Determining FP32 SME SMSTART-SMSTOP performance (32 instructions per block)..." << std::endl;
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 25000000 : 15000000,
               peak_sme_fmopa_smstart_smstop_32_fp32_fp32_fp32 );

  std::cout << "Determining FP32 SME SMSTART-SMSTOP performance (64 instructions per block)..." << std::endl;
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 25000000 : 500000,
               peak_sme_fmopa_smstart_smstop_64_fp32_fp32_fp32 );

  std::cout << "Determining FP32 SME SMSTART-SMSTOP performance (128 instructions per block)..." << std::endl;
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 25000000 : 5000000,
               peak_sme_fmopa_smstart_smstop_128_fp32_fp32_fp32 );

  std::cout << "Determining FP16-FP16-FP32 SME FMOPA performance..." << std::endl;
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 25000000 : 5000000,
               peak_sme_fmopa_fp16_fp16_fp32 );

  std::cout << "Determining BF16-BF16-FP32 SME BFMOPA performance..." << std::endl;
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 25000000 : 5000000,
               peak_sme_bfmopa_bf16_bf16_fp32 );

  std::cout << "Determining FP64 SME FMOPA performance ..." << std::endl;
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 25000000 : 5000000,
               peak_sme_fmopa_fp64_fp64_fp64 );

  std::cout << "Determining I8-I8-I32 SME SMOPA performance..." << std::endl;
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 25000000 : 5000000,
               peak_sme_smopa_i8_i8_i32 );

  std::cout << "Determining I16-I16-I32 SME FMOPA performance..." << std::endl;
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 25000000 : 50000000,
               peak_sme_smopa_i16_i16_i32 );

  std::cout << "Determining FP32 SME FMLA performance..." << std::endl;
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 25000000 : 20000000,
               peak_sme_fmla_4_fp32_fp32_fp32 );

  std::cout << "Determining FP64 SME FMLA performance..." << std::endl;
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 250000000 : 200000000,
               peak_sme_fmla_4_fp64_fp64_fp64 );

  std::cout << "Determining BF16-BF16-FP32 SME BFDOT performance..." << std::endl;
  bench_micro( i_num_threads,
               i_qos_class,
               (i_qos_class < 4) ? 10000000 : 20000000,
               peak_sme_fmla_4_bf16_bf16_fp32 );
}

/*
 * Run CBLAS benchmarks
 */
void run_cblas_benchmark(){
  std::cout << "Running CBLAS benchmarks..." << std::endl;
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
void run_bandwidth_benchmark( int i_kernel_type,
                         int i_align_bytes,
                         int i_qos_class ){
  std::cout << "Running bandwidth benchmarks..." << std::endl;
  std::cout << "  Kernel type:            " << i_kernel_type << std::endl;
  std::cout << "  Align bytes:            " << i_align_bytes << std::endl;
  std::cout << "  QoS class:              " << i_qos_class   << std::endl;

  std::size_t l_mem_avail = os_proc_available_memory();
  double l_mem_avail_mib = l_mem_avail / (1024.0*1024.0);
  std::cout << "  Available memory (MiB): " << l_mem_avail_mib << std::endl;

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

  int64_t l_off = i_align_bytes % 128;

    int64_t l_num_values[47] = {          256,    //   2 KiB
                                          512,    //   4 KiB
                                         1024,    //   8 KiB
                                         2048,    //  16 KiB
                                         4096,    //  32 KiB

                                         8192,    //  64 KiB
                                        16384,    // 128 KiB
                                        32768,    // 256 KiB
                                        65536,    // 512 KiB
                                       131072,    //   1 MiB

                                       262144,    //   2 MiB
                                       524288,    //   4 MiB
                                       786432,    //   6 MiB
                                       917504,    //   7 MiB
                                      1048576,    //   8 MiB

                                      1179648,    //   9 MiB
                                      1310720,    //  10 MiB
                                      1441792,    //  11 MiB
                                      1572864,    //  12 MiB
                                      1703936,    //  13 MiB

                                      1835008,    //  14 MiB
                                      1966080,    //  15 MiB
                                      2097152,    //  16 MiB
                                      2228224,    //  17 MiB
                                      2359296,    //  18 MiB

                                      2490368,    //  19 MiB
                                      2621440,    //  20 MiB
                                      2752512,    //  21 MiB
                                      2883584,    //  22 MiB
                                      3014656,    //  23 MiB

                                      3145728,    //  24 MiB
                                      3276800,    //  25 MiB
                                      3407872,    //  26 MiB
                                      3538944,    //  27 MiB
                                      3670016,    //  28 MiB

                                      3801088,    //  29 MiB
                                      3932160,    //  30 MiB
                                      4063232,    //  31 MiB
                                      4194304,    //  32 MiB
                                      8388608,    //  64 MiB

                                      16777216,   // 128 MiB
                                      33554432,   // 256 MiB
                                      67108864,   // 512 MiB
                                     134217728,   //   1 GiB
                                     268435456,   //   2 GiB

                                     536870912,   //   4 GiB
                                    1073741824 }; //   8 GiB

      int64_t l_num_reps[47] = {  994683648,    //   2 KiB
                                  858734592,    //   4 KiB
                                  429367296,    //   8 KiB
                                  214683648,    //  16 KiB
                                  107341824,    //  32 KiB

                                    53670912,   //  64 KiB
                                    26835456,   // 128 KiB
                                    13417728,   // 256 KiB
                                     6708864,   // 512 KiB
                                     3354432,   //   1 MiB

                                     1677216,   //   2 MiB
                                      838608,   //   4 MiB
                                      559072,   //   6 MiB
                                      479536,   //   7 MiB
                                      419768,   //   8 MiB

                                      383884,   //   9 MiB
                                      335443,   //  10 MiB
                                      305222,   //  11 MiB
                                      279616,   //  12 MiB
                                      255768,   //  13 MiB

                                      235536,   //  14 MiB
                                      218072,   //  15 MiB
                                      202611,   //  16 MiB
                                      188992,   //  17 MiB
                                      176768,   //  18 MiB

                                      165888,   //  19 MiB
                                      156044,   //  20 MiB
                                      147768,   //  21 MiB
                                      140611,   //  22 MiB
                                      134177,   //  23 MiB

                                      128384,   //  24 MiB
                                      123111,   //  25 MiB
                                       59139,   //  26 MiB
                                       56913,   //  27 MiB
                                       54855,   //  28 MiB

                                       52944,   //  29 MiB
                                       51161,   //  30 MiB
                                       49492,   //  31 MiB
                                       32768,   //  32 MiB
                                        8192,   //  64 MiB

                                        4096,   // 128 MiB
                                        2048,   // 256 MiB
                                        1024,   // 512 MiB
                                         512,   //   1 GiB
                                         256,   //   2 GiB

                                         128,   //  4 GiB
                                          64 }; //  8 GiB

  for( int64_t l_be = 1; l_be < 47; l_be++ ) {
    if( l_num_values[l_be]*4*2 < l_mem_avail ) {
      // sleep for 10 seconds to allow SoC to cool down
      std::this_thread::sleep_for( std::chrono::seconds( 10 )) ;

      bench_bandwidth( l_num_values[l_be],
                       l_off,
                       l_num_reps[l_be]/2,
                       (bandwidth_kernel) i_kernel_type );
    }
  }
}
