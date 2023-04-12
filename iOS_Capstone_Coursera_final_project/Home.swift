//
//  Home.swift
//  iOS_Capstone_Coursera_final_project
//
//  Created by CHIARELLO Berardino - ADECCO on 11/04/23.
//

import SwiftUI

struct Home: View {
    var body: some View {
        TabView {
            Menu()
                .tabItem{
                    Label("Menù", systemImage: "list.dash")
                }
            UserProfile()
                .tabItem{
                    Label("Profile", systemImage: "square.and.pencil")
                }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
