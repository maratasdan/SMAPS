//
//  SMap.swift
//  SMAPS
//
//  Created by Dan on 4/1/26.
//

import SwiftUI
import MapKit
import CoreLocation
import Combine

class MapLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization() // ask permission
        manager.startUpdatingLocation()
    }

    func getLocation() {
        manager.requestLocation() // one-time fetch
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.userLocation = location.coordinate
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location:", error.localizedDescription)
    }
}

struct SMap: View {
    
    @StateObject private var locationManager = MapLocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 6.1167, longitude: 125.1717),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        VStack {
            if let userLocation = locationManager.userLocation {
                Map(coordinateRegion: $region, showsUserLocation: true)
                    .onAppear {
                        region.center = userLocation // focus sa current location
                    }
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("Getting your location...")
            }
        }
    }
}

#Preview {
    SMap()
}
