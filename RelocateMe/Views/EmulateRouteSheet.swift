//
//  EmulateRouteSheet.swift
//  RelocateMe
//
//  Created by MidnightChips on 1/15/22.
//

import CoreLocation
import MapKit
import SwiftUI

struct EmulateRouteSheet: View {
    @EnvironmentObject var envModel: EnviromentModel
    @ObservedObject var input = NumbersOnly()
    @ObservedObject var routeCreator = RouteCreator()
    @State var selectedUnit = "mph"
    @State var buttonClicked = false
    private let measures = ["mph", "km/h"]
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Speed", text: $input.value)
                        .padding()
                        .keyboardType(.decimalPad)
                    Picker(selectedUnit, selection: $selectedUnit) {
                        ForEach(measures, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                }
                Text("Speed at which the the emulated location moves along the route. Leave empty for default.")
                    .font(.caption)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.leading)
                    .opacity(0.5)
                Spacer()
                LargeButton(title: "Begin Emulation", backgroundColor: .accentColor) {
                    buttonClicked = true
                    let speed = calculateSpeed()
                    print("SELECTED SPEED \(speed)")
                    /* let plistPath = convertRouteToPlist(route: route, fileName: String(Date().timeIntervalSince1970), speed: speed)
                     startScenarioSim(path: plistPath) */
                    guard let startingLocation = envModel.startingLocation, let endingLocation = envModel.endingLocation else {
                        print("Values are Nil")
                        envModel.selectedSheet = nil
                        return
                    }
                    routeCreator.createPlist(startingLocation: startingLocation, endingLocation: endingLocation, fileName: String(Date().timeIntervalSince1970), speed: speed) {
                        routeCreator.startEmulationScenario()
                        envModel.isSpoofing = true
                        envModel.selectedSheet = nil
                        withAnimation {
                            envModel.offset = -UIScreen.main.bounds.height * 0.15
                        }
                    }
                }
                .padding()
                if buttonClicked {
                    withAnimation {
                        ProgressView().scaleEffect(1.0, anchor: .center).progressViewStyle(.circular)
                    }
                }
                Spacer()
                Spacer()
            }.padding()
                .navigationTitle("Speed of Route")
                .navigationBarItems(trailing:
                    Button(action: {
                        envModel.selectedSheet = nil
                    }) {
                        Text("Cancel")
                    }
                )
        }
    }

    private func calculateSpeed() -> Double {
        if selectedUnit == "mph" {
            print("SELECTED MPH, existing value = \(input.value), result = \((Double(input.value) ?? 0) / 2.237)")
            return (Double(input.value) ?? 0) / 2.237
        } else {
            return (Double(input.value) ?? 0) / 3.6
        }
    }
}
