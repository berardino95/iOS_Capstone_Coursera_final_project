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
            VStack(spacing: 0){
                
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
                Spacer()
                VStack(alignment: .leading, spacing: 20){
                    Text(dish.itemDescription ?? "Missing description")
                        
                        .font(.title3)
                    Text("\(dish.price ?? "Price") €")
                        .font(.title2)
                }
                Spacer()
                Spacer()
                Spacer()
            }
        }
    }
}

struct DishDetails_Previews: PreviewProvider {
    static var previews: some View {
        DishDetails(dish: .preview())
    }
}
