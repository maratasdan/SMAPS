//
//  MyFile.swift
//  SMAPS
//
//  Created by Dan on 4/8/26.
//

import Foundation
import SwiftData

@Model
final class MyFile {
    var fileName: String
    var filePath: String
    
    init(fileName: String, filePath: String) {
        self.fileName = fileName
        self.filePath = filePath
    }
}
