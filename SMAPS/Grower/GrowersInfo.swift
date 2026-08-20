//
//  GrowersInfo.swift
//  SMAPS
//
//  Created by danxd on 8/19/26.
//

import SwiftUI

import PhotosUI
import Foundation
import SwiftData

struct GrowersInfo: View {
    
    let userid: String
    
    @Query private var userdata: [AddUserData]
    @Query private var docsdata: [AddDocs]
    @Query private var tressdata: [AddTrees]
    
    @State private var selectedImage: PhotosPickerItem?
    @State private var imagePaths: [String] = []
    @State private var openPreviewImage: Bool = false
    @State private var selectedPreviewPath = ""
    
    init(userid: String) {
        self.userid = userid
        
        _userdata = Query(
            filter: #Predicate<AddUserData> { user in
                user.userid == userid
            }
        )
        
        _docsdata = Query(
            filter: #Predicate<AddDocs> { doc in
                doc.userid == userid
            }
        )
        
        _tressdata = Query(
            filter: #Predicate<AddTrees> { tree in
                tree.userid == userid
            }
        )
    }
    
    private func getCurrentImagePath(_ savedPath: String) -> String {
        let fileName = URL(fileURLWithPath: savedPath).lastPathComponent
        
        let documentsDirectory = Foundation.FileManager.default.urls(
            for: Foundation.FileManager.SearchPathDirectory.documentDirectory,
            in: Foundation.FileManager.SearchPathDomainMask.userDomainMask
        )[0]
        
        return documentsDirectory
            .appendingPathComponent(fileName)
            .path
    }
    
    
    var body: some View {
        NavigationStack {
            List {
                Section("User Information"){
                    ForEach(userdata) { user in
                        
                        VStack(alignment: .leading) {
                            Text("Name")
                                .font(.footnote)
                            HStack{
                                Text("\(user.firstName) \(user.middleName ?? "") \(user.lastName)")
                                    .bold()
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Contact Number")
                                .font(.footnote)
                            HStack{
                                Text("\(user.contactNumber)")
                                    .bold()
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Email Address")
                                .font(.footnote)
                            HStack{
                                Text("\(user.email)")
                                    .bold()
                            }
                        }
                        
                    }
                }
                
                Section("Personal Address"){
                    ForEach(userdata) { user in
                        
                        VStack(alignment: .leading) {
                            HStack{
                                Text("\(user.sitio), \(user.barangay), \(user.city), \(user.province) \(user.postalCode)")
                                    .bold()
                            }
                        }
                    }
                }
                
                Section("Trees"){
                    ForEach(tressdata) { tree in
                        
                        HStack(spacing: 5) {
                            ZStack {
                                Rectangle()
                                    .frame(width: 45, height: 45)
                                    .foregroundStyle(Color.green.opacity(0.15))
                                    .cornerRadius(50)
                                Image(systemName: "tree.fill")
                                    .tint(Color.green)
                                    .foregroundStyle(Color.green)
                            }
                            VStack(alignment: .leading) {
                                Text("\(tree.treetype)")
                                    .bold()
                                HStack {
                                    Text("\(tree.numberofTrees) Trees |")
                                    Text("\(tree.estkg) Kilograms")
                                }
                            }
                        }
                    }
                }
                
                Section("Docs"){
                    ScrollView(.horizontal) {
                         HStack{
                             ForEach(docsdata) { doc in
                                             
                                 let imagePath = getCurrentImagePath(doc.path)
                                 
                                 if let uiImage = UIImage(contentsOfFile: imagePath) {
                                     ZStack {
                                         Image(uiImage: uiImage)
                                             .resizable()
                                             .scaledToFill()
                                             .frame(width: 100, height: 100)
                                             .clipShape(
                                                 RoundedRectangle(cornerRadius: 12)
                                             )
                                             .onTapGesture {
                                                 selectedPreviewPath = doc.path
                                                 openPreviewImage = true
                                             }
                                     }
                                 }
                             }
                        }
                    }
                }
                
                
                Section("Developer Side (Ignore)"){
                    VStack(alignment: .leading) {
                        ForEach(docsdata) { doc in
                            
                            Text("\(doc.path)")
                                .font(.footnote)
                                .foregroundStyle(Color.secondary)
                            
                        }
                    }
                }
                
            }
            .sheet(isPresented: $openPreviewImage){
                VStack {
                    VStack {
                        
                        let imagePath = getCurrentImagePath(selectedPreviewPath)
                        
                        if let uiImage = UIImage(contentsOfFile: imagePath) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 12)
                                )
                                .padding(20)
                        }
                    }
                    .padding(20)
                }
                .presentationDetents([.medium, .large])
            }
        }
        .navigationTitle("Grower's Information")
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    uploadDataOnline()
                }) {
                    Image(systemName: "cloud.fill")
                        .foregroundStyle(Color.red)
                }
            }
        }
    }
    
    func uploadDataOnline() {
        
        guard let url = URL(string: "https://smaps.stellarseedscorp.org/Growers/upload_growers.php") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let data: [String: Any] = [
            "userinfo": userdata,
            "trees": tressdata,
            "docs": docsdata
        ]
        
        print(data)
    }
    
}

#Preview {
    GrowersInfo(userid: "")
}
