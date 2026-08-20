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

struct UserUpload: Codable {
    let userid: String
    let firstName: String
    let middleName: String?
    let lastName: String
    let email: String
    let contactNumber: String
    let sitio: String
    let barangay: String
    let city: String
    let province: String
    let postalCode: String
    let status: String?
}

struct TreeUpload: Codable {
    let treeid: String
    let userid: String
    let treetype: String
    let numberofTrees: String
    let estkg: String
}

struct DocUpload: Codable {
    let imageid: String
    let userid: String
    let path: String
}

struct GrowersUpload: Codable {
    let userinfo: [UserUpload]
    let trees: [TreeUpload]
    let docs: [DocUpload]
}

struct GrowersInfo: View {
    
    let userid: String
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Query private var userdata: [AddUserData]
    @Query private var docsdata: [AddDocs]
    @Query private var tressdata: [AddTrees]
    
    @State private var selectedImage: PhotosPickerItem?
    @State private var imagePaths: [String] = []
    @State private var openPreviewImage: Bool = false
    @State private var selectedPreviewPath = ""
    
    @State private var showUploadSheet = false
    @State private var isUploading = false
    
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
        .sheet(isPresented: $showUploadSheet) {
            VStack(spacing: 20) {

                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(1.5)

                    Text("Uploading...")
                        .font(.headline)

                }
                .padding(30)
                .presentationDetents([.medium])
                .interactiveDismissDisabled(isUploading)
        }
        .toolbar {
            
            if userdata.first?.status == "1" {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color.green)
                    }
                }
            } else {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showUploadSheet = true
                        uploadDataOnline()
                    }) {
                        Image(systemName: "cloud.fill")
                            .foregroundStyle(Color.red)
                    }
                }
            }
            
            
        }
    }
    
    func uploadDataOnline() {

        guard let url = URL(string: "https://smaps.stellarseedscorp.org/Growers/upload_growers.php") else {
            return
        }

        // MARK: - Create JSON data

        let uploadData = GrowersUpload(
            userinfo: userdata.map {
                UserUpload(
                    userid: $0.userid,
                    firstName: $0.firstName,
                    middleName: $0.middleName,
                    lastName: $0.lastName,
                    email: $0.email,
                    contactNumber: $0.contactNumber,
                    sitio: $0.sitio,
                    barangay: $0.barangay,
                    city: $0.city,
                    province: $0.province,
                    postalCode: $0.postalCode,
                    status: $0.status
                )
            },

            trees: tressdata.map {
                TreeUpload(
                    treeid: $0.treeid,
                    userid: $0.userid,
                    treetype: $0.treetype,
                    numberofTrees: $0.numberofTrees,
                    estkg: $0.estkg
                )
            },

            docs: docsdata.map {
                DocUpload(
                    imageid: $0.imageid,
                    userid: $0.userid,
                    path: $0.path
                )
            }
        )

        guard let jsonData = try? JSONEncoder().encode(uploadData) else {
            print("Failed to encode JSON")
            return
        }

        // MARK: - Multipart

        let boundary = "Boundary-\(UUID().uuidString)"

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.setValue(
            "multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type"
        )

        var body = Data()

        // MARK: - Add JSON

        body.append("--\(boundary)\r\n".data(using: .utf8)!)

        body.append(
            "Content-Disposition: form-data; name=\"data\"\r\n\r\n"
                .data(using: .utf8)!
        )

        body.append(jsonData)

        body.append("\r\n".data(using: .utf8)!)


        // MARK: - Add Images

        for doc in docsdata {

            let imagePath = getCurrentImagePath(doc.path)

            guard let imageData = try? Data(contentsOf: URL(fileURLWithPath: imagePath)) else {
                print("Cannot read image:", imagePath)
                continue
            }

            let fileName = URL(fileURLWithPath: imagePath).lastPathComponent

            body.append("--\(boundary)\r\n".data(using: .utf8)!)

            body.append(
                "Content-Disposition: form-data; name=\"image_\(doc.imageid)\"; filename=\"\(fileName)\"\r\n"
                    .data(using: .utf8)!
            )

            body.append(
                "Content-Type: image/jpeg\r\n\r\n"
                    .data(using: .utf8)!
            )

            body.append(imageData)

            body.append("\r\n".data(using: .utf8)!)
        }


        // MARK: - End Multipart

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body


        // MARK: - Upload

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                print("Upload Error:", error)
                return
            }

            if let response = response as? HTTPURLResponse {
                print("HTTP Status:", response.statusCode)
            }

            if let data = data {

                let responseString =
                    String(data: data, encoding: .utf8) ?? ""
                
                if responseString.contains("saved") {
                    updateLocalStatus(userid: userdata.first?.userid ?? "NA")
                }

                print("PHP Response:")
                print(responseString)
                
            }

        }.resume()
    }
    
    func updateLocalStatus(userid: String) {
        
        if let user = userdata.first ( where: { $0.userid == userid }) {
            user.status = "1"
        }
        
        do {
            try modelContext.save()
            showUploadSheet = false
            DispatchQueue.main.async {
                dismiss()
            }
        } catch {
            print("Error saving offline")
        }
        
    }
    
}

#Preview {
    GrowersInfo(userid: "")
}
