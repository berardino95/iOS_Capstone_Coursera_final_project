//
//  iOS_Capstone_Coursera_final_projectApp.swift
//  iOS_Capstone_Coursera_final_project
//
//  Created by CHIARELLO Berardino - ADECCO on 11/04/23.
//

import SwiftUI

@main
struct iOS_Capstone_Coursera_final_projectApp: App {
    @StateObject private var dataController = PersistenceController()
    
    var body: some Scene {
        WindowGroup {
            Onboarding()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
