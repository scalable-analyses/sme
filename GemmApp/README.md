# GemmApp

## Setup LIBXSMM

1. Clone Repository
    ```bash
    git clone https://github.com/stefan0re/libxsmm.git
    ```

2. Checkout the SME branch
    ```bash
    cd libxsmm
    git checkout m4_sme
    ```

3. Copy two files from GemmApp to the LIBXSMM root directory:
    - iOS.cmake
    - patchIOS

4. Set the CMAKE IOS SDK ROOT variable in the iOS.cmake file to your SDK path

5. Apply patch
    ```bash
    git apply patchIOS
    ```

6. Create build folder
    ```bash
    cmake . -B build_ios
    cd build_ios
    ```

7. Build static library
    ```bash
    make -j BLAS=0
    ```


## Setup GemmApp

1. Clone Repository 
    ```bash
    git clone https://github.com/scalable-analyses/sme.git
    ```
2. Open Xcode
3. Create New Project
4. Choose App Project
5. Select Product Name: GemmApp
6. Select project location
7. Delete default .swift files
8. Add files from GemmApp to the project, except the Bridging-Header
9. Use the Xcode generated Bridging-Header and copy the Code of the provided Bridging-Header into it
10. Build LIBXSMM
11. Set Build Settings:
    - Header Search Path: /path/to/libxsmm/inlcude/
    - Library Search Path: /path/to/libxsmm/build_ios
12. Set Build Phases:
    - Link Binary With Libraries: Add libxmm.a
13. Click build and run