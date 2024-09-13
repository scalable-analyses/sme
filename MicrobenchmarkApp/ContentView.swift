import SwiftUI

enum BenchType {
  case micro
  case cblas
  case bandwidth
  case check
  case gemm
  case showcase
}

enum BandwidthKernel: Int32 {
  case ldr_z            = 0
  case ld1w_z_1         = 1
  case ld1w_z_2         = 2
  case ld1w_z_4         = 3
  case ld1w_z_strided_2 = 4
  case ld1w_z_strided_4 = 5
  case ldr_za           = 6
  case str_z            = 7
  case st1w_z_1         = 8
  case st1w_z_2         = 9
  case st1w_z_4         = 10
  case st1w_z_strided_2 = 11
  case st1w_z_strided_4 = 12
  case str_za           = 13
}

enum QoS: Int32 {
  case default_qos      = 0
  case user_interactive = 1
  case user_initiated   = 2
  case utility          = 3
  case background       = 4
}

enum CheckType {
  case sve
  case streaming_sve
  case sme
  case sve_streaming_length
  case neon_bf16
}

enum ShowcaseType {
  case fp32_fmopa
  case bf16_bf16_fp32_bfmopa
  case fp32_zip4
  case ld1w_2_pred
}

struct ContentView: View {
  @State private var is_loading = false
  @State private var bench_type = BenchType.micro
  @State private var bandwidth_kernel = [BandwidthKernel.ldr_z]
  @State private var align_bytes = [128]
  @State private var num_threads = 1
  @State private var qos = QoS.user_interactive
  @State private var check_type = CheckType.sme
  @State private var showcase_type = ShowcaseType.fp32_fmopa

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
          Text("Micro").tag(       BenchType.micro     )
          Text("CBLAS").tag(       BenchType.cblas     )
          Text("Bandwidth").tag(   BenchType.bandwidth )
          Text("Check").tag(       BenchType.check     )
          Text("GEMM").tag(        BenchType.gemm      )
          Text("Showcase").tag(    BenchType.showcase  )
        }

        if( bench_type == BenchType.micro || bench_type == BenchType.gemm ) {
          Picker("Number of Threads", selection: $num_threads) {
            ForEach(1..<21) {
              Text("\($0)").tag($0)
            }
          }
          Picker("Quality of Service", selection: $qos) {
            Text("Default").tag(          QoS.default_qos      )
            Text("User Interactive").tag( QoS.user_interactive )
            Text("User Initiated").tag(   QoS.user_initiated   )
            Text("Utility").tag(          QoS.utility          )
            Text("Background").tag(       QoS.background       )
          }
        }

        if( bench_type == BenchType.bandwidth ) {
          VStack {
            ForEach([BandwidthKernel.ldr_z,
                     BandwidthKernel.ld1w_z_1,
                     BandwidthKernel.ld1w_z_2,
                     BandwidthKernel.ld1w_z_4,
                     BandwidthKernel.ld1w_z_strided_2,
                     BandwidthKernel.ld1w_z_strided_4,
                     BandwidthKernel.ldr_za,
                     BandwidthKernel.str_z,
                     BandwidthKernel.st1w_z_1,
                     BandwidthKernel.st1w_z_2,
                     BandwidthKernel.st1w_z_4,
                     BandwidthKernel.st1w_z_strided_2,
                     BandwidthKernel.st1w_z_strided_4,
                     BandwidthKernel.str_za], id: \.self) { kernel in
              Toggle("\(kernel)", isOn: Binding(
                get: { bandwidth_kernel.contains(kernel) },
                set: { isOn in
                  if isOn {
                    bandwidth_kernel.append(kernel)
                  } else {
                    bandwidth_kernel.removeAll(where: { $0 == kernel })
                  }
                }
              ))
            }
          }
          VStack {
            ForEach([1, 2, 4, 8, 16, 32, 64, 128], id: \.self) { alignment in
              Toggle("\(alignment) byte Alignment", isOn: Binding(
                get: { align_bytes.contains(alignment) },
                set: { isOn in
                  if isOn {
                    align_bytes.append(alignment)
                  } else {
                    align_bytes.removeAll(where: { $0 == alignment })
                  }
                }
              ))
            }
          }
          Picker("Quality of Service", selection: $qos) {
            Text("Default").tag(          QoS.default_qos      )
            Text("User Interactive").tag( QoS.user_interactive )
            Text("User Initiated").tag(   QoS.user_initiated   )
            Text("Utility").tag(          QoS.utility          )
            Text("Background").tag(       QoS.background       )
          }
        }

        if( bench_type == BenchType.check ) {
          Picker("Check", selection: $check_type) {
            Text("SVE").tag(                         CheckType.sve                  )
            Text("Streaming SVE").tag(               CheckType.streaming_sve        )
            Text("SME").tag(                         CheckType.sme                  )
            Text("SVE Streaming Vector Length").tag( CheckType.sve_streaming_length )
            Text("Neon BF16").tag(                   CheckType.neon_bf16            )
          }
        }
        if( bench_type == BenchType.showcase ) {
          Picker( "Showcase", selection: $showcase_type ) {
            Text("FP32 FMOPA").tag(                    ShowcaseType.fp32_fmopa            )
            Text("BF16-BF16-FP32 BFMOPA").tag(         ShowcaseType.bf16_bf16_fp32_bfmopa )
            Text("FP32 ZIP4").tag(                     ShowcaseType.fp32_zip4             )
            Text("LD1W, 2 Registers, Predicated").tag( ShowcaseType.ld1w_2_pred           )
          }
        }
      }

      Button( "Run Benchmark" ) {
        is_loading = true

        DispatchQueue.global(qos: .userInitiated).async {
          if( bench_type == BenchType.micro ) {
            run_micro_benchmark( Int32(num_threads),
                                 qos.rawValue )
          }
          else if( bench_type == BenchType.cblas ) {
            run_cblas_benchmark()
          }
          else if( bench_type == BenchType.bandwidth ) {
            for al in align_bytes {
              for kernel in bandwidth_kernel {
                run_bandwidth_benchmark( Int32(kernel.rawValue),
                                         Int32(al),
                                         qos.rawValue )
              }
            }
          }
          else if( bench_type == BenchType.check ) {
            if( check_type == CheckType.sve ) {
              check_sve_support()
            }
            else if( check_type == CheckType.streaming_sve ) {
              check_streaming_sve_support()
            }
            else if( check_type == CheckType.sme ) {
              check_sme_support()
            }
            else if( check_type == CheckType.sve_streaming_length ) {
              check_sve_streaming_length()
            }
            else if( check_type == CheckType.neon_bf16 ) {
              check_neon_bf16_support()
            }
          }
          else if( bench_type == BenchType.gemm ) {
            run_gemm( Int32(num_threads),
                      qos.rawValue )
          }
          else if( bench_type == BenchType.showcase ) {
            if( showcase_type == ShowcaseType.fp32_fmopa ) {
              showcase_fmopa_fp32_fp32_fp32()
            }
            else if( showcase_type == ShowcaseType.bf16_bf16_fp32_bfmopa ) {
              showcase_bfmopa_bf16_bf16_fp32()
            }
            else if( showcase_type == ShowcaseType.fp32_zip4 ) {
              showcase_zip4_fp32()
            }
            else if( showcase_type == ShowcaseType.ld1w_2_pred ) {
              showcase_ld1w_2_pred()
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
