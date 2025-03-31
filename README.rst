Hello SME!
==========

This repository contains our code to benchmark a 2024 11-inch iPad Pro Wi-Fi 1 TB.
The iPad comes with Apple's M4 SoC which was the first publicly available silicon supporting Arm's Scalable Matrix Extension (SME).
The directory ``MicrobenchmarkApp/`` contains an iOS app which executes microbenchmarks about compute and memory performance of the CPU.
The iOS app in the directory ``GemmApp/``, can be used to benchmark two GEMM implementations, comparing a JIT-based approach to a vendor library.
Both applications were used to generate the results presented in our paper `Hello SME! <https://dl.acm.org/doi/10.1109/SCW63240.2024.00185>`_.

The M4 chip is now not only used in the iPad, but also in desktop and laptop systems such as the Mac mini and the MacBook.
In the meantime we have upstreamed the SME capabilities to the just-in-time code generation of tensor processing primitives in the open-source library `LIBXSMM <https://github.com/libxsmm/libxsmm>`__.
It's just a few terminal commands if you want to try out the code:

.. code-block:: bash
  :linenos:

  git clone https://github.com/libxsmm/libxsmm.git
  cd libxsmm
  make -j BLAS=0

  cd samples/xgemm
  make -j

  ./gemm_kernel F32 F32 F32 F32 512 512 512 512 512 512 1 1 0 0 0 0 0 0 0 nopf nobr 0 1 10000 0
  ./gemm_kernel F32 F32 F32 F32 512 512 512 512 512 512 1 1 0 0 0 1 0 0 0 nopf nobr 0 1 10000 0
  # for other setting just run ./gemm_kernel

The two examples in lines 8 and 9 execute GEMMs where all matrix sizes are set to 512.
The first example in line 8 computes C = A x B and reaches about 1755 FP32 GFLOPS on M4:

.. code-block:: none
  :linenos:

  ------------------------------------------------
  RUNNING (512x512) X (512x512) = (512x512)
  a:F32, b:F32, comp:F32, c:F32, BR=1
  ------------------------------------------------
  function pointer address: 10079c000
  0.000071s for creating jit

  Printing Norms:
  L1 reference  : 487176.6939176287269219756
  L1 test       : 487176.6939176287269219756
  L2 abs.error  : 0.000000000000000000000000
  L2 rel.error  : 0.000000000000000000000000
  Linf abs.error: 0.000000000000000000000000
  Linf rel.error: 0.000000000000000000000000
  Check-norm    : 0.000000000000000000000000

  1.529381s for libxsmm
  1755.189780 GFLOPS for libxsmm
  max. error: 0.000000
  ------------------------------------------------


  Total Max Error 0.000000

The second example in line 9 computes C += A x B^T and reaches about 1833 GFLOPS on M4:

.. code-block:: none
  :linenos:

  ------------------------------------------------
  RUNNING (512x512) X (512x512)^T = (512x512)
  a:F32, b:F32, comp:F32, c:F32, BR=1
  ------------------------------------------------
  function pointer address: 100aec000
  0.000063s for creating jit

  Printing Norms:
  L1 reference  : 486134.3142449855804443359
  L1 test       : 486134.3142449855804443359
  L2 abs.error  : 0.000000000000000000000000
  L2 rel.error  : 0.000000000000000000000000
  Linf abs.error: 0.000000000000000000000000
  Linf rel.error: 0.000000000000000000000000
  Check-norm    : 0.000000000000000000000000

  1.463767s for libxsmm
  1833.867522 GFLOPS for libxsmm
  max. error: 0.000000
  ------------------------------------------------


  Total Max Error 0.000000