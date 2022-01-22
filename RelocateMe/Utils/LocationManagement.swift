//
//  LocationManagement.swift
//  RelocateMe
//
//  Created by MidnightChips on 1/11/22.
//

import CoreLocation
import Foundation
import SwiftUI

class Locations: ObservableObject {
    @Published var startingLocation: CLLocation? = nil
    @Published var endingLocation: CLLocation? = nil
    
    func getLocations(startingLocation: String, destination: String) {
        getCoordinatesFromAddress(startingLocation, completion: { (location) in
            self.startingLocation = location
        })
        getCoordinatesFromAddress(destination, completion: { (location) in
            self.endingLocation = location
        })
    }
    
    func getCoordinatesFromAddress(_ address: String, completion:@escaping((CLLocation?) -> ())){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, _) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                // handle no location found
                completion(nil)
                return
            }
            completion(location)
            return
        }
    }
}
