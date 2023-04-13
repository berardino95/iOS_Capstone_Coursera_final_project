//
//  MenuItem.swift
//  iOS_Capstone_Coursera_final_project
//
//  Created by CHIARELLO Berardino - ADECCO on 13/04/23.
//

import Foundation

struct MenuItem : Decodable {
    
    enum CodingKeys: String, CodingKey {
        case title, image, price, category, itemDescription = "description", id
    }
    
    let title: String
    let image: String
    let price: String
    let itemDescription: String
    let category: String
    let id: Int
}
