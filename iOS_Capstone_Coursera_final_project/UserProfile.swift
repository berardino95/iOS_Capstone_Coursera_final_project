//
//  UserProfile.swift
//  iOS_Capstone_Coursera_final_project
//
//  Created by CHIARELLO Berardino - ADECCO on 12/04/23.
//

import SwiftUI

struct UserProfile: View {
    
    let k = K()
    let defaults = UserDefaults.standard
    @Environment(\.presentationMode) var presentation
    @State var isLoggedIn = false
    
    
    var body: some View {
        
        let firstName = defaults.object(forKey: k.firstName) as? String ?? String()
        let lastName = defaults.object(forKey: k.lastName) as? String ?? String()
        let email = defaults.object(forKey: k.email) as? String ?? String()
        
        NavigationStack{
            VStack(alignment: .center){
                Text("Personal information")
                    .fontWeight(.bold)
                    .font(.title2)
                
                Image("Profile")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .padding(.top,20)
                
                Text("\(firstName) \(lastName)")
                    .padding(.top,20)
                Text(email)
                    .padding(.top,1)
                
                Text("Test")
                
                Spacer()
                    .frame(height: 30)
                
                Button("Logout", action: logout )
                    .buttonStyle(LogOutButton())
                
                Spacer()
            }
            .padding(10)
            .padding(.horizontal,30)
        }
    }
    
    func logout(){
        defaults.set(false, forKey: k.isLoggedIn)
        self.presentation.wrappedValue.dismiss()
    }
}


//Button style
struct LogOutButton: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(configuration.isPressed ? Color(hex: 0xF4CE14) : Color(hex: 0x495E57))
            .cornerRadius(10)
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile()
    }
}
