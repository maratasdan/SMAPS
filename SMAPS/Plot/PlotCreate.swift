//
//  PlotCreate.swift
//  SMAPS
//
//  Created by Dan on 4/1/26.
//

import SwiftUI
import SwiftData
import Foundation

struct PlotCreate: View {
    
    @State private var plotName: String = ""
    @State private var plotDescription: String = ""
    @State private var errorMessage: String = ""
    
    @State private var isCreated: Bool = false
    
    @Environment(\.modelContext) private var modelContext
    @Query private var plotHead: [PlotHead]
    
    @State private var searchText: String = ""
    
    var body: some View {
        
        NavigationStack {
            
//            TabView{
//                Tab(role: .search){
//                    
//                    NavigationStack{
//                        PlotHome()
//                    }
//                }
//                
//            }
//            .searchable(text: $searchText)
            
            VStack(alignment: .leading) {
                Text("Create New Plot")
                    .bold()
                    .font(.largeTitle)
                    .foregroundStyle(Color.green)
                Text("\(errorMessage)")
                    .font(.footnote)
                    .foregroundStyle(Color.red)
                    .padding(.bottom, 20)
                
                Text("Plot Name")   
                TextField("Lagao...", text: $plotName)
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10) // Rounds the background corners
                    .font(.title3)
                    .padding(.bottom, 20)
                
                Text("Description")
                TextField("", text: $plotDescription)
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10) // Rounds the background corners
                    .font(.title3)
                    .padding(.bottom, 20)
                
                Button(action: {
                    
                    if plotName.isEmpty || plotDescription.isEmpty{
                        errorMessage = "Please fill in all fields."
                    }else{
                        saveInput()
                    }
                    
                }){
                    Text("Create")
                }
                .padding()
                .background(Color.green.opacity(1))
                .cornerRadius(10) // Rounds the background corners
                .foregroundColor(.white)
                .font(.title3)
                .bold()
                .padding(.bottom, 20)
                
            }
            .padding(20)
            
        }
        .navigationDestination(isPresented: $isCreated) {
            PlotHome()
        }
    }
    
    func saveInput(){
        
        let timezone = TimeZone(identifier: "Asia/Manila")!
        let now = Date()

        let formatter = DateFormatter()
        formatter.timeZone = timezone
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let manilaDateTime = formatter.string(from: now)
        
        
        let savePlot = PlotHead(
            name: plotName,
            pdescription: plotDescription,
            dateCreated: manilaDateTime,
            status: "1",
            uploadStatus: "1"
        )
        
        modelContext.insert(savePlot)
        
        isCreated = true
        
        print("Saved")
        
        
    }
    
}

#Preview {
    PlotCreate()
}
