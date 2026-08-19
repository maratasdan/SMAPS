//
//  AddUser.swift
//  SMAPS
//
//  Created by Danxd on 6/15/26.
//

import SwiftUI
import PhotosUI
import Foundation
import SwiftData

struct TreesArr: Codable, Identifiable {
    
    var treeid: String
    var treeType: String
    var numberOfTrees: String
    var estKg: String
    
    var id: String {
        treeid
    }
    
    enum CodingKeys: String, CodingKey {
        case treeid
        case treeType
        case numberOfTrees
        case estKg
    }
}

struct AddUser: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var userid = UUID().uuidString
    
    @State private var firsName: String = ""
    @State private var middleName: String = ""
    @State private var lastName: String = ""
    @State private var contactNumber: String = ""
    @State private var email: String = ""
    
    @State private var sitio: String = ""
    @State private var barangay: String = ""
    @State private var city: String = ""
    @State private var province: String = ""
    @State private var zip: String = ""
    @State private var openAddTree: Bool = false
    @State private var selectedTree = "Please Select Type"
    
    @State private var goToList: Bool = false

    let trees = [
        "Please Select Type",
        "Robusta",
        "Arabica",
        "Excelsa",
        "Liberica"
    ]
    
    @State private var numberOfTrees: String = ""
    @State private var estKg: String = ""
    @State private var treesarr: [TreesArr] = []
    
    @State private var countArray: Int = 0
    
    @State private var selectedImage: PhotosPickerItem?
    @State private var imagePaths: [String] = []
    @State private var openPreviewImage: Bool = false
    @State private var selectedPreviewPath = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section("User Information"){
                    HStack{
                        TextField("First Name (Required)", text: $firsName)
                    }
                    HStack{
                        TextField("Middle Name", text: $middleName)
                    }
                    HStack{
                        TextField("Last Name (Required)", text: $lastName)
                    }
                }
                
                HStack{
                    TextField("Contact Number", text: $contactNumber)
                }
                HStack{
                    TextField("Email Address", text: $email)
                }
                
                Section("Address"){
                    HStack{
                        TextField("Sitio", text: $sitio)
                    }
                    HStack{
                        TextField("Barangay", text: $barangay)
                    }
                    HStack{
                        TextField("City", text: $city)
                    }
                    HStack{
                        TextField("Province", text: $province)
                    }
                    HStack{
                        TextField("Zip", text: $zip)
                    }
                }
                
                Section("Trees"){
                    ForEach(treesarr) { item in
                        HStack {
                            Image(systemName: "tree")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(Color.green)

                            VStack(alignment: .leading) {
                                Text(item.treeType)

                                Text("No. of Trees: \(item.numberOfTrees) | Est. Kg: \(item.estKg)")
                                    .font(.footnote)
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                treesarr.removeAll { $0.treeid == item.treeid }
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }
                    HStack {
                        Button(action: {
                            openAddTree = true
                        }){
                            Text("Add Tree")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                
                Section("Documents") {
                    HStack {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(imagePaths, id: \.self) { path in
                                    if let uiImage = UIImage(contentsOfFile: path) {
                                        ZStack {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 100)
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                                .onTapGesture {
                                                    selectedPreviewPath = path
                                                    openPreviewImage = true
                                                    
                                                }
                                            
                                            VStack {
                                                HStack {
//                                                    Button(action: {
//                                                        openPreviewImage = true
//                                                        selectedPreviewPath = path
//                                                    }){
//                                                        Image(systemName: "magnifyingglass.circle")
//                                                            .tint(Color.white)
//                                                    }
//                                                    .glassEffect(.regular)
                                                    Spacer()
                                                    Button(action: {
                                                        imagePaths.removeAll { $0 == path }
                                                    }){
                                                        Image(systemName: "x.circle.fill")
                                                            .tint(Color.red)
                                                    }
                                                    .glassEffect(.regular)
                                                }
                                                .padding(5)
                                                Spacer()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    PhotosPicker(selection: $selectedImage, matching: .images) {
                        Label("Add Document", systemImage: "photo.badge.plus")
                            .frame(maxWidth: .infinity)
                    }
                    .onChange(of: selectedImage) { oldValue, newValue in
                        Task {
                            if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                if let savedPath = saveImageToFileManager(data: data) {
                                    imagePaths.append(savedPath)
                                }
                            }
                        }
                    }
                }
                
                HStack {
                    Button(action: {
                       saveData(userid: userid, fname: firsName, mname: middleName, lname: lastName, contact: contactNumber, email: email, sitio: sitio, barangay: barangay, city: city, province: province, zip: zip)
                    }){
                        Text("Save Grower")
                            .frame(maxWidth: .infinity)
                    }
                }
                
            }
//          MARK: Nav
            
            .navigationDestination(isPresented: $goToList){
                Grower()
            }
            
//          MARK: SHEET
            
            .sheet(isPresented: $openAddTree){
                VStack {
                    List {
                        HStack {
                            Picker("Tree Type", selection: $selectedTree) {
                                ForEach(trees, id: \.self) { tree in
                                    Text(tree).tag(tree)
                                }
                            }
                            .pickerStyle(.menu)
                        }
                        HStack{
                            TextField("Number of Trees", text: $numberOfTrees)
                        }
                        HStack{
                            TextField("Estimated Kilograms", text: $estKg)
                        }
                        HStack {
                            Button(action: {
                                addTree(treetype: selectedTree, number: numberOfTrees, kg: estKg)
                            }){
                                Text("Add Tree")
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
                .presentationDetents([.medium, .large])
            }
            
            .sheet(isPresented: $openPreviewImage){
                VStack {
                    VStack {
                        if let uiImage = UIImage(contentsOfFile: selectedPreviewPath) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(20)
                        }
                    }
                    .padding(20)
                }
                .presentationDetents([.medium, .large])
            }
        }
    }
    
    func saveData(userid: String, fname: String, mname: String, lname: String, contact: String, email: String, sitio: String, barangay: String, city: String, province: String, zip: String) {
//      userinformation
        
        let userdata = AddUserData(userid: userid, firstName: fname, lastName: lname, email: email, contactNumber: contact, sitio: sitio, barangay: barangay, city: city, province: province, postalCode: zip)
        
        modelContext.insert(userdata)
        
        do {
            try modelContext.save()
            print("Userdata Save")
        }catch{
            print("Error Saving Userdata")
        }
        
//       trees
        
        for tree in treesarr {
            let treeData = AddTrees(treeid: tree.id, userid: userid, treetype: tree.treeType, numberofTrees: tree.numberOfTrees, estkg: tree.estKg)
            
            modelContext.insert(treeData)
            
            do {
                try modelContext.save()
                print("Trees Save")
            }catch{
                
            }
        }
        
//      documents
        for imgPath in imagePaths {
            let imageItem = imgPath
            print(imageItem)
            
            let data = AddDocs(imageid: UUID().uuidString, userid: userid, path: imageItem)
            
            modelContext.insert(data)
            
            do {
                try modelContext.save()
                print("Docs Save")
            }catch{
                print("Error Saving Docs")
            }
            
        }
        
        goToList = true
        
    }
    
    func addTree(treetype: String, number: String, kg: String){
        let item = TreesArr(treeid: UUID().uuidString, treeType: treetype, numberOfTrees: number, estKg: kg)
        treesarr.append(item)
        
        openAddTree = false
        
    }
    
    func saveImageToFileManager(data: Data) -> String? {
        let fileName = UUID().uuidString + ".jpg"
        
        let documentsDirectory = Foundation.FileManager.default.urls(
            for: Foundation.FileManager.SearchPathDirectory.documentDirectory,
            in: Foundation.FileManager.SearchPathDomainMask.userDomainMask
        ).first
        
        guard let documentsDirectory = documentsDirectory else {
            return nil
        }
        
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            return fileURL.path
        } catch {
            print("Error saving image: \(error.localizedDescription)")
            return nil
        }
    }
}

#Preview {
    AddUser()
}
