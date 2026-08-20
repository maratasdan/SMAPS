//
//  TrackPerson.swift
//  SMAPS
//
//  Created by Dan on 4/6/26.
//

import SwiftUI

struct TrackPerson: View {
    var body: some View {
        
        NavigationStack{
            
            VStack {
                
                Image(systemName: "mappin.and.ellipse.circle")
                    .font(.largeTitle)
                    .foregroundStyle(Color.green)
                    .padding(.bottom, 20)
                
                Text("Personnel Locator")
                    .font(.title2)
                    .bold()
                
                List {
                    NavigationLink(destination: TrackPerson()) {
                        HStack {
                            
                            Image(systemName: "person.circle")
                                .font(.largeTitle)
                                .foregroundStyle(Color.green)
                            
                            VStack(alignment: .leading){
                                Text("Person 1")
                                    .bold()
                                Text("Last seen: 10:00 AM")
                                    .font(.footnote)
                            }
                        }
                        
                    }
                    
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
                .padding(.top, 20)
                
                Spacer()
                
            }
            .padding()
            
        }
        
    }
}

#Preview {
    TrackPerson()
}
