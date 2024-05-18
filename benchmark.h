#ifndef BENCHMARK_H
#define BENCHMARK_H

void run_micro_benchmark( int i_num_threads,
                          int i_qos_type );
void run_cblas_benchmark();
void run_bandwidth_benchmark();

#endif