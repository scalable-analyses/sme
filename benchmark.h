#ifndef BENCHMARK_H
#define BENCHMARK_H

extern "C" {
  void run_micro_benchmark( int i_num_threads,
                            int i_qos_class );
  void run_cblas_benchmark();
  void run_copy_benchmark( int i_kernel_type,
                          int i_align_bytes,
                          int i_qos_class );
}

#endif