//
//  OnlyNumbers.swift
//  RelocateMe
//
//  Created by MidnightChips on 1/15/22.
//

import Foundation
class NumbersOnly: ObservableObject {
    @Published var value = "" {
        didSet {
            let filtered = value.filter { $0.isNumber }
            
            if value != filtered {
                value = filtered
            }
        }
    }
}
