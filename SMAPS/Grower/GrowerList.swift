//
//  GrowerList.swift
//  SMAPS
//
//  Created by danxd on 6/16/26.
//

import SwiftUI
import SwiftData

struct GrowerList: View {
    
    @Query private var userlist: [AddUserData]
    
    @State private var name = "Dan"
    
    
    
    var body: some View {
        NavigationStack {
            
            if userlist.isEmpty {
                VStack {
                    Text("No User Registered Yet!")
                }
            }else{
                List(userlist) { user in
                    
                    HStack{
                        ProfileCircleInitial(imgName: "", fname: user.firstName, lname: user.lastName)
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(user.firstName) \(user.lastName)")
                                    .bold()
                                Text("\(user.city), \(user.province)")
                                    .font(.footnote)
                                
                            }
                        }
                    }
                }
                
            }
        }
    }
}

struct ProfileCircleInitial: View {
    
    let imgName: String
    let fname: String
    let lname: String
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 50, height: 50)
                .foregroundStyle(Color.green)
            HStack{
                Text("\(String(fname.prefix(1)))\(String(lname.prefix(1)))")
                    .bold()
                    .foregroundStyle(Color.white)
                    .font(.title2)
            }
            
        }
    }
}

#Preview {
    GrowerList()
}
