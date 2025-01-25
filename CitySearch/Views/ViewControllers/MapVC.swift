//
//  Untitled.swift
//  CitySearch
//
//  Created by Mohit Kumar on 21/01/25.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Map"
        view.backgroundColor = .white
        setupUI()
        setupMyLocation()
    }
    
    private func setupUI() {
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupMyLocation() {
        let coordinate = CLLocationCoordinate2D(latitude: 26.7896488, longitude: 80.9531415)
        let annotation = MKPointAnnotation()
        annotation.title = "MY Location"
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}
