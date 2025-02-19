//
//  ContentView.swift
//  29.TwitterLikeSplash
//
//  Created by shanquan on 2025/2/19.
//

import SwiftUI

struct ContentView: View {
    // 控制 logo 的缩放和透明度动画
        @State private var logoScale: CGFloat = 1.0
        @State private var logoOpacity: Double = 1.0
        // 控制是否显示主视图
        @State private var showMainView = false

        var body: some View {
            ZStack {
                // 主内容视图，当动画结束后显示
                //
                if showMainView {
                    MainView()
                        .transition(.opacity)
                } else {
                    // Splash 屏幕背景和 logo
                    Color.white
                        .ignoresSafeArea()
                    Image("xlogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                }
            }
            .onAppear {
                // 动画流程：先等待0.5秒，再进行缩放和淡出动画，最后切换到主视图
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        logoScale = 1.5
                        logoOpacity = 0
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        showMainView = true
                    }
                }
            }
        }
}
struct MainView: View {
    var body: some View {
        NavigationView {
            Text("主内容视图")
                .font(.largeTitle)
                .navigationTitle("首页")
        }
    }
}
#Preview {
    ContentView()
}
