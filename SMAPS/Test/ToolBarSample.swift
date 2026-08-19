//
//  ToolBarSample.swift
//  SMAPS
//
//  Created by Dan on 4/8/26.
//

import SwiftUI

struct ToolBarSample: View {
    var body: some View {
        VStack{
            
            Text("Hello, meg!")
                .navigationTitle("Home")
                .toolbar {
                    
                    // Left side button
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            print("Menu tapped")
                        }) {
                            Image(systemName: "line.3.horizontal")
                        }
                    }
                    
                    // Right side button
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            print("Add tapped")
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                    
                    // Bottom toolbar
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button("Edit") {
                            print("Edit tapped")
                        }
                        
                        Spacer()
                        
                        Button("Delete") {
                            print("Delete tapped")
                        }
                    }
                }
                .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)

            Spacer()
            
            VStack{
                Text("Hello")
            }
        }
    }
}

#Preview {
    ToolBarSample()
}
