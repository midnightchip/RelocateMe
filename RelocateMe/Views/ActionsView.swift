//
//  ActionsView.swift
//  RelocateMe
//
//  Created by MidnightChips on 1/19/22.
//

import SwiftUI
import MapKit

struct ActionView: View {
    @EnvironmentObject var envModel: EnviromentModel
    var body: some View {
        VStack {
            Divider()
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    Spacer()
                    RoundedButton(action: {
                        if envModel.startingLocation == nil {
                            withAnimation {
                                envModel.offset = -UIScreen.main.bounds.height * 0.75
                                envModel.searchingText = true
                            }
                        } else {
                            print("Start spoofing yo")
                            guard let startingLocation = envModel.startingLocation else {
                                return
                            }
                            
                            if !envModel.isSpoofing {
                                envModel.isSpoofing = true
                                startLocationSim(loc: startingLocation.location ?? CLLocation())
                            } else {
                                stopLocSim()
                                envModel.isSpoofing = false
                            }
                        }
                    }, imageName: "location.fill", text: envModel.isSpoofing ? "Stop Emulation" : "Emulate Location", foregroundColor: .white, backgroundColor: .accentColor, secondaryBackgroundColor: .red, isClicked: $envModel.isSpoofing)
                    
                    if envModel.startingLocation != nil, envModel.endingLocation != nil, !envModel.isSpoofing {
                        withAnimation {
                            RoundedButton(action: {
                                envModel.selectedSheet = .Emulate
                                print("CLICKED")
                            }, imageName: "figure.walk", text: "Emulate Route", foregroundColor: .accentColor, backgroundColor: Color(UIColor.systemBackground))
                        }
                    }
                    
                    RoundedButton(action: {
                        withAnimation {
                            envModel.offset = -UIScreen.main.bounds.height * 0.75
                            envModel.searchingDestination.toggle()
                        }
                    }, imageName: "point.topleft.down.curvedto.point.bottomright.up", text: envModel.endingLocation == nil ? "Add Destination" : "Change Destination", foregroundColor: .accentColor, backgroundColor: Color(UIColor.systemBackground))
                    
                    RoundedButton(action: {
                        withAnimation {
                            envModel.endingLocation = nil
                            envModel.startingLocation = nil
                            stopLocSim()
                        }
                    }, imageName: "xmark", text: "Clear Locations", foregroundColor: .accentColor, backgroundColor: Color(UIColor.systemBackground))
                }
            }
            Divider()
        }
    }
    
}
