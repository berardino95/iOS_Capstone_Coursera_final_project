//
//  Menu.swift
//  iOS_Capstone_Coursera_final_project
//
//  Created by CHIARELLO Berardino - ADECCO on 11/04/23.
//
import CoreData
import SwiftUI

struct Menu: View {
    
    @State private var searchText: String = ""
    
    @Environment(\.managedObjectContext) private var viewContext
    //    @FetchRequest(sortDescriptors: buildSortDescriptor()) var dishes: FetchedResults<Dish>
    
    
    var body: some View {
        VStack{
            Image("Logo")
            VStack{
                HStack(alignment: .bottom){
                    VStack(alignment: .leading, spacing: 5.0) {
                        Text("Little Lemon")
                            .font(.largeTitle)
                            .foregroundColor(Color(hex: 0xF4CE14))
                        Text("Chicago")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(.bottom, 15)
                        Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry.")
                            .foregroundColor(.white)
                            .font(.callout)
                    }
                    
                    Image("HeroImage")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .cornerRadius(20)
                }
                .padding(.horizontal, 20)
                
                
                TextField("Search menu", text:$searchText)
                    .textFieldStyle(SearchBarStyle())
                    .autocorrectionDisabled(true)
            }
            .padding(.vertical,20)
            .background(Color(hex: 0x495E57))
            
            
            FetchedObjects(
                predicate:buildPredicate(),
                sortDescriptors: buildSortDescriptor()) { (dishes: [Dish]) in
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
                .scrollContentBackground(.hidden)
            
        }
        .padding(0)
        .onAppear{getMenuData()}
        
    }
    
    
    func buildPredicate() -> NSPredicate {
        if searchText.isEmpty {
            return NSPredicate(value: true)
        } else {
            return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        }
        
    }
    
    func buildSortDescriptor() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare))]
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



//TextField Style
struct SearchBarStyle : TextFieldStyle{
    func _body (configuration: TextField<Self._Label>) -> some View {
        ZStack{
            Rectangle()
                .stroke(Color(hex: 0x495E57), lineWidth: 1.5)
                .background(.white)
                .cornerRadius(10)
            HStack{
                Image(systemName: "magnifyingglass")
                configuration
            }
            .foregroundColor(.black)
            .padding(10)
        }
        .padding(.horizontal, 20)
        .frame(height: 40)
    }
    
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}
