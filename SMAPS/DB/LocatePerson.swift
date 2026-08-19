//
//  LocatePerson.swift
//  SMAPS
//
//  Created by Dan on 4/6/26.
//

import Foundation
import SwiftData

@Model
final class LocatePerson: Identifiable {
    
    var id: String
    var user: String
    var lat: String
    var lon: String
    var datetime: String
    var status: String
    var isuploaded: String
    
    init(id: String, user: String, lat: String, lon: String, datetime: String, status: String, isuploaded: String) {
        self.id = id
        self.user = user
        self.lat = lat
        self.lon = lon
        self.datetime = datetime
        self.status = status
        self.isuploaded = isuploaded
    }
    
}
