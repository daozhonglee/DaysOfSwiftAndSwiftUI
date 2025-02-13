//
//  ContentView.swift
//  16.TumblrMenu
//
//  Created by shanquan on 2025/2/14.
//

import SwiftUI


struct ContentView02: View {
    var body: some View {
           NavigationView {
               VStack {
                   NavigationLink(destination: DetailView(name: "Kimi")) {
                       Text("Go to Detail View")
                           .padding()
                           .background(Color.blue)
                           .foregroundColor(.white)
                           .cornerRadius(10)
                   }
               }
               .navigationTitle("Home")
           }
       }
}

struct DetailView: View {
    let name: String

    var body: some View {
        VStack {
            Text("Hello,  \(name)!")
                .font(.largeTitle)
                .padding()
        }
        .navigationTitle("Detail")
    }
}


// 预览提供器，用于在Xcode中实时预览UI效果
#Preview {
    ContentView02()
}
