//
//  Home.swift
//  SMAPS
//
//  Created by Dan on 4/1/26.
//

import SwiftUI

struct Home: View {
    
    @State private var openLocator: Bool = false
    @State private var errorMessage: String = ""
    @State private var passcode: String = ""
    
    var body: some View {
        NavigationStack {
            
            List{
                
                Section("Mapping"){
                    
                    NavigationLink(destination: PlotHome()){
                        HStack{
                            Image(systemName: "mappin.circle.fill")
                                .foregroundStyle(Color.green)
                                .font(.largeTitle)
                            VStack(alignment: .leading) {
                                Text("Plot Now")
                                    .bold()
                            }
                        }
                    }
                    
                    NavigationLink(destination: SMap()){
                        HStack{
                            Image(systemName: "map.circle.fill")
                                .foregroundStyle(Color.green)
                                .font(.largeTitle)
                            VStack(alignment: .leading) {
                                Text("Maps")
                                    .bold()
                            }
                        }
                    }
                }
                
                Section("Growers") {
                    NavigationLink(destination: Grower()){
                        HStack{
                            Image(systemName: "person.circle.fill")
                                .foregroundStyle(Color.green)
                                .font(.largeTitle)
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Growers")
                                        .bold()
                                }
                            }
                        }
                    }
                }
                
                Section("Media"){
                    
                    NavigationLink(destination: FileManager()){
                        HStack{
                            Image(systemName: "folder.circle.fill")
                                .foregroundStyle(Color.green)
                                .font(.largeTitle)
                            VStack(alignment: .leading) {
                                Text("File Manager")
                                    .bold()
                            }
                        }
                    }
                    
                }
                
                Section("Uploads"){
                    
                    NavigationLink(destination: UploadedMaps()){
                        HStack{
                            Image(systemName: "cloud.circle.fill")
                                .foregroundStyle(Color.green)
                                .font(.largeTitle)
                            VStack(alignment: .leading) {
                                Text("Uploaded Maps")
                                    .bold()
                            }
                        }
                    }
                    
                    NavigationLink(destination: PlotHome()){
                        HStack{
                            Image(systemName: "cloud.circle.fill")
                                .foregroundStyle(Color.green)
                                .font(.largeTitle)
                            VStack(alignment: .leading) {
                                Text("Uploaded Images")
                                    .bold()
                            }
                        }
                    }
                    .disabled(true)
                    
                }
                
                Section("Admin"){
                    
                    
                    Button(action: {
                        openLocator.toggle()
                    }){
                        HStack{
                            Image(systemName: "lock.fill")
                                .foregroundStyle(Color.red)
                                .font(.largeTitle)
                            VStack(alignment: .leading) {
                                HStack{
                                    Text("Locator")
                                        .foregroundStyle(Color.black)
                                        .bold()
                                }
                                Text("Saved Locations")
                                    .font(.footnote)
                            }
                        }
                    }
                    
//                    NavigationLink(destination: StartTrack()){
//                        HStack{
//                            Image(systemName: "mappin.and.ellipse.circle.fill")
//                                .foregroundStyle(Color.green)
//                                .font(.largeTitle)
//                            VStack(alignment: .leading) {
//                                Text("Enable Tracking")
//                                    .bold()
//                            }
//                        }
//                    }
//
                    
                }
                
                
            }
            
        }
        .sheet(isPresented: $openLocator){
            
            VStack(alignment: .leading){
                
                Text("Passcode")
                    .bold()
                    .font(.largeTitle)
                    .foregroundStyle(Color.green)
                Text("\(errorMessage)")
                    .font(.footnote)
                    .foregroundStyle(Color.red)
                    .padding(.bottom, 20)
                TextField("000000", text: $passcode)
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10) // Rounds the background corners
                    .font(.title3)
                    .padding(.bottom, 20)
                
                Button(action: {
                    
                    validatePasscode()
                    
                }){
                    Text("Validate")
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .foregroundColor(Color.white)
                        .bold()
                        .background(Color.green)
                        .cornerRadius(100)
                }
                
                Button(action: {
                    
                    openLocator.toggle()
                    
                }){
                    Text("Close")
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .bold()
                        .cornerRadius(100)
                }
                
                
            }
            .padding(20)
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
            
        }
        .navigationTitle("Homepage")
        .navigationBarBackButtonHidden(true)
    }
    
    func validatePasscode(){
        
        if passcode == "1234"{
            
        }else if passcode.isEmpty {
            errorMessage = "Please enter a passcode"
        }
        
    }
}

#Preview {
    Home()
}
