//
//  StateBootcamp.swift
//  SwiftUIBootcamp
//
//  Created by Claire Roughan on 05/03/2025.
//

/*
 https://www.hackingwithswift.com/quick-start/swiftui/what-is-the-state-property-wrapper
 
 SwiftUI uses the @State property wrapper to allow us to modify values
 inside a struct, which would normally not be allowed because structs are
 value types.

 When we put @State before a property, we effectively move its storage out
 from our struct and into shared storage managed by SwiftUI. This means
 SwiftUI can destroy and recreate our struct whenever needed (and this can
 happen a lot!), without losing the state it was storing.

 @State should be used with simple struct types such as String, Int, and
 arrays, and generally shouldn’t be shared with other views. If you want
 to share values across views, you should probably use @ObservedObject or
 @EnvironmentObject instead – both of those will ensure that all views will
 be refreshed when the data changes.

 To re-enforce the local nature of @State properties, Apple recommends you
 mark them as private
 
 Tip: You can use @State to track reference types if you want, you just
 won’t be notified when they change. This is particularly helpful for
 classes that don’t conform to the ObservableObject protocol.
 */


import SwiftUI

struct StateBootcamp: View {
    
    /*
     To change the backgroundColour on button click need to add @State as
     in SwiftUI we need to let the view know the property has changed.
     */
    
    @State private var backgroundColour = Color.green
    @State private var title: String = "My Title"
    @State private var count: Int = 0
    
    var body: some View {
        ZStack {
            // background
            backgroundColour.ignoresSafeArea()
            
            // content
            VStack(spacing: 20) {
                Text(title)
                    .font(.title)
                Text("Count: \(count)")
                    .font(.headline)
                    .underline()
                
                HStack(spacing: 20) {
                    
                    Button("Button 1") {
                        backgroundColour = Color.blue
                        title = "Button 1 press"
                        count += 1
                    }
                    Button("Button 2") {
                        backgroundColour = Color.purple
                        title = "Button 2 press"
                        count -= 1
                    }
                }
            }
        }
        .foregroundColor(.white)
    }
}

#Preview {
    StateBootcamp()
}
