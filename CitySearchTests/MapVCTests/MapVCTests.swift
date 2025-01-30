//
//  MapVCTests.swift
//  CitySearch
//
//  Created by Mohit Kumar on 29/01/25.
//

import XCTest
import MapKit
@testable import CitySearch

class MapVCTests: XCTestCase {
    
    var mapVC: MapVC!
    
    override func setUp() {
        super.setUp()
        mapVC = MapVC()
    }
    
    override func tearDown() {
        mapVC = nil
        super.tearDown()
    }
    
    // MARK: - Test Cities Are Marked on Map
    func testMarkCitiesOnMap_WithValidCities() {
        // Arrange
        let testCities = [
            City(geoNameId: 1, topographicalName: "Test City 1", cityName: "Test City 1", countryName: "Test Country", countryCode: "TC", administrativeRegion: "Test Region", latitude: "37.7749", longitude: "-122.4194", population: 1000, featureCodeName: "City"),
            City(geoNameId: 2, topographicalName: "Test City 2", cityName: "Test City 2", countryName: "Test Country", countryCode: "TC", administrativeRegion: "Test Region", latitude: "34.0522", longitude: "-118.2437", population: 2000, featureCodeName: "City")
        ]
        
        // Act
        mapVC.cities = testCities
        mapVC.loadViewIfNeeded() // Ensure the view is loaded
        mapVC.markCitiesOnMap()
        
        // Assert
        XCTAssertEqual(mapVC.mapView.annotations.count, 2, "There should be 2 annotations on the map.")
        
        let firstAnnotation = mapVC.mapView.annotations[0] as? MKPointAnnotation
        XCTAssertEqual(firstAnnotation?.title, "Test City 1", "The first annotation's title should be 'Test City 1'.")
        XCTAssertEqual(firstAnnotation?.subtitle, "Test Country", "The first annotation's subtitle should be 'Test Country'.")
        
        let secondAnnotation = mapVC.mapView.annotations[1] as? MKPointAnnotation
        XCTAssertEqual(secondAnnotation?.title, "Test City 2", "The second annotation's title should be 'Test City 2'.")
        XCTAssertEqual(secondAnnotation?.subtitle, "Test Country", "The second annotation's subtitle should be 'Test Country'.")
    }
    
    // MARK: - Test No Cities Are Marked on Map
    func testMarkCitiesOnMap_WithNoCities() {
        // Arrange
        mapVC.cities = []
        
        // Act
        mapVC.loadViewIfNeeded()
        mapVC.markCitiesOnMap()
        
        // Assert
        XCTAssertEqual(mapVC.mapView.annotations.count, 0, "There should be no annotations on the map when cities array is empty.")
    }
    
    // MARK: - Test Zoom In Functionality
    func testZoomIn() {
        // Arrange
        mapVC.loadViewIfNeeded()
        let initialRegion = mapVC.mapView.region
        
        // Act
        mapVC.zoomInTapped()
        
        // Assert
        let newRegion = mapVC.mapView.region
        XCTAssertLessThan(newRegion.span.latitudeDelta, initialRegion.span.latitudeDelta, "Latitude delta should decrease after zooming in.")
        XCTAssertLessThan(newRegion.span.longitudeDelta, initialRegion.span.longitudeDelta, "Longitude delta should decrease after zooming in.")
    }
    
    // MARK: - Test Zoom Out Functionality
    func testZoomOut() {
        // Arrange
        mapVC.loadViewIfNeeded()
        let initialRegion = mapVC.mapView.region
        
        // Act
        mapVC.zoomOutTapped()
        
        // Assert
        let newRegion = mapVC.mapView.region
        XCTAssertGreaterThan(newRegion.span.latitudeDelta, initialRegion.span.latitudeDelta, "Latitude delta should increase after zooming out.")
        XCTAssertGreaterThan(newRegion.span.longitudeDelta, initialRegion.span.longitudeDelta, "Longitude delta should increase after zooming out.")
    }
    
    // MARK: - Test Invalid Coordinates
    func testMarkCitiesOnMap_WithInvalidCoordinates() {
        // Arrange
        let testCities = [
            City(geoNameId: 1, topographicalName: "Invalid City", cityName: "Invalid City", countryName: "Test Country", countryCode: "TC", administrativeRegion: "Test Region", latitude: "invalid", longitude: "invalid", population: 1000, featureCodeName: "City")
        ]
        
        // Act
        mapVC.cities = testCities
        mapVC.loadViewIfNeeded()
        mapVC.markCitiesOnMap()
        
        // Assert
        XCTAssertEqual(mapVC.mapView.annotations.count, 0, "No annotations should be added for cities with invalid coordinates.")
    }
}
