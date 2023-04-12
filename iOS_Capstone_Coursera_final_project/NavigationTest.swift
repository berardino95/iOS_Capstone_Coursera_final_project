//
//  NavigationTest.swift
//  iOS_Capstone_Coursera_final_project
//
//  Created by CHIARELLO Berardino - ADECCO on 11/04/23.
//

import SwiftUI

struct NavigationTest: View {
    
        @State private var showDetails = false
    
    var body: some View {

        NavigationStack {
            VStack {
                Circle()
                    .fill(.red)
                Button("Show details") {
                    showDetails = true
                }
            }
            .navigationDestination(isPresented: $showDetails) {
                Rectangle()
            }
            .navigationTitle("My Favorite Color")
        }
    }
}


struct NavigationTest_Previews: PreviewProvider {
    static var previews: some View {
        NavigationTest()
    }
}
