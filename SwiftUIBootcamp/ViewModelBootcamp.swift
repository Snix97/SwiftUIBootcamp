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
    
    init() {
        getFruits()
    }
    
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
     update our view. The VM now contains all the logic so cleaner View code,
     it just deals with the UI.
     
     DOWNSIDE - If View refreshes/reloads the observedObject would also reload.
     Not good if a VM is downloading data as if its not required to be fetched
     again it just needs to persist. It this case use @StateObject = PERSISTENCE
     
     @StateObject - Use this on creation of VM / init
     @ObservedObject - Use this when passing to subviews
    
     */
    
    //@ObservedObject var fruitViewModel: FruitViewModel = FruitViewModel()
    @StateObject var fruitViewModel: FruitViewModel = FruitViewModel()
    
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
            .navigationBarItems(trailing:
                NavigationLink(destination: {
                NextScreen(fruitViewModel: fruitViewModel)
                }, label: {
                    Image(systemName: "arrow.right")
                })
            )
            
            //This is called every time this screen loads so don't have the data fetch call here
            .onAppear {
                //fruitViewModel.getFruits()
            }
            
        }
    }
}

struct NextScreen: View {
    
    //Creates an environment property to read the specified key path
    @Environment(\.presentationMode) var presentationMode
    
    //Use @ObservedObject here as we're passing the VM to a second screen it already exists 
    @ObservedObject var fruitViewModel: FruitViewModel
    
    var body: some View {
        ZStack {
            Color.green.ignoresSafeArea()
            
            VStack {
                
                ForEach(fruitViewModel.fruitArray) { fruit in
                    Text(fruit.name)
                        .foregroundColor(.white)
                        .font(.headline)
                }
                Spacer()
                
                Button {
                    //wrappedValue property provides primary access to the value's data
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("GO BACK")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                }
            }
            .padding(30)
        }
    }
}

#Preview {
    ViewModelBootcamp()
}

/*
In SwiftUI, while both @ObservedObject and @StateObject are used to observe changes
in an ObservableObject, the key difference is that @ObservedObject is used when you
receive an existing observable object from outside a view, while @StateObject is used to
create and manage an observable object within a single view, ensuring its lifecycle is
tied to the view itself; essentially, @ObservedObject observes an object you don't own,
while @StateObject creates and owns the object within the view.
 
 Key points:Ownership:
 @ObservedObject: When using @ObservedObject, the view does not own the observable object, it simply observes changes to it.
 
 @StateObject: When using @StateObject, the view is responsible for creating and managing the lifecycle of the observable object.
 
 Usage scenarios:
 @ObservedObject: Pass an observable object from a parent view to a child view.
 @StateObject: Create a view model within a view that needs to persist its state even when the view is redrawn.

 */
