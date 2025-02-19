//
//  ContentView.swift
//  26.SideNavigation
//
//  Created by shanquan on 2025/2/19.
//

import SwiftUI

// MARK: - 侧边菜单视图
/// 实现一个可滑动的侧边导航菜单
/// 包含用户头像、菜单项列表等内容
/// 使用SwiftUI的原生视图组件构建
struct SideMenu: View {
    var body: some View {
        VStack(alignment: .leading) {
            // 菜单头部（可以放头像、用户名等）
            HStack {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
                Text("用户名")
                    .font(.title2)
                    .bold()
            }
            .padding(.top, 50)
            .padding(.horizontal, 20)

            Divider()
                .padding(.vertical, 10)

            // 菜单项
            VStack(alignment: .leading, spacing: 20) {
                Button(action: {
                    // “首页”操作
                }) {
                    HStack {
                        Image(systemName: "house")
                            .frame(width: 32, height: 32)
                        Text("首页")
                            .font(.headline)
                    }
                }
                Button(action: {
                    // “个人中心”操作
                }) {
                    HStack {
                        Image(systemName: "person")
                            .frame(width: 32, height: 32)
                        Text("个人中心")
                            .font(.headline)
                    }
                }
                Button(action: {
                    // “设置”操作
                }) {
                    HStack {
                        Image(systemName: "gear")
                            .frame(width: 32, height: 32)
                        Text("设置")
                            .font(.headline)
                    }
                }
            }
            .padding(.horizontal, 20)

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.systemGray6))
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: - 主内容视图
/// 应用的主要内容区域
/// 包含导航栏和内容区
/// 通过绑定的isMenuOpen状态控制侧边栏的显示与隐藏
struct MainView: View {
    @Binding var isMenuOpen: Bool

    var body: some View {
        NavigationView {
            VStack {
                Text("主内容区域")
                    .font(.largeTitle)
                    .padding()
                Spacer()
            }
            .navigationBarTitle("首页", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                withAnimation(.easeInOut) {
                    isMenuOpen.toggle()
                }
            }, label: {
                Image(systemName: "line.horizontal.3")
                    .imageScale(.large)
            }))
        }
    }
}

// MARK: - 容器视图
/// 将侧边菜单和主内容视图组合在一起的容器视图
/// 管理整体布局和动画效果
/// - 使用ZStack叠加布局
/// - 通过状态变量isMenuOpen控制菜单的显示/隐藏
/// - 实现平滑的动画过渡效果
struct ContentView: View {
    @State private var isMenuOpen: Bool = false

    var body: some View {
        ZStack {
            // 侧边菜单视图
            SideMenu()
                .frame(width: 250)
                // 当菜单关闭时，将菜单整体移出屏幕左侧
                .offset(x: isMenuOpen ? 0 : -250)
                .animation(.easeInOut(duration: 0.3), value: isMenuOpen)

            // 主内容视图
            MainView(isMenuOpen: $isMenuOpen)
                .cornerRadius(isMenuOpen ? 20 : 0)
                .offset(x: isMenuOpen ? 250 : 0)
                .scaleEffect(isMenuOpen ? 0.9 : 1)
                .animation(.easeInOut(duration: 0.3), value: isMenuOpen)
                // 当侧边菜单打开时，禁止主内容的交互
                .disabled(isMenuOpen)
        }
    }
}


#Preview {
    ContentView()
}
