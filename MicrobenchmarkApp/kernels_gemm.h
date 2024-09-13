extern "C" {
  void gemm_micro_64_16_2( float const * i_a,
                           float const * i_b,
                           float       * io_c );

  void gemm_micro_32_32_32( float const * i_a,
                            float const * i_b,
                            float       * io_c );

  void gemm_micro_31_32_32( float const * i_a,
                            float const * i_b,
                            float       * io_c );

  void gemm_micro_32_no_trans( float const * i_a,
                               float const * i_b,
                               float       * io_c );
  void gemm_128_128_128( float const * i_a,
                         float const * i_b,
                         float       * io_c );
}