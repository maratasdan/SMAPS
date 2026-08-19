//
//  TabHome.swift
//  SMAPS
//
//  Created by Dan on 4/10/26.
//

import SwiftUI

struct TabHome: View {
    var body: some View {
        NavigationStack{
            
            TabView{
                
                PlotCreate()
                    .tabItem {
                        Image(systemName: "plus.square.on.square")
                    }
                
                PlotHome()
                    .tabItem {
                        Image(systemName: "list.bullet")
                    }
                
            }
            
            
        }
    }
}

#Preview {
    TabHome()
}
