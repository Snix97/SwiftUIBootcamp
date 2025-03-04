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

//ObservableObject protocol indicated that this class is Observable
class FruitViewModel: ObservableObject {
    
    /*Use @Published because we are in a class, but it does the same as @State.
     If the fruitArray gets changed it notifies the viewModel that updates are
     needed so needs to publish the changes
     */
    @Published var fruitArray: [FruitModel] = []
    @Published var isLoading: Bool = false
    
    func getFruits() {
        let fruit1 = FruitModel(name: "Apples", count: 6)
        let fruit2 = FruitModel(name: "Pears", count: 1)
        let fruit3 = FruitModel(name: "Orange", count: 2)
        let fruit4 = FruitModel(name: "Banana", count: 5)
        
        //Simulate time consumming network call
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.fruitArray.append(fruit1)
            self.fruitArray.append(fruit2)
            self.fruitArray.append(fruit3)
            self.fruitArray.append(fruit4)
            
            self.isLoading = false
        }
        
    }
    
    func deleteFruit(index: IndexSet) {
        fruitArray.remove(atOffsets: index)
    }
}

struct ViewModelBootcamp: View {
    
   //Can only use @State when your in a Struct View NOT a class
   // @State var fruitArray: [FruitModel] = []
    
    /*@ObservedObject used to indicate that if the VM changes we will need to
     update our view. The VM now contains all the logic so cleaner View code, it just deals with the UI.
     */
    @ObservedObject var fruitViewModel: FruitViewModel = FruitViewModel()
    
    var body: some View {
        NavigationView {
            List {
                
                if fruitViewModel.isLoading {
                    ProgressView()
                } else {
                    ForEach(fruitViewModel.fruitArray) { fruit in
                        HStack {
                            Text("\(fruit.count)")
                                .foregroundColor(.red)
                            Text(fruit.name)
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                        }
                    }
                    .onDelete(perform: fruitViewModel.deleteFruit)
                }
            }
            .listStyle(DefaultListStyle())
            .navigationTitle("Fruit List")
            .onAppear {
                fruitViewModel.getFruits()
            }
            
        }
    }
}


#Preview {
    ViewModelBootcamp()
}
