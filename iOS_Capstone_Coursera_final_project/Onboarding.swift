//
//  Onboarding.swift
//  iOS_Capstone_Coursera_final_project
//
//  Created by CHIARELLO Berardino - ADECCO on 11/04/23.
//

import SwiftUI

let k = K()

struct Onboarding: View {
    
    @Environment(\.presentationMode) var presentation
    
    @State  private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State var isShowed : Bool = false
    @State var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color(hex: 0xEDEFEE)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading){
                    
                    HStack{
                        Spacer()
                        Image("Logo")
                            .padding(.bottom, 40)
                        Spacer()
                    }
                    
                    Text("First Name")
                        .padding(.leading, 10)
                    TextField("Enter First name...", text:$firstName)
                        .textFieldStyle(OnboardingTextFieldStyle())
                        .autocorrectionDisabled(true)
                    
                    Text("Last Name")
                        .padding(.leading, 10)
                    TextField("Enter Last name...", text:$lastName)
                        .textFieldStyle(OnboardingTextFieldStyle())
                        .autocorrectionDisabled(true)
                    
                    Text("Email")
                        .padding(.leading, 10)
                    TextField("Enter Email...", text:$email)
                        .textFieldStyle(OnboardingTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                    
                    Button("Register", action: buttonPressed )
                        .buttonStyle(RegisterButton(isShowed: $isShowed))
                    
                    Spacer()
                }
                .padding(.all, 30.0)
            }
            .onAppear{
                isLoggedIn = UserDefaults.standard.bool(forKey: k.isLoggedIn)
                
            }
            .navigationDestination(isPresented: $isLoggedIn) {
                Home().navigationBarBackButtonHidden(true)
            }
            
        }
        
    }
    
    public func buttonPressed() {
        if (firstName.isEmpty || lastName.isEmpty || email.isEmpty) {
            isShowed.toggle()
            
        } else{
            
            isLoggedIn = true
            let defaults = UserDefaults.standard
            defaults.set(firstName, forKey: k.firstName)
            defaults.set(lastName, forKey: k.lastName)
            defaults.set(email, forKey: k.email)
            defaults.set(true, forKey: k.isLoggedIn)
            
            firstName = "" ; lastName = "" ; email = ""
            
        }
    }
}



//Button style
struct RegisterButton: ButtonStyle {
    
    @Binding var isShowed: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(configuration.isPressed ? Color(hex: 0xF4CE14) : Color(hex: 0x495E57))
            .cornerRadius(10)
            .alert("Something is empty", isPresented: $isShowed) {
                Button("OK", role: .cancel){}
            }
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
        .padding(.bottom, 20)
        
        
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
