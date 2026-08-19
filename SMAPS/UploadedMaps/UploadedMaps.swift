//
//  PlotHome.swift
//  SMAPS
//
//  Created by Dan on 4/1/26.
//

import SwiftUI
import SwiftData

struct UploadedMaps: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var plotHead: [PlotHead]
    @Query private var plotHeadDet: [PlotHeadDet]
    
    @State private var selectedDetails: [PlotHeadDet] = []
    
    @State private var openUploadPlot: Bool = false
    @State private var openPlotDetails: Bool = false
    @State private var openAlreadyUploaded: Bool = false
    @State private var deleteRowConfirm: Bool = false
    
    @State private var loadsaving: Bool = false
    @State private var isLoading = false
    
    @State private var setPlotHeadid: String = ""
    
    func uploadDetails(context: ModelContext) {
        
        let descriptor = FetchDescriptor<PlotHeadDet>(
            predicate: #Predicate { $0.plotheadid == setPlotHeadid }
        )
        
        do {
            
            let data = try context.fetch(descriptor)
            selectedDetails = data
            
            uploadTopServer()
            
        } catch {
            print("Error:", error)
        }
    }
    
    func uploadTopServer() {
        
        guard let header = plotHead.first(where: { $0.id == setPlotHeadid }) else { return }
        guard !selectedDetails.isEmpty else { return }
        
        let headerDict: [String: Any] = [
            "id": header.id,
            "name": header.name,
            "pdescription": header.pdescription,
            "dateCreated": header.dateCreated,
            "status": header.status,
            "uploadStatus": header.uploadStatus
        ]
        
        let detailsArray = selectedDetails.map { detail in
            [
                "id": detail.id,
                "plotheadid": detail.plotheadid,
                "lat": detail.lat,
                "lon": detail.lon,
                "status": detail.status,
                "order": detail.order
            ]
        }
        
        let finalData: [String: Any] = [
            "header": headerDict,
            "details": detailsArray
        ]
        
        openUploadPlot = false
        loadsaving = true
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: finalData) else {
            print("Error converting to JSON")
            loadsaving = false
            return
        }
        
        let url = URL(string: "https://smaps.stellarseedscorp.org/uploadPlotMaps.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                DispatchQueue.main.async { loadsaving = false }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { loadsaving = false }
                return
            }
            
            let responseString = String(decoding: data, as: UTF8.self)
            print("Server response: \(responseString)")
            
            DispatchQueue.main.async {
                if responseString == "Done" {
                    updateHeadStatus(plotheadid: setPlotHeadid)
                } else {
                    loadsaving = false
                }
            }
        }.resume()
    }
    
    
    func updateHeadStatus(plotheadid: String){
        
        if let item = plotHead.first(where: {$0.id == plotheadid}) {
            item.status = "2"
            try? modelContext.save()
            
            loadsaving = false // ✅ update UI safely
        }
        
    }
    
    
    var body: some View {
        NavigationStack {
            VStack {
                List(plotHead, id: \.id) { plhead in
                    if plhead.status == "2" {
                        HStack{
                            NavigationLink(destination: PlotNowDone(idx: plhead.id)){
                                
                                if plhead.status == "1" {
                                    Image(systemName: "map.circle.fill")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundStyle(Color.gray)
                                        .font(.largeTitle)
                                        
                                }else if plhead.status == "2" {
                                    Image(systemName: "map.circle.fill")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundStyle(Color.green)
                                        .font(.largeTitle)
                                }
                                
                                VStack(alignment: .leading) {
                                    
                                    HStack{
                                        Text("\(plhead.name)")
                                            .bold()
                                    }
                                    Text("\(plhead.pdescription)")
                                        .font(.footnote)
                                    Text("\(plhead.dateCreated)")
                                        .font(.footnote)
                                }
                            }
                            .swipeActions(edge: .leading){
                                if plhead.status == "1" {
                                    
                                    Button(role: .confirm){
            //                            modelContext.delete(plhead)
        //                                uploadDataDet(pid: plhead.)
                                        setPlotHeadid = plhead.id
                                        openUploadPlot = true
                                    } label: {
                                        Label("", systemImage: "cloud.circle")
                                            .tint(Color.blue)
                                    }
                                    
                                }else if plhead.status == "2" {
                                    
                                    Button(role: .confirm){
                                        openAlreadyUploaded = true
                                    } label: {
                                        Label("", systemImage: "checkmark.arrow.trianglehead.counterclockwise")
                                            .tint(Color.green)
                                    }
                                    
                                }
                                
                            }
                            
                            .swipeActions(edge: .trailing){
                                Button(action: {
                                    deleteRowConfirm.toggle()
                                    setPlotHeadid = plhead.id
                                }){
                                    Label("", systemImage: "trash")
                                        .tint(Color.red)
                                        .foregroundStyle(Color.red)
                                }
                            }
                        }
                    }
                }
                .sheet(isPresented: $deleteRowConfirm){
                    VStack{
                        Text("Are you sure?")
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(Color.green)
                            .padding(.bottom, 20)
                        Button(action: {
                            
                            if let item = plotHead.first(where: {$0.id == setPlotHeadid}) {
                                item.status = "3"
                                try? modelContext.save()
                                
                                deleteRowConfirm = false // ✅ update UI safely
                            }
                        }){
                            Text("Yes")
                                .frame(maxWidth: .infinity, maxHeight: 50)
                                .foregroundColor(Color.white)
                                .bold()
                                .background(Color.red)
                                .cornerRadius(100)
                        }
                        Button(action: {
                            deleteRowConfirm.toggle()
                        }){
                            Text("Close")
                                .frame(maxWidth: .infinity, maxHeight: 50)
                                .foregroundColor(Color.black)
                                .bold()
                                .cornerRadius(100)
                        }
                        
                    }
                    .padding(20)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
                }
                .sheet(isPresented: $openUploadPlot){
                    VStack{
                        Text("Upload Map")
                            .padding(.bottom, 20)
                            .font(Font.title.bold())
                        Spacer()
                        Image(systemName: "square.and.arrow.up.fill")
                            .resizable()
                            .frame(width: 100, height: 120)
                            .foregroundStyle(Color.green)
                            .symbolEffect(.pulse)
                        
                        Spacer()
                        Button(action: {
                            uploadDetails(context: modelContext)
                        }){
                            Text("Upload Now")
                                .frame(maxWidth: .infinity, maxHeight: 50)
                                .foregroundColor(Color.white)
                                .bold()
                                .background(Color.green)
                                .cornerRadius(100)
                        }
                    }
                    .padding(50)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
                }
                .sheet(isPresented: $loadsaving){
                    VStack{
                        ProgressView("Uploading...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .green))
                            .scaleEffect(1.5) // bigger
                            .padding()
                    }
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.hidden)
//                    .interactiveDismissDisabled(true)
                }
                .sheet(isPresented: $openAlreadyUploaded){
                    VStack{
                        
                        Image(systemName: "checkmark.arrow.trianglehead.counterclockwise")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(Color.green)
                        
                        Text("Already Uploaded")
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(Color.green)
                            .padding(.top, 20)
                        
                    }
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.hidden)
                }
            }
        }
    }
    
//    func uploadDataDet(pid: String){
//
//
//
//    }
    
}

#Preview {
    UploadedMaps()
}
