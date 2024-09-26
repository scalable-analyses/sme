# MicrobenchmarkApp

## Setup 

1. Clone Repository 
    ```bash
    git clone https://github.com/scalable-analyses/sme.git
    ```
2. Open Xcode
3. Create New Project
4. Choose App Project
5. Select Product Name: Microbenchmark
6. Select Project Location
7. Delete default .swift files
8. Add files from MicrobenchmarkApp to the project, except the Bridging-Header
9. Use the Xcode generated Bridging-Header and copy the Code of the provided Bridging-Header into it
10. Add Apple Clang Custom Compiler Flags: \
-march=v9-a+sme2+sme2p1+sme-f16f16+b16b16+sme-
f64f64
11. Click on build and run