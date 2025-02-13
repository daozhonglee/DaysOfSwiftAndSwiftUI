//
//  ContentView.swift
//  16.TumblrMenu
//
//  Created by shanquan on 2025/2/14.
//

import SwiftUI


struct ContentView03: View {
    let items = ["Item 1", "Item 2", "Item 3"]

       var body: some View {
           NavigationView {
               List(items, id: \.self) { item in
                   NavigationLink(destination: DetailView02(item: item)) {
                       Text(item)
                   }
               }
               .navigationTitle("Items")
           }
       }
}

struct DetailView02: View {
    let item: String

       var body: some View {
           VStack {
               Text("Detail View for  \(item)")
                   .font(.largeTitle)
                   .padding()
           }
           .navigationTitle("Detail")
       }
}


// 预览提供器，用于在Xcode中实时预览UI效果
#Preview {
    ContentView03()
}
