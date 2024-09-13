#include "gemm.h"
#include "libxsmm.h"
#include <stdio.h>
#include <sys/time.h>
#include <unistd.h>
#include <stdint.h>
#include <os/proc.h>
#include <Accelerate/Accelerate.h>



void gemm_ref( float        const * i_a,
               float        const * i_b,
               float              * io_c,
               int64_t              i_m,
               int64_t              i_n,
               int64_t              i_k,
               int64_t              i_lda,
               int64_t              i_ldb,
               int64_t              i_ldc ){

    for( int l_m = 0; l_m < i_m; l_m++ ) {
        for( int l_n = 0; l_n < i_n; l_n++ ) {
            for( int l_k = 0; l_k < i_k; l_k++ ) {
                io_c[ (l_n*i_ldc) + l_m ] += i_a[ (l_k*i_lda) + l_m ] * i_b[ (l_n*i_ldb) + l_k ];
            }
        }
    }
}

void gemm_ref_trans(float        const * i_a,
                    float        const * i_b,
                    float              * io_c,
                    int64_t              i_m,
                    int64_t              i_n,
                    int64_t              i_k,
                    int64_t              i_lda,
                    int64_t              i_ldb,
                    int64_t              i_ldc ){
  for( int l_m = 0; l_m < i_m; l_m++ ) {
        for( int l_n = 0; l_n < i_n; l_n++ ) {
            for( int l_k = 0; l_k < i_k; l_k++ ) {
                io_c[ (l_n*i_ldc) + l_m ] += i_a[ (l_k*i_lda) + l_m ] * i_b[ (l_k*i_ldb) + l_n ];
            }
        }
    }
}
float gemm_normal(int input_m, int input_n, int input_k, int i_lda, int i_ldb, int i_ldc, int i_reps){
    
    libxsmm_gemm_shape l_shape_gemm;
    libxsmm_bitfield l_flags_brgemm = LIBXSMM_GEMM_FLAGS('N','N');
    libxsmm_bitfield l_prefetch_flags = 0;
    
    libxsmm_gemm_ext_unary_argops l_argops;
    libxsmm_gemm_ext_binary_postops l_postops;
    
    memset( &l_argops, 0, sizeof(libxsmm_gemm_ext_unary_argops) );
    memset( &l_postops, 0, sizeof(libxsmm_gemm_ext_binary_postops) );
    
    
    srand(time(NULL));
    
    libxsmm_blasint l_m = input_m;
    libxsmm_blasint l_n = input_n;
    libxsmm_blasint l_k = input_k;
    
    libxsmm_blasint l_lda = i_lda;
    libxsmm_blasint l_ldb = i_ldb;
    libxsmm_blasint l_ldc = i_ldc;
    
    l_argops.ldcp = l_ldc;
    l_argops.cp_unary_type  = LIBXSMM_MELTW_TYPE_UNARY_NONE;
    
    printf( "M = %d\n", l_m);
    printf( "N = %d\n", l_n);
    printf( "K = %d\n", l_k);
    printf( "LDA = %d\n", l_lda);
    printf( "LDB = %d\n", l_ldb);
    printf( "LDC = %d\n", l_ldc);
    
    
    l_shape_gemm = libxsmm_create_gemm_shape(l_m ,
                                             l_n,
                                             l_k,
                                             l_lda,
                                             l_ldb,
                                             l_ldc,
                                             LIBXSMM_DATATYPE_F32,
                                             LIBXSMM_DATATYPE_F32,
                                             LIBXSMM_DATATYPE_F32,
                                             LIBXSMM_DATATYPE_F32 );
    
    libxsmm_gemm_batch_reduce_config l_config;
    l_config.br_type = LIBXSMM_GEMM_BATCH_REDUCE_NONE;
    l_config.br_stride_a_hint = 0;
    l_config.br_stride_b_hint = 0;
    l_config.br_unroll_hint = 0;
    
    libxsmm_xmmfunction l_kernel_forward;
    
    l_kernel_forward.gemm_ext = libxsmm_dispatch_brgemm_ext( l_shape_gemm,
                                                        l_flags_brgemm,
                                                        l_prefetch_flags,
                                                        l_config,
                                                        l_argops,
                                                        l_postops);
    libxsmm_gemm_param l_param;
    memset( &l_param, 0, sizeof(libxsmm_gemm_param));
    float * l_a = (float *) malloc( l_lda * l_k * sizeof(float));
    float * l_b = (float *) malloc( l_n * l_ldb * sizeof(float));
    float * l_c = (float *) malloc( l_n * l_ldc * sizeof(float));
    float * l_c_ref = (float *) malloc( l_n * l_ldc * sizeof(float));
    
    for( int i = 0; i < l_lda *l_k ; i++){
        l_a[i] = (float) drand48();
    }
    for( int i = 0; i < l_n * l_ldb ; i++){
        l_b[i] = (float) drand48();
    }
    for( int i = 0; i < l_n *l_ldc ; i++){
        l_c[i] = (float) drand48();
        l_c_ref[i] = l_c[i];
    }
    
    // compute reference
    gemm_ref(l_a, l_b, l_c_ref, l_m, l_n, l_k, l_lda, l_ldb, l_ldc);
    
    struct timeval l_start;
    struct timeval l_end;
    long seconds;
    long useconds;
    double l_gflops = (double) l_m * l_n * l_k * 2;
    double total_time = 0.0;
    long l_reps = 3000000;
    int l_num_threads = 1;

    if(i_reps > 0 ){
        l_reps = i_reps;
    }
    
    l_param.a.primary = l_a;
    l_param.b.primary = l_b;
    l_param.c.primary = l_c;
    
    l_kernel_forward.gemm( &l_param);
    
    float diff = 0.0;
    for( int l_en = 0; l_en < l_ldc * l_n ; l_en++){
        diff += fabs(l_c[l_en] - l_c_ref[l_en]);
        if( fabs(l_c[l_en] - l_c_ref[l_en]) != 0 ){
            printf("[%d]: %f -- %f \n",l_en, l_c[l_en], l_c_ref[l_en] );
        }
    }
    
    printf( "Absolute error: %f \n", diff );

    dispatch_queue_attr_t l_attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT,
                                                                           QOS_CLASS_USER_INTERACTIVE,
                                                                           0 );
    dispatch_queue_t l_queue = dispatch_queue_create( "gemm_queue",
                                                      l_attr );
    dispatch_group_t l_group = dispatch_group_create();

    l_kernel_forward.gemm( &l_param);
    gettimeofday(&l_start, NULL);
    for( int l_td = 0; l_td < l_num_threads ; l_td++){
        
        dispatch_group_async( l_group,
                              l_queue,
                              ^{
            for( int i = 0 ; i < l_reps ; i++){
               l_kernel_forward.gemm( &l_param);
            }
        } );
    }
    dispatch_group_wait(l_group, DISPATCH_TIME_FOREVER);
    gettimeofday(&l_end, NULL);
    
    seconds = l_end.tv_sec - l_start.tv_sec;
    useconds = l_end.tv_usec - l_start.tv_usec;
    total_time = seconds + useconds/1000000.0;
    
    l_gflops *= l_reps;
    l_gflops *= l_num_threads;
    l_gflops *= 1.0E-9;
    l_gflops /= total_time;
    
    printf( "LIBXSMM:\n");
    printf( "Duration: %f s\n", total_time);
    printf( "GFLOPS  : %f  \n", l_gflops);
    double libxsmm_gflops = l_gflops;
    printf( "Apple Accelerate:\n");
    
    gettimeofday(&l_start, NULL);
    for( int l_td = 0; l_td < l_num_threads ; l_td++){
        
        dispatch_group_async( l_group,
                              l_queue,
                              ^{
            for( int i = 0 ; i< l_reps ; i++){
                 cblas_sgemm( CblasColMajor,
                              CblasNoTrans,
                              CblasNoTrans,
                              l_m,
                              l_n,
                              l_k,
                              1,
                              l_a,
                              l_lda,
                              l_b,
                              l_ldb,
                              1,
                              l_c,
                              l_ldc );
                
            }
        } );
    }
    dispatch_group_wait(l_group, DISPATCH_TIME_FOREVER);
    gettimeofday(&l_end, NULL);
    
    seconds = l_end.tv_sec - l_start.tv_sec;
    useconds = l_end.tv_usec - l_start.tv_usec;
    total_time = seconds + useconds/1000000.0;
    
    l_gflops = (double) l_m * l_n * l_k * 2;
    l_gflops *= l_reps;
    l_gflops *= l_num_threads;
    l_gflops *= 1.0E-9;
    l_gflops /= total_time;
    double accelerate_gflops = l_gflops;
    
    printf( "Duration: %f s\n", total_time);
    printf( "GFLOPS  : %f  \n", l_gflops);
    printf( "Repetitions: %ld\n", l_reps);
    printf("CSV_DATA_LIB: %d,%d,%d,%f\n", l_m, l_n, l_k, libxsmm_gflops);
    printf("CSV_DATA_APPLE: %d,%d,%d,%f\n", l_m, l_n, l_k, accelerate_gflops);
        
    free(l_a);
    free(l_b);
    free(l_c);
    free(l_c_ref);
    
    sleep(3);

    return diff;
}

float gemm_b_transpose(int input_m, int input_n, int input_k, int i_lda, int i_ldb, int i_ldc, int i_reps){
    
    libxsmm_gemm_shape l_shape_gemm;
    libxsmm_bitfield l_flags_brgemm = LIBXSMM_GEMM_FLAGS('N','T');
    libxsmm_bitfield l_prefetch_flags = 0;
    
    libxsmm_gemm_ext_unary_argops l_argops;
    libxsmm_gemm_ext_binary_postops l_postops;
    
    memset( &l_argops, 0, sizeof(libxsmm_gemm_ext_unary_argops) );
    memset( &l_postops, 0, sizeof(libxsmm_gemm_ext_binary_postops) );
    
    
    srand(time(NULL));
    
    libxsmm_blasint l_m = input_m;
    libxsmm_blasint l_n = input_n;
    libxsmm_blasint l_k = input_k;
    
    libxsmm_blasint l_lda = i_lda;
    libxsmm_blasint l_ldb = i_ldb;
    libxsmm_blasint l_ldc = i_ldc;
    
    l_argops.ldcp = l_ldc;
    l_argops.cp_unary_type  = LIBXSMM_MELTW_TYPE_UNARY_NONE;
    
    printf( "M = %d\n", l_m);
    printf( "N = %d\n", l_n);
    printf( "K = %d\n", l_k);
    printf( "LDA = %d\n", l_lda);
    printf( "LDB = %d\n", l_ldb);
    printf( "LDC = %d\n", l_ldc);
    
    l_shape_gemm = libxsmm_create_gemm_shape(l_m ,
                                             l_n,
                                             l_k,
                                             l_lda,
                                             l_ldb,
                                             l_ldc,
                                             LIBXSMM_DATATYPE_F32,
                                             LIBXSMM_DATATYPE_F32,
                                             LIBXSMM_DATATYPE_F32,
                                             LIBXSMM_DATATYPE_F32 );
    
    libxsmm_gemm_batch_reduce_config l_config;
    l_config.br_type = LIBXSMM_GEMM_BATCH_REDUCE_NONE;
    l_config.br_stride_a_hint = 0;
    l_config.br_stride_b_hint = 0;
    l_config.br_unroll_hint = 0;
    
    libxsmm_xmmfunction l_kernel_forward;
    
    l_kernel_forward.gemm_ext = libxsmm_dispatch_brgemm_ext( l_shape_gemm,
                                                        l_flags_brgemm,
                                                        l_prefetch_flags,
                                                        l_config,
                                                        l_argops,
                                                        l_postops);
    libxsmm_gemm_param l_param;
    memset( &l_param, 0, sizeof(libxsmm_gemm_param));
    float * l_a = (float *) malloc( l_lda * l_k * sizeof(float));
    float * l_b = (float *) malloc( l_k * l_ldb * sizeof(float));
    float * l_c = (float *) malloc( l_n * l_ldc * sizeof(float));
    float * l_c_ref = (float *) malloc( l_n * l_ldc * sizeof(float));
    
    for( int i = 0; i < l_lda *l_k ; i++){
        l_a[i] = (float) drand48();
    }
    for( int i = 0; i < l_k * l_ldb ; i++){
        l_b[i] = (float) drand48();
    }
    for( int i = 0; i < l_n *l_ldc ; i++){
        l_c[i] = (float) drand48();
        l_c_ref[i] = l_c[i];
    }
    
    // compute reference
    gemm_ref_trans(l_a, l_b, l_c_ref, l_m, l_n, l_k, l_lda, l_ldb, l_ldc);
    
    struct timeval l_start;
    struct timeval l_end;
    long seconds;
    long useconds;
    double l_gflops = (double) l_m * l_n * l_k * 2;
    double total_time = 0.0;
    long l_reps = 3000000;
    int l_num_threads = 1;
    
    if(i_reps > 0 ){
        l_reps = i_reps;
    }

    l_param.a.primary = l_a;
    l_param.b.primary = l_b;
    l_param.c.primary = l_c;
    
    l_kernel_forward.gemm( &l_param);
    
    float diff = 0.0;
    for( int l_en = 0; l_en < l_ldc * l_n ; l_en++){
        diff += fabs(l_c[l_en] - l_c_ref[l_en]);
        if( fabs(l_c[l_en] - l_c_ref[l_en]) != 0 ){
            printf("[%d]: %f -- %f \n",l_en, l_c[l_en], l_c_ref[l_en] );
        }
    }
    
    printf( "Absolute error: %f \n", diff );

    dispatch_queue_attr_t l_attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT,
                                                                           QOS_CLASS_USER_INTERACTIVE,
                                                                           0 );
    dispatch_queue_t l_queue = dispatch_queue_create( "gemm_queue",
                                                      l_attr );
    dispatch_group_t l_group = dispatch_group_create();

    l_kernel_forward.gemm( &l_param);
    gettimeofday(&l_start, NULL);
    for( int l_td = 0; l_td < l_num_threads ; l_td++){
        
        dispatch_group_async( l_group,
                              l_queue,
                              ^{
            for( int i = 0 ; i < l_reps ; i++){
               l_kernel_forward.gemm( &l_param);
            }
        } );
    }
    dispatch_group_wait(l_group, DISPATCH_TIME_FOREVER);
    gettimeofday(&l_end, NULL);
    
    seconds = l_end.tv_sec - l_start.tv_sec;
    useconds = l_end.tv_usec - l_start.tv_usec;
    total_time = seconds + useconds/1000000.0;
    
    l_gflops *= l_reps;
    l_gflops *= l_num_threads;
    l_gflops *= 1.0E-9;
    l_gflops /= total_time;
    
    printf( "LIBXSMM:\n");
    printf( "Duration: %f s\n", total_time);
    printf( "GFLOPS  : %f  \n", l_gflops);
    double libxsmm_gflops = l_gflops;
    printf( "Apple Accelerate:\n");
    
    gettimeofday(&l_start, NULL);
    for( int l_td = 0; l_td < l_num_threads ; l_td++){
        
        dispatch_group_async( l_group,
                              l_queue,
                              ^{
            for( int i = 0 ; i< l_reps ; i++){
                 cblas_sgemm( CblasColMajor,
                              CblasNoTrans,
                              CblasTrans,
                              l_m,
                              l_n,
                              l_k,
                              1,
                              l_a,
                              l_lda,
                              l_b,
                              l_ldb,
                              1,
                              l_c,
                              l_ldc );
                
            }
        } );
    }
    dispatch_group_wait(l_group, DISPATCH_TIME_FOREVER);
    gettimeofday(&l_end, NULL);
    
    seconds = l_end.tv_sec - l_start.tv_sec;
    useconds = l_end.tv_usec - l_start.tv_usec;
    total_time = seconds + useconds/1000000.0;
    
    l_gflops = (double) l_m * l_n * l_k * 2;
    l_gflops *= l_reps;
    l_gflops *= l_num_threads;
    l_gflops *= 1.0E-9;
    l_gflops /= total_time;
    double accelerate_gflops = l_gflops;
    
    printf( "Duration: %f s\n", total_time);
    printf( "GFLOPS  : %f  \n", l_gflops);
    printf( "Repetitions: %ld\n", l_reps);
    printf("CSV_DATA_LIB: %d,%d,%d,%f\n", l_m, l_n, l_k, libxsmm_gflops);
    printf("CSV_DATA_APPLE: %d,%d,%d,%f\n", l_m, l_n, l_k, accelerate_gflops);
        
    free(l_a);
    free(l_b);
    free(l_c);
    free(l_c_ref);
    
    sleep(3);
    
    return diff;
}
