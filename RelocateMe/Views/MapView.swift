//
//  MapView.swift
//  RelocateMe
//
//  Created by MidnightChips on 1/15/22.
//

import MapKit
import SwiftUI

struct TestMapView : UIViewControllerRepresentable {
    typealias UIViewControllerType = MapViewController
    //@EnvironmentObject var placeManager: PlacemarkManager
    @Binding var startingLocation: MKPlacemark?
    @Binding var endingLocation: MKPlacemark?
    
    func makeUIViewController(context: Context) -> MapViewController {
        let mapView = MapViewController()
        return mapView
    }
    
    func updateUIViewController(_ mapController: MapViewController, context: Context) {
        mapController.setPoints(startingLocation: startingLocation, endingLocation: endingLocation)
    }
}

