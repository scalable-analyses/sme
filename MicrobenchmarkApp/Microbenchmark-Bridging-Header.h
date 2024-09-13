#include <Accelerate/Accelerate.h>
#include "examples.h"
#include "check_support.h"

void run_gemm( int i_num_threads,
               int i_qos_type );

void run_micro_benchmark( int i_num_threads,
                        int i_qos_class );
void run_cblas_benchmark();
void run_bandwidth_benchmark( int i_kernel_type,
                              int i_align_bytes,
                              int i_qos_class );