import SwiftUI
import UIKit

struct ViewImage: View {
    
    let fileName: String
    
    private func loadImage(fileName: String) -> UIImage? {
        // get Documents folder path
        let documentsURL = Foundation.FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    var body: some View {
        NavigationStack{
            VStack {
                if let uiImage = loadImage(fileName: fileName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 400)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .foregroundColor(.gray)
                }
                
                Text(fileName)
                    .bold()
                    .padding(.top, 10)
            }
            .padding()
        }
    }
}

#Preview {
    ViewImage(fileName: "test.png") // <-- filename saved sa Documents
}
