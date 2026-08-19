//
//  PlotNow.swift
//  SMAPS
//
//  Created by Dan on 4/1/26.
//

import SwiftUI
import CoreLocation
import SwiftData
import MapKit

struct PlotNow: View {
    
    let idx: String
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),  // temporary
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02) // gamay nga zoom
    )
    
    
    
    @StateObject var locationManager = LocationManager()
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var plotHeadDet: [PlotHeadDet]
    @Query private var plotHead: [PlotHead]
    
    
    @State private var points: [MapPoint] = []
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading) {
                
                VStack{
                    VStack{
                        HStack{
                            Text("")
                            Spacer()
                            Button(action: {
                                
                            }){
                                
//                                Button(action: {
//                                    
//                                }){
//                                    Label("Upload", systemImage: "cloud.circle")
//                                }
//                                .buttonStyle(.borderedProminent)
                            }
                        }
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    
                    Map(
                        coordinateRegion: $region,
                        annotationItems: points,
                        annotationContent: { point in
                            MapMarker(coordinate: point.coordinate, tint: .green)
                        }
                    )
                    .mapStyle(.imagery)  // <<< Satellite-style imagery
                    .frame(height: 300)
                    .cornerRadius(10)
                    .padding()
                }
                
                List(Array(plotHeadDet
                        .filter { $0.plotheadid == idx }
                        .sorted { $0.order < $1.order }  // <<< sorted by order
                        .enumerated()), id: \.offset) { index, plotdet in
                    HStack{
                        VStack(alignment: .leading){
                            Image(systemName: "mappin.circle")
                                .foregroundStyle(Color.green)
                                .font(.largeTitle)
                        }
                        
                        
                        
                        VStack(alignment: .leading){
                            Text("Pin \(index + 1)")
                                .bold()
                            VStack(alignment: .leading){
                                Text("Lat: \(plotdet.lat)")
                                Text("Lon: \(plotdet.lon)")
                            }
                            .font(.footnote)
                        }
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            modelContext.delete(plotdet)
                        } label: {
                            Label("", systemImage: "trash")
                        }
                    }
                }
                        
                
                Button(action: {
                    
                    locationManager.getLocation()
                    if let loc = locationManager.userLocation {
                        
                        savePin(lat: "\(loc.latitude)", lon: "\(loc.longitude)")
                        
                    } else {

                    }
                    
                }){
                    Label("Pin Now", systemImage: "plus")
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .foregroundColor(Color.white)
                        .bold()
                        .background(Color.green)
                        .cornerRadius(100)
                }
                .padding(.top, 20)
                .padding(.leading)
                .padding(.trailing)
                
            }
            
        }
        .onAppear {
            // Load points from database
            points = plotHeadDet
                .filter { $0.plotheadid == idx }
                .sorted { $0.order < $1.order }
                .compactMap { plotdet -> MapPoint? in
                    if let lat = Double(plotdet.lat), let lon = Double(plotdet.lon) {
                        return MapPoint(id: UUID(), coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
                    }
                    return nil
                }
            
            // Set region to first saved pin if available
            if let first = points.first {
                region.center = first.coordinate
            }
        }
        .onAppear {
            points = plotHeadDet
                .filter { $0.plotheadid == idx }       // filter by current plothead
                .sorted { $0.order < $1.order }        // optional: order by date
                .compactMap { plotdet -> MapPoint? in
                    if let lat = Double(plotdet.lat), let lon = Double(plotdet.lon) {
                        return MapPoint(id: UUID(), coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
                    }
                    return nil
                }
        }
    }
    
    func savePin(lat: String, lon: String){
        
        let timezone = TimeZone(identifier: "Asia/Manila")!
        let now = Date()

        let formatter = DateFormatter()
        formatter.timeZone = timezone
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let manilaDateTime = formatter.string(from: now)
        
        let newPlotHeadDet = PlotHeadDet(
                plotheadid: idx, lat: lat, lon: lon, status: "1", order: manilaDateTime
            )
        
        modelContext.insert(newPlotHeadDet)
        
        print("\(lat) | \(lon) SAVED")
        
        if let latD = Double(lat), let lonD = Double(lon) {
            let coord = CLLocationCoordinate2D(latitude: latD, longitude: lonD)
            points.append(MapPoint(id: UUID(), coordinate: coord))
            
            // Update map center to last pin
            region.center = coord
        }
    }
}

#Preview {
    PlotNow(idx: "")
}
struct MapPoint: Identifiable {
    let id: UUID
    let coordinate: CLLocationCoordinate2D
}

