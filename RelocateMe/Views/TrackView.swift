//
//  TrackView.swift
//  RelocateMe
//
//  Created by MidnightChips on 1/12/22.
//

import MapKit
import SwiftUI

struct TrackView: View {
    @EnvironmentObject var envModel: EnviromentModel
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            TestMapView(startingLocation: $envModel.startingLocation, endingLocation: $envModel.endingLocation).ignoresSafeArea(.all)
            
            // Read frame height
            GeometryReader { reader in
                VStack {
                    CardView()
                        .offset(y: reader.frame(in: .global).height - 150)
                        .offset(y: envModel.offset)
                        .gesture(DragGesture().onChanged { value in
                            withAnimation {
                                if value.startLocation.y > reader.frame(in: .global).midX {
                                    if value.translation.height<0, envModel.offset>(-reader.frame(in: .global).height + 150) {
                                        envModel.offset = value.translation.height
                                    }
                                }
                                
                                if value.startLocation.y < reader.frame(in: .global).midX {
                                    if value.translation.height > 0, envModel.offset < 0 {
                                        envModel.offset = (-reader.frame(in: .global).height + 150) + value.translation.height
                                    }
                                }
                            }
                        }.onEnded { value in
                            withAnimation {
                                if value.startLocation.y > reader.frame(in: .global).midX {
                                    if -value.translation.height > reader.frame(in: .global).midX {
                                        envModel.offset = (-reader.frame(in: .global).height + 150)
                                        return
                                    }
                                    
                                    envModel.offset = 0
                                }
                                
                                if value.startLocation.y < reader.frame(in: .global).midX {
                                    if value.translation.height < reader.frame(in: .global).midX {
                                        envModel.offset = (-reader.frame(in: .global).height + 150)
                                        return
                                    }
                                    
                                    envModel.offset = 0
                                }
                            }
                            
                        })
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .sheet(item: $envModel.selectedSheet) { item in
                switch item {
                    case SelectedSheet.About:
                        About()
                    case SelectedSheet.Emulate:
                        EmulateRouteSheet()
                }
            }
            /*.sheet(isPresented: $envModel.showingRouteSheet, content: {
                EmulateRouteSheet()
                About()
            })*/
        }
    }
}



struct TrackView_Previews: PreviewProvider {
    static var previews: some View {
        TrackView()
    }
}
