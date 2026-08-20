//
//  SMAPSApp.swift
//  SMAPS
//
//  Created by Dan on 4/1/26.
//

import SwiftUI
import SwiftData

@main
struct SMAPSApp: App {
    var body: some Scene {
        WindowGroup {
//            StartTrack()
//            Home()
//            PlotHome()
            ContentView()
//            Grower()
        }
        .modelContainer(for: [PlotHead.self, PlotHeadDet.self, MyFile.self, AddUserData.self, AddDocs.self, AddTrees.self])
//        .modelContainer(for: [DryerHeader.self, DryerData.self, AppUser.self])
    }
}
