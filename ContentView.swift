import SwiftUI

struct ContentView: View {
  @State private var is_loading = false
  @State private var bench_type = 0
  @State private var num_threads = 1
  @State private var qos = 1
  @State private var check = 0
  @State private var showcase = 0

  var body: some View {
    VStack() {
      Text("M4 Benchmarks")
        .font(.title)
        .padding()

      Link( "https://scalable.uni-jena.de/opt/sme/",
            destination: URL(string: "https://scalable.uni-jena.de/opt/sme/")! )
        .font(.subheadline)

      List {
        Picker("Benchmark Type", selection: $bench_type) {
          Text("Micro").tag(0)
          Text("CBLAS").tag(1)
          Text("Bandwidth").tag(2)
          Text("Check").tag(3)
          Text("GEMM").tag(4)
          Text("Showcase").tag(5)
        }

        if( bench_type == 0 || bench_type == 4 ) {
          Picker("Number of Threads", selection: $num_threads) {
            ForEach(1..<7) {
              Text("\($0)").tag($0)
            }
          }
          Picker("Quality of Service", selection: $qos) {
            Text("Default").tag(0)
            Text("User Interactive").tag(1)
            Text("User Initiated").tag(2)
            Text("Utility").tag(3)
            Text("Background").tag(4)
          }
        }

        if( bench_type == 3 ) {
          Picker("Check", selection: $check) {
            Text("SVE").tag(0)
            Text("Streaming SVE").tag(1)
            Text("SME").tag(2)
            Text("SVE Streaming Vector Length").tag(3)
            Text("Neon BF16").tag(4)
          }
        }
        if( bench_type == 5 ) {
          Picker( "Showcase", selection: $showcase ) {
            Text("FP32 FMOPA").tag(0)
            Text("BF16-BF16-FP32 BFMOPA").tag(1)
            Text("FP32 ZIP 4").tag(2)
          }
        }
      }

      Button( "Run Benchmark" ) {
        is_loading = true

        DispatchQueue.global(qos: .userInitiated).async {
          if( bench_type == 0 ) {
            run_micro_benchmark( Int32(num_threads),
                                 Int32(qos) )
          }
          else if( bench_type == 1 ) {
            run_cblas_benchmark()
          }
          else if( bench_type == 2 ) {
            run_bandwidth_benchmark()
          }
          else if( bench_type == 3 ) {
            if( check == 0 ) {
              check_sve_support()
            }
            else if( check == 1 ) {
              check_streaming_sve_support()
            }
            else if( check == 2 ) {
              check_sme_support()
            }
            else if( check == 3 ) {
              check_sve_streaming_length()
            }
            else if( check == 4 ) {
              check_neon_bf16_support()
            }
          }
          else if( bench_type == 4 ) {
            run_gemm( Int32(num_threads),
                      Int32(qos) )
            run_gemm2()
          }
          else if( bench_type == 5 ) {
            if( showcase == 0 ) {
              showcase_fmopa_fp32_fp32_fp32()
            }
            else if( showcase == 1 ) {
              showcase_bfmopa_bf16_bf16_fp32()
            }
            else if( showcase == 2 ) {
              showcase_zip4_fp32()
            }
          }

          DispatchQueue.main.async {
            is_loading = false  // Hide loading indicator
          }
        }
      }
      .padding()
      .background( Color.blue )
      .foregroundColor( Color.white )
      .cornerRadius( 10 )

      if is_loading {
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle())
          .scaleEffect( 1.5 )
          .padding()
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}