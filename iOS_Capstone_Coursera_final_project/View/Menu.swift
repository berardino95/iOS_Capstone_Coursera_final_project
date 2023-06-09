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
    @State private var filterCategory: String = ""
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) var fetchedDishes: FetchedResults<Dish>
    
    @State private var categories : [String] = []
    @State private var categoriesDic : [String : Bool] = [:]

    
    var body: some View {
        VStack(spacing: 0){
                HStack(alignment: .center){
                    Spacer()
                    Spacer()
                    Image("Logo")
                    Spacer()
                    Image("Profile")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                .padding(.bottom, 10)
                .padding(.horizontal,20)
            
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
            
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    
                    ForEach(categories, id: \.self){ category in
                        if let category = category {
                            Button(category){
                                if !filterCategory.isEmpty && category == filterCategory {
                                    filterCategory = ""
                                    categoriesDic.keys.forEach { categoriesDic[$0] = false }
                                } else {
                                    filterCategory = category
                                    categoriesDic.keys.forEach { categoriesDic[$0] = false }
                                    categoriesDic[category] = true
                                }
                                
                                print("\(category):\(categoriesDic[category]!)")
                                print(categoriesDic)
                            }
                            .buttonStyle(CategoryButton(isSelected: categoriesDic[category] ?? false))
                        }
                    }
                }
                .padding(20)
            }
            
            
            FetchedObjects(
                predicate:buildPredicate(),
                sortDescriptors: buildSortDescriptor()) { (dishes: [Dish]) in
                    List{
                        ForEach(dishes){dish in
                            NavigationLink(destination: DishDetails(dish: dish)){
                                HStack{
                                    VStack(alignment: .leading, spacing: 5){
                                        Text(dish.title ?? "Title")
                                            .font(.title2)
                                        Text(dish.itemDescription ?? "Description")
                                            .font(.subheadline)
                                            .lineLimit(2)
                                        Text("\(dish.price ?? "Price") €")
                                            .font(.title3)
                                            .foregroundColor(Color(hex: 0x495E57))
                                    }
                                    
                                    Spacer()
                                    
                                    AsyncImage(url: URL(string: dish.image!)){ image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        Color.gray
                                    }
                                    .frame(width:80, height: 80)
                                    .cornerRadius(10)
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .listSectionSeparatorTint(Color(hex: 0x495E57))
        }
        .onAppear{
            getMenuData()
            categories = getCategory(from: fetchedDishes)
            categoriesDic = Dictionary(uniqueKeysWithValues: categories.map{ ($0, false) })
        }
        
    }
    
    
    func buildPredicate() -> NSPredicate {
        if searchText.isEmpty && (filterCategory.isEmpty || filterCategory == "all") {
            return NSPredicate(value: true)
        } else if  filterCategory.isEmpty && !searchText.isEmpty {
            return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        } else if searchText.isEmpty && !filterCategory.isEmpty {
            return NSPredicate(format: "category CONTAINS[cd] %@", filterCategory)
        } else if searchText.isEmpty && filterCategory == "all"{
            return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        } else if !searchText.isEmpty && filterCategory == "all"{
            return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            
        } else {
            return NSPredicate(format: "(title CONTAINS[cd] %@) AND (category CONTAINS[cd] %@)", searchText, filterCategory)
        }
        
    }
    
    func getCategoryDictionary(from categories:[String]) -> [String:Bool] {
        var cat : [String:Bool] = [:]
        for category in categories {
            if cat[category] != nil {
                continue
            } else {
                cat[category] = true
            }
        }
        cat["all"] = true
        return cat
    }
    
    func getCategory(from dishes:FetchedResults<Dish>) -> [String] {
        var cat : [String] = []
        for dish in dishes {
            if let category = dish.category {
                if !cat.contains(category){
                    cat.append(category)
                } else {
                    continue
                }
            }
        }
        cat.append("all")
        return cat
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

//Button style
struct CategoryButton: ButtonStyle {
    var isSelected : Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(10)
            .background(isSelected ? Color(hex: 0xF4CE14) : Color(hex: 0x495E57))
            .cornerRadius(10)
        
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
