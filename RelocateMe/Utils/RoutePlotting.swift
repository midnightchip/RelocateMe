//
//  RoutePlotting.swift
//  RelocateMe
//
//  Created by MidnightChips on 1/11/22.
//

import Foundation
import MapKit

// let speed: Double = 40.0

class RouteCreator: ObservableObject {
    @Published var path: URL?
    
    func createPlist(startingLocation: MKPlacemark, endingLocation: MKPlacemark, fileName: String, speed: Double?, completion: (() -> ())?) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: endingLocation)
        request.transportType = .any
        
        let directions = MKDirections(request: request)
        directions.calculate { response, _ in
            guard let route = response?.routes.first else {
                if let completion = completion {
                    completion()
                }
                return
            }
            self.convertRouteToPlist(route: route, fileName: fileName, speed: speed)
            if let completion = completion {
                completion()
            }
        }
    }
    
    func startEmulationScenario() {
        if let path = path {
            startScenarioSim(path: path)
        }
    }
    
    private func convertRouteToPlist(route: MKRoute, fileName: String, speed: Double?) {
        let polyCoordinates = route.polyline.coordinates
        
        let totalTime = route.distance / (speed ?? 1)
        let requiredPolySpeed = Double(polyCoordinates.count) / totalTime // Points per second
        
        let startingDate = Date()
        let coordinates = polyCoordinates.enumerated().map { index, coordinate -> Data in
            var course = 0.0
            if index < polyCoordinates.count - 1, index > 0 {
                let previousCoor = polyCoordinates[index - 1]
                
                let diffLat = coordinate.latitude - previousCoor.latitude / Double(polyCoordinates.count)
                let diffLon = coordinate.longitude - previousCoor.longitude / Double(polyCoordinates.count)
                
                let nextLat = previousCoor.latitude + (diffLat * Double(index + 1))
                let nextLon = previousCoor.longitude + (diffLon * Double(index + 1))
                
                let y = sin(deg2Rad(nextLon) - deg2Rad(diffLon)) * cos(deg2Rad(nextLat))
                let x = (cos(deg2Rad(coordinate.latitude)) * sin(deg2Rad(nextLat))) - (sin(deg2Rad(coordinate.latitude)) * cos(deg2Rad(nextLat)) * cos(deg2Rad(nextLon) - deg2Rad(coordinate.longitude)))
                course = fmod(rad2Deg(atan2(y, x)) + 360, 360.0)
            }
            let pointDate = calculatePointDate(startingDate: startingDate, distancePoint: index, speed: requiredPolySpeed)
            return encodeLocation(lat: coordinate.latitude, lon: coordinate.longitude, course: course, speed: requiredPolySpeed, timeStamp: pointDate)
        }
        let saveFile: NSDictionary = ["Locations": coordinates, "Options": ["LocationDeliveryBehavior": 2, "LocationRepeatBehavior": 0]]
        path = getDocumentsDirectory(fileName: "\(fileName).plist")
        if let path = path {
            try? saveFile.write(to: path)
            print("Saved \(path)")
        }
    }
    
    private func calculatePointDate(startingDate: Date, distancePoint: Int, speed: Double = 10) -> String {
        let timeOffset = TimeInterval(Double(distancePoint) / (speed > 0.0 ? speed : 1.0)) //  index(distance) / speed = time
        return String(startingDate.advanced(by: timeOffset).timeIntervalSince1970)
    }
    
    private func getDocumentsDirectory(fileName: String) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var documentsDirectory = paths[0]
        documentsDirectory.appendPathComponent(fileName)
        return documentsDirectory
    }
    
    private func encodeLocation(lat: Double, lon: Double, course: Double, speed: Double?, timeStamp: String) -> Data {
        var archivedLoc = String(CLLOCATION_BASE)
        archivedLoc = archivedLoc.replacingOccurrences(of: "ALTPLACE", with: "0")
        archivedLoc = archivedLoc.replacingOccurrences(of: "LATPLACE", with: String(lat))
        archivedLoc = archivedLoc.replacingOccurrences(of: "LONGPLACE", with: String(lon))
        archivedLoc = archivedLoc.replacingOccurrences(of: "COURSEPLACE", with: String(course))
        archivedLoc = archivedLoc.replacingOccurrences(of: "HORZACPLACE", with: "0.0")
        archivedLoc = archivedLoc.replacingOccurrences(of: "LIFESPAPLACE", with: "30.0")
        archivedLoc = archivedLoc.replacingOccurrences(of: "SPEEDPLACE", with: speed != nil ? String(speed!) : "inf")
        archivedLoc = archivedLoc.replacingOccurrences(of: "TIMESTAMPPLACE", with: timeStamp)
        archivedLoc = archivedLoc.replacingOccurrences(of: "TYPEPLACE", with: "1")
        archivedLoc = archivedLoc.replacingOccurrences(of: "VERTACPLACE", with: "0")
        
        return archivedLoc.data(using: .utf8) ?? Data()
    }
    
    private func calcDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let sourceLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let destinationLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return destinationLocation.distance(from: sourceLocation)
    }
}
