//
//  Grower.swift
//  SMAPS
//
//  Created by Danxd on 6/15/26.
//

import SwiftUI

struct Grower: View {
    var body: some View {
        NavigationStack {
            List {
                Section("") {
                    NavigationLink(destination: AddUser()){
                        HStack{
                            ProfileCircle(imgName: "person.fill.badge.plus")
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Add User")
                                        .bold()
                                }
                            }
                        }
                    }
                    NavigationLink(destination: GrowerList()){
                        HStack{
                            ProfileCircle(imgName: "list.dash")
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("List of Growers")
                                        .bold()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ProfileCircle: View {
    
    let imgName: String
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 50, height: 50)
                .foregroundStyle(Color.green)
            
            Image(systemName: imgName)
                .foregroundStyle(Color.white)
                .font(.title)
        }
    }
}

#Preview {
    Grower()
}
