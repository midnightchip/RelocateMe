//
//  CardView.swift
//  RelocateMe
//
//  Created by MidnightChips on 1/19/22.
//

import SwiftUI

struct CardView: View {
    @EnvironmentObject var envModel: EnviromentModel
    
    var body: some View {
        VStack(spacing: 10){
            Capsule()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 50, height: 5)
                .padding(.top)
                .padding(.bottom, 5)
            
            VStack(alignment: .leading) {
                if !envModel.isValid {
                    Text("Invalid License, please repair in settings!")
                        .font(.largeTitle.bold())
                        .foregroundColor(.red)
                        .padding()
                        .multilineTextAlignment(.center)
                }
                if envModel.searchingText {
                    AddressLookup(selectedAddress: $envModel.startingLocation, isSelected: true, needCancel: true, cancelCallback: {
                        withAnimation {
                            envModel.searchingText = false
                        }
                        
                    }, selectedCallback: {
                        withAnimation {
                            envModel.offset = -UIScreen.main.bounds.height * 0.15
                            envModel.searchingText = false
                        }
                    })
                } else if envModel.searchingDestination {
                    AddressLookup(selectedAddress: $envModel.endingLocation, isSelected: true, needCancel: true, cancelCallback: {
                        envModel.searchingDestination = false
                    }, selectedCallback: {
                        withAnimation {
                            envModel.offset = -UIScreen.main.bounds.height * 0.15
                            envModel.searchingDestination = false
                        }
                    })
                } else {
                    SearchBar(text: .constant(""), startEditing: {
                        withAnimation {
                            envModel.offset = -UIScreen.main.bounds.height * 0.75
                            envModel.searchingText = true
                        }
                    }, placeholder: "Enter an Address")
                    
                    if envModel.startingLocation != nil {
                        withAnimation {
                            ActionView()
                        }
                        
                    }
                    
                    LargeButton(title: "Force Stop Emulation", backgroundColor: .red) {
                        print("Force Stop")
                        envModel.isSpoofing = false
                        envModel.endingLocation = nil
                        envModel.startingLocation = nil
                        stopLocSim()
                        forceStopSim()
                    }
                    // TODO Add about section, add reset cache
                    LargeButton(title: "About", backgroundColor: .accentColor) {
                        print("Show info")
                        envModel.selectedSheet = .About
                    }
                    Spacer()
                }
            }
            .frame(maxHeight: .infinity)
        }
        .background(BlurView(style: .systemMaterial).background(envModel.isValid ? Color.clear : Color.red))
        .cornerRadius(15)
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
