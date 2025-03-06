//
//  BindingBootcamp.swift
//  SwiftUIBootcamp
//
//  Created by Claire Roughan on 05/03/2025.
//

import SwiftUI

struct BindingBootcamp: View {
    
    @State private var backgoundColour = Color.green
    @State private var title: String = "Title"
    
    var body: some View {
        
        ZStack {
            backgoundColour.ignoresSafeArea()

            //Denotes that the @State var is Binding elsewhere with $ sign child view uses a variable that parentview declares
            VStack {
                Text(title)
                    .foregroundColor(.white)
                ButtonView(backgoundColour: $backgoundColour, title: $title)
            }

        }
    }
}

struct ButtonView: View {
    
    // @Binding = Subview need to have access the backgroundColour and title in the parentview or anywhere else
    @Binding var backgoundColour: Color
    @Binding var title: String
    
    //@State manages private data within a view
    @State private var buttonColour = Color(.yellow)
    
    var body: some View {
        Button(action:  {
            backgoundColour = Color.pink
            buttonColour = Color.black
            title = "New Title!"
        }, label: {
            Text("Button")
                .foregroundColor(.white)
                .padding()
                .padding(.horizontal)
                .background(buttonColour)
                .cornerRadius(10)
        })
    }
}

#Preview {
    BindingBootcamp()
}


