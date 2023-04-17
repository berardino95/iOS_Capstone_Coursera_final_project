//
//  Dish+CoreDataProperties.swift
//  iOS_Capstone_Coursera_final_project
//
//  Created by CHIARELLO Berardino - ADECCO on 13/04/23.
//
//

import Foundation
import CoreData


extension Dish {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dish> {
        return NSFetchRequest<Dish>(entityName: "Dish")
    }

    @NSManaged public var category: String?
    @NSManaged public var id: Int64
    @NSManaged public var image: String?
    @NSManaged public var itemDescription: String?
    @NSManaged public var price: String?
    @NSManaged public var title: String?

}

extension Dish : Identifiable {

}

extension Dish {
    @discardableResult
    static func makePreview(count: Int,in context: NSManagedObjectContext) -> [Dish] {
        var dishes = [Dish]()
        for i in 0..<count {
            let dish = Dish(context: context)
            dish.category = "Category \(i)"
            dish.itemDescription = "Lorem ipsum dolo sit amet"
            dish.price = "12,20"
            dish.title = "Title \(i)"
            dish.image = "HTTPS \(i)"
            dish.id = Int64(i)
            dishes.append(dish)
        }
        return dishes
    }
    
    static func preview(context: NSManagedObjectContext = PersistenceController.shared.viewContext) -> Dish {
        return makePreview(count: 1, in: context)[0]
    }

    static func emptyPreview(context: NSManagedObjectContext = PersistenceController.shared.viewContext) -> Dish {
        return Dish(context: context)
    }
    
}
