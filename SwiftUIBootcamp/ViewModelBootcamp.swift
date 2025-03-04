//
//  ViewModelBootcamp.swift
//  SwiftUIBootcamp
//
//  Created by Claire Roughan on 04/03/2025.
//

/*
 How to use @StateObject and @ObservableObject
 
 PropertyWrappers that are used to observe other classes
 in an app and update views in realtime.
 
 @State = is used for variables in a single view, but @StateObject is used to reference another class.
 */

import SwiftUI

//Identifiable - SwiftUI needs to know how it can identify each item uniquely
struct FruitModel: Identifiable {
    var id: String = UUID().uuidString
    let name: String
    let count: Int
}

struct ViewModelBootcamp: View {
    
    @State var fruitArray: [FruitModel] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(fruitArray) { fruit in
                    HStack {
                        Text("\(fruit.count)")
                            .foregroundColor(.red)
                        Text(fruit.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                    }
                }
                .onDelete(perform: deleteFruit)
                }
            }
            .listStyle(DefaultListStyle())
            .navigationTitle("Fruit List")
            .onAppear {
                getFruits()
            }
            
        }
       
    func getFruits() {
        let fruit1 = FruitModel(name: "Apples", count: 6)
        let fruit2 = FruitModel(name: "Pears", count: 1)
        let fruit3 = FruitModel(name: "Orange", count: 2)
        let fruit4 = FruitModel(name: "Banana", count: 5)
        
        fruitArray.append(fruit1)
        fruitArray.append(fruit2)
        fruitArray.append(fruit3)
        fruitArray.append(fruit4)
    }
    
    func deleteFruit(index: IndexSet) {
        fruitArray.remove(atOffsets: index)
    }
    
}

#Preview {
    ViewModelBootcamp()
}
