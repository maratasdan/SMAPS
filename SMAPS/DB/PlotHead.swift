//
//  PlotHead.swift
//  SMAPS
//
//  Created by Dan on 4/1/26.
//

import Foundation
import SwiftData

@Model
final class PlotHead: Identifiable {
    
    var id: String
    var name: String
    var pdescription: String
    var dateCreated: String
    var status: String
    var uploadStatus: String
    
    init(id: String = UUID().uuidString, name: String, pdescription: String, dateCreated: String, status: String, uploadStatus: String) {
        self.id = id
        self.name = name
        self.pdescription = pdescription
        self.dateCreated = dateCreated
        self.status = status
        self.uploadStatus = uploadStatus
    }
    
}
