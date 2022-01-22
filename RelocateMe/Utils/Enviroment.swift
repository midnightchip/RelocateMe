//
//  Enviroment.swift
//  RelocateMe
//
//  Created by MidnightChips on 1/19/22.
//

import Foundation
import MapKit

class EnviromentModel: ObservableObject {
    @Published var isSpoofing: Bool = false
    @Published var searchingText: Bool = false
    @Published var searchingDestination: Bool = false
    @Published var startingLocation: MKPlacemark? = nil
    @Published var endingLocation: MKPlacemark? = nil
    @Published var selectedSheet: SelectedSheet? = nil
    @Published var offset: CGFloat = 0.0
    @Published var isValid = true
    @Published var error: Error? = nil
}
