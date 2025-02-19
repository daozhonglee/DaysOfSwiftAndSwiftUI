//
//  ContentView.swift
//  29.TwitterLikeSplash
//
//  Created by shanquan on 2025/2/19.
//

import SwiftUI

/// Twitter风格的启动页面动画效果
/// 本示例展示了如何使用SwiftUI实现一个类似Twitter的启动页面过渡动画
/// 主要技术点包括：
/// - 使用@State管理视图状态和动画
/// - ZStack实现视图层叠布局
/// - SwiftUI动画和过渡效果
/// - 异步延时执行动画序列
struct ContentView: View {
    /// 控制logo缩放比例的状态变量
    /// 初始值为1.0，动画过程中会增加到1.5
    @State private var logoScale: CGFloat = 1.0
    
    /// 控制logo透明度的状态变量
    /// 初始值为1.0（完全不透明），动画过程中会降低到0（完全透明）
    @State private var logoOpacity: Double = 1.0
    
    /// 控制是否显示主视图的状态变量
    /// 当启动动画完成后，此值变为true，触发主视图的显示
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
