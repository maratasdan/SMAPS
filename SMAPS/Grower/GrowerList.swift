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
                    
                    NavigationLink(destination: GrowersInfo(userid: user.userid)) {
                        HStack{
                            ProfileCircleInitial(imgName: "", fname: user.firstName, lname: user.lastName, status: user.status ?? "0")
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(user.firstName) \(user.lastName)")
                                        .bold()
                                    Text(user.userid)
                                        .font(.system(size: 7))
                                        .foregroundStyle(Color.secondary)
                                }
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
    let status: String
    
    var body: some View {
        ZStack {
            
            if status == "1" {
                Circle()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(Color.green)
            } else {
                Circle()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(Color.red)
            }
           
                
            VStack {
                HStack{
                    Text("\(String(fname.prefix(1)))\(String(lname.prefix(1)))")
                        .bold()
                        .foregroundStyle(Color.white)
                        .font(.title2)
                }
            }
            
        }
    }
}

#Preview {
    GrowerList()
}
