//
//  Onboarding.swift
//  iOS_Capstone_Coursera_final_project
//
//  Created by CHIARELLO Berardino - ADECCO on 11/04/23.
//

import SwiftUI

var kFirstName = "FirstName"
var kLastName = "LastName"
var kEmail = "email"

struct Onboarding: View {
    
    @State  private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State var isShowed : Bool = false
    @State private var isLoggedIn: Bool = false
    
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
                        .buttonStyle(MyButton(isShowed: $isShowed))
                    
                    Spacer()
                }
                .padding(.all, 30.0)
            }
            .navigationDestination(isPresented: $isLoggedIn) {
                Home()
            }
        }
        
    }
    
    public func buttonPressed() {
        if (firstName.isEmpty || lastName.isEmpty || email.isEmpty) {
            isShowed.toggle()
            isLoggedIn = false
            
        } else{
            let defaults = UserDefaults.standard
            defaults.set(firstName, forKey: kFirstName)
            defaults.set(lastName, forKey: kLastName)
            defaults.set(email, forKey: kEmail)
            
            print(defaults.object(forKey: kFirstName) as? String ?? String())
            print(defaults.object(forKey: kLastName) as? String ?? String())
            print(defaults.object(forKey: kEmail) as? String ?? String())
            print("saved")
            
            isLoggedIn = true
        }
    }
}



//Button style
struct MyButton: ButtonStyle {
    
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
