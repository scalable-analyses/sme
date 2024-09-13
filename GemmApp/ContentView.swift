import SwiftUI

struct ContentView: View {

    @State private var M: String = ""
    @State private var N: String = ""
    @State private var K: String = ""
    @State private var LDA: String = ""
    @State private var LDB: String = ""
    @State private var LDC: String = ""
    @State private var b_transposed = false
    @State private var repetitions: String = ""
    @State private var result: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter M", text: $M).textFieldStyle(RoundedBorderTextFieldStyle()).keyboardType(.numberPad).frame(width: 200)
            TextField("Enter N", text: $N).textFieldStyle(RoundedBorderTextFieldStyle()).keyboardType(.numberPad).frame(width: 200)
            TextField("Enter K", text: $K).textFieldStyle(RoundedBorderTextFieldStyle()).keyboardType(.numberPad).frame(width: 200)
            TextField("Enter LDA", text: $LDA).textFieldStyle(RoundedBorderTextFieldStyle()).keyboardType(.numberPad).frame(width: 200)
            TextField("Enter LDB", text: $LDB).textFieldStyle(RoundedBorderTextFieldStyle()).keyboardType(.numberPad).frame(width: 200)
            TextField("Enter LDC", text: $LDC).textFieldStyle(RoundedBorderTextFieldStyle()).keyboardType(.numberPad).frame(width: 200)
            TextField("Enter number of repetitions", text: $repetitions).textFieldStyle(RoundedBorderTextFieldStyle()).keyboardType(.numberPad).frame(width: 200)
            Toggle(isOn: $b_transposed) {
                    Text("Matrix B is transposed")
                }.padding(.trailing)
                .frame(width: 200)

            Button(action: {
                runUIBenchmark()
            }) {
                Text("Start your config")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            Button(action: {
                runGeneralBenchmark()
            }) {
                Text("Start GEMM Benchmark")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Text(result)
                .padding()
                .foregroundColor(.red)
        }
        .padding()
    }
    
    func runGeneralBenchmark(){
        var compute_error = 0
        for counter in 1...128 {
            if (b_transposed){
                compute_error = Int( gemm_b_transpose( Int32(counter),
                                                       Int32(counter),
                                                       512,
                                                       128,
                                                       512,
                                                       128,
                                                       -1))
            } else {
                compute_error = Int( gemm_normal( Int32(counter),
                                                  Int32(counter),
                                                  512,
                                                  128,
                                                  512,
                                                  128,
                                                  -1))
            }
            
            if compute_error != 0 {
                print("*** ERROR ***")
                break
            }
            print( counter )
        }
    }
    

    func runUIBenchmark() {
        guard let mValue = Int32(M), 
              let nValue = Int32(N), 
              let kValue = Int32(K),
              let ldaValue = Int32(LDA), 
              let ldbValue = Int32(LDB), 
              let ldcValue = Int32(LDC),
              let repetitionCount = Int32(repetitions) else {
            result = "Please enter valid values for all fields."
            return
        }
        result = ""
        if (b_transposed) {
            gemm_b_transpose(mValue,
                             nValue,
                             kValue,
                             ldaValue,
                             ldbValue,
                             ldcValue,
                             repetitionCount)
        } else {
            gemm_normal( mValue,
                         nValue,
                         kValue,
                         ldaValue,
                         ldbValue,
                         ldcValue,
                         repetitionCount)
        }
    }
}

