//
//  Menu.swift
//  iOS_Capstone_Coursera_final_project
//
//  Created by CHIARELLO Berardino - ADECCO on 11/04/23.
//
import CoreData
import SwiftUI

struct Menu: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) var dishes: FetchedResults<Dish>
    
    var body: some View {
        VStack{
            
            VStack(spacing: 30.0) {
                Image("Logo")
                Text("Chicago")
                Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.")
            }
            .padding(20)
            
            List{
                ForEach(dishes){dish in
                    NavigationLink(destination: DishDetails(dish: dish)){
                        HStack{
                            Text("\(dish.title ?? "Title") \(dish.price ?? "0,00")$")
                            Spacer()
                            AsyncImage(url: URL(string: dish.image!)){ image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width:50, height: 50)
                            .cornerRadius(10)
                            
                        }
                        
                    }
                }
            }
            
        }
        
        .padding(0)
        .onAppear{getMenuData()}
        
    }
    
    func getMenuData() {
        
        guard let url = URL(string: "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json") else { return }
        
        let task = URLSession.shared.dataTask(with: url){
            data, response, error in
            let decoder = JSONDecoder()
            
            if let data = data{
                do{
                    let tasks = try decoder.decode(MenuList.self, from: data)
                    
                    for item in tasks.menu {
                        if !isExist(id: item.id) {
                            let menuItem = Dish(context: viewContext)
                            menuItem.title = item.title
                            menuItem.category = item.category
                            menuItem.id = Int64(item.id)
                            menuItem.image = item.image
                            menuItem.price = item.price
                            menuItem.itemDescription = item.itemDescription
                        }
                        else{
                            return
                        }
                    }
                
                try? viewContext.save()
            } catch {
                print(error)
            }
        }
    }
    task.resume()
}
    
    func isExist(id: Int) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Dish")
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)

        let res = try! viewContext.fetch(fetchRequest)
        return res.count > 0 ? true : false
    }

}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}
