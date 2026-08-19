//
//  File.swift
//  SMAPS
//
//  Created by Dan on 4/1/26.
//

import Foundation
import SwiftData

@Model
final class PlotHeadDet: Identifiable {
    
    var id: String
    var plotheadid: String
    var lat: String
    var lon: String
    var status: String
    var order: String
    
    init(id: String = UUID().uuidString, plotheadid: String, lat: String, lon: String, status: String, order: String) {
        self.id = id
        self.plotheadid = plotheadid
        self.lat = lat
        self.lon = lon
        self.status = status
        self.order = order
    }
    
    
}

