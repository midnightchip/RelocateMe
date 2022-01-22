//
//  MapViewController.swift
//  RelocateMe
//
//  Created by MidnightChips on 1/18/22.
//

import MapKit
import UIKit

class MapViewController: UIViewController {
    private let mapView = MKMapView(frame: .zero)
    private let locationManager = CLLocationManager()
    private var startingLocation: MKPlacemark?
    private var endingLocation: MKPlacemark?
    //private var loadingView = UIActivityIndicatorView(frame: .zero)
    var route: MKRoute?

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        checkLocationServices()
    }

    private func layoutUI() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        view.addSubview(mapView)
        //view.addSubview(loadingView)
        //loadingView.hidesWhenStopped = true
        /*loadingView.isHidden = false
        loadingView.style = .large
        loadingView.backgroundColor = .green*/
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        /*NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])*/
        
    }

    private func centerViewOnUser() {
        guard let location = locationManager.location?.coordinate else { return }
        centerViewOnCoordinate(location: location)
    }

    private func centerViewOnCoordinate(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        mapView.setRegion(coordinateRegion, animated: true)
    }

    func setPoints(startingLocation: MKPlacemark?, endingLocation: MKPlacemark?) {
        var shouldUpdate = false
        // Hey man, I heard you like if statements, so I added if statements to your if statments.
        if let startingLocation = startingLocation {
            if startingLocation != self.startingLocation {
                self.startingLocation = startingLocation
                shouldUpdate = true
            }
        }

        if let endingLocation = endingLocation {
            if endingLocation != self.endingLocation {
                self.endingLocation = endingLocation
                shouldUpdate = true
            }
        }
        
        if startingLocation == nil && endingLocation == nil {
            self.endingLocation = nil
            self.startingLocation = nil
            clearMap()
        }
        
        if shouldUpdate {
            plotDirections()
        }
    }
    
    private func clearMap() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
    }

    private func plotDirections() {
        clearMap()

        if endingLocation == nil {
            if let startingLocation = startingLocation {
                mapView.addAnnotation(startingLocation)
                centerViewOnCoordinate(location: startingLocation.coordinate)
            }
            return
        }

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation ?? MKPlacemark())
        request.destination = MKMapItem(placemark: endingLocation ?? MKPlacemark())
        request.transportType = .any
        
        //loadingView.startAnimating()
        let directions = MKDirections(request: request)
        directions.calculate { response, _ in
            guard let route = response?.routes.first else { return }
            self.route = route
            self.mapView.addAnnotations([self.startingLocation ?? MKPlacemark(), self.endingLocation ?? MKPlacemark()])
            self.mapView.addOverlay(route.polyline)
            self.mapView.setVisibleMapRect(
                route.polyline.boundingMapRect,
                edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                animated: true)
            //self.loadingView.stopAnimating()
        }
    }
    
    

    // MARK: - Location Services

    private func checkLocationServices() {
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        checkAuthorizationForLocation()
    }

    private func checkAuthorizationForLocation() {
        switch locationManager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                mapView.showsUserLocation = true
                centerViewOnUser()
                locationManager.startUpdatingLocation()
            case .denied:
                // Here we must tell user how to turn on location on device
                break
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                // Here we must tell user that the app is not authorize to use location services
                break
            @unknown default:
                break
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorizationForLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        var coordinateRegion = mapView.region//MKCoordinateRegion(center: location.coordinate,
                                                  //span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        coordinateRegion.center = location.coordinate
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .systemBlue
        renderer.lineWidth = 5
        return renderer
    }
}
