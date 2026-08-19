import SwiftUI
import UniformTypeIdentifiers
import SwiftData

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var selectedURL: URL?

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker

        init(_ parent: DocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.selectedURL = urls.first
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.selectedURL = nil
        }
    }
}

// ✅ Rename view to avoid clash
struct FileManager: View {
    
    @State private var showingPicker = false
    @State private var selectedURL: URL?
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var myfile: [MyFile]

    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                List(myfile){ myf in
                    NavigationLink(destination: ViewImage(fileName: myf.fileName)){
                        HStack{
                            Image(systemName: "photo.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(Color.green)
                            
                            VStack(alignment: .leading){
                                Text("\(myf.fileName)")
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    .bold()
                                Text("Date Added")
                                    .font(.footnote)
                            }
                        }
                    }
                }
                
                Button(action: {
                    showingPicker = true
                }){
                    Label("Insert File", systemImage: "plus")
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .foregroundColor(.white)
                        .bold()
                        .background(Color.green)
                        .cornerRadius(100)
                }
                .padding()
                
                // File save handled in onChange to avoid side-effects in body.
            }
        }
        .sheet(isPresented: $showingPicker) {
            DocumentPicker(selectedURL: $selectedURL)
        }
        .onChange(of: selectedURL) { _, newValue in
            guard let url = newValue else {
                return
            }

            do {
                let data = try Data(contentsOf: url)
                saveFile(data: data, fileName: url.lastPathComponent, context: modelContext)
            } catch {
                print("Error reading file: \(error)")
            }

            selectedURL = nil // reset to avoid multiple saves
        }
    }
    
    func saveFile(data: Data, fileName: String, context: ModelContext) {
        let documentsURL = Foundation.FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            
            // Save sa SwiftData
            let newFile = MyFile(fileName: fileName, filePath: fileURL.path)
            context.insert(newFile)
            
            try context.save()
            
            print("Saved file + path 😏")
            
        } catch {
            print("Error saving file: \(error)")
        }
    }
}

#Preview {
    FileManager()
}
