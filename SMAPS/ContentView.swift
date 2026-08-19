//
//  ContentView.swift
//  SMAPS
//
//  Created by Dan on 4/1/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            ZStack {
                Image("SSCBG")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    Spacer()
                    NavigationLink(destination: Home()){
                        Text("Plot Now")
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: 300)
                            .background(Color.green)
                            .foregroundStyle(Color.white)
                            .bold()
                            .cornerRadius(30)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
