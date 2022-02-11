//
//  ContentView.swift
//  RelocateMe
//
//  Created by MidnightChips on 1/10/22.
//

import SwiftUI

struct ContentView: View {
    @State private var animate: Bool = false
    @State private var showSplash: Bool = true
    @State private var showImage: Bool = false
    @EnvironmentObject var envModel: EnviromentModel
    let backgroundColor = UIColor(red: 0.04, green: 0.39, blue: 0.47, alpha: 1.00)
    var body: some View {
        ZStack {
            // Content
            TrackView().tabItem {
                Label("Plot Route", systemImage: "point.topleft.down.curvedto.point.bottomright.up")
            }

            // Splash
            ZStack {
                Color(backgroundColor)

                Image("globe")
                    .renderingMode(.template)
                    .foregroundColor(.white)
                    .overlay(
                        Image("pin")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                            .offset(x: animate ? 0 : -45, y: animate ? -120 : -110)
                            .rotationEffect(.degrees(animate ? 0 : -15))
                    )
                    .opacity(showImage ? 1 : 0)
            }
            .ignoresSafeArea()
            .opacity(showSplash ? 1 : 0)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                withAnimation {
                    showImage.toggle()
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeInOut(duration: 0.4)) {
                    animate.toggle()
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    showSplash.toggle()
                }
                Validate().verify { res, err in
                    DispatchQueue.main.async {
                        envModel.isValid = res
                        envModel.error = err
                    }
                }
            }
        }
    }
}
