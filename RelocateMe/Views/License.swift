//
//  License.swift
//  RelocateMe
//
//  Created by MidnightChips on 1/20/22.
//

import SwiftUI

struct LicenseView: View {
    @ObservedObject var model = Model()
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                Text(model.data)
                    .multilineTextAlignment(.leading)
                    
            }
        }.padding()
            .navigationBarTitle("License")
    }
}

class Model: ObservableObject {
    @Published var data: String = ""
    init() { self.load(file: "LICENSE") }
    func load(file: String) {
        if let filepath = Bundle.main.path(forResource: file, ofType: "") {
            do {
                let contents = try String(contentsOfFile: filepath)
                DispatchQueue.main.async {
                    self.data = contents
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("File not found")
        }
    }
}
