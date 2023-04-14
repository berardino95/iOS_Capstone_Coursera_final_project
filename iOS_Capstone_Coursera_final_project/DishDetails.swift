//
//  DishDetails.swift
//  iOS_Capstone_Coursera_final_project
//
//  Created by CHIARELLO Berardino - ADECCO on 14/04/23.
//

import SwiftUI

struct DishDetails: View {
    
    @State var dish: Dish
    
    var body: some View {
        GeometryReader{ geo in
            VStack{
                
                Text(dish.title ?? "Title")
                    .font(.title)
                    .fontWeight(.heavy)
                
                AsyncImage(url: URL(string: dish.image!)){ image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray
                }
                .frame(width: geo.size.width, height: geo.size.height/2)
                .cornerRadius(10)
                
                HStack{
                    Text("Price")
                    Spacer()
                    Text("\(dish.price ?? "0.00") €")
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                
                Text(dish.itemDescription ?? "Missing description")
                    .padding(.horizontal, 30)
                Spacer()
            }
        }
    }
}

struct DishDetails_Previews: PreviewProvider {
    static var previews: some View {
        DishDetails(dish: Dish())
    }
}
