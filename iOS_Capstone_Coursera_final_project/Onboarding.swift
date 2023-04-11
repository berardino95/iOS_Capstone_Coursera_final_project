//
//  Onboarding.swift
//  iOS_Capstone_Coursera_final_project
//
//  Created by CHIARELLO Berardino - ADECCO on 11/04/23.
//

import SwiftUI

struct Onboarding: View {
    
    @State  private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    
    var body: some View {
        VStack(spacing: 20.0){
            
            Image("Logo")
                .padding(.bottom, 40)
            
            TextField("First name", text:$firstName)
                .textFieldStyle(OnboardingTextFieldStyle())
                
            TextField("Last name", text:$lastName)
                .textFieldStyle(OnboardingTextFieldStyle())
            
            TextField("Email", text:$email)
                .textFieldStyle(OnboardingTextFieldStyle())
            
        }
        .padding(/*@START_MENU_TOKEN@*/.all, 30.0/*@END_MENU_TOKEN@*/)
    }
}



//TextField Style
struct OnboardingTextFieldStyle : TextFieldStyle{
    func _body (configuration: TextField<Self._Label>) -> some View {
        ZStack{
            configuration
                .padding(10)
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(hex: 0x495E57), lineWidth: 1.5)
                .frame(height: 40)
        }
        

    }
}

//Hexadecimal color implementation
extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}



struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
