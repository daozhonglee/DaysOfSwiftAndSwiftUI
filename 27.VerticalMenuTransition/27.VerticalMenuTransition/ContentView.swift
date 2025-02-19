//
//  ContentView.swift
//  27.VerticalMenuTransition
//
//  Created by shanquan on 2025/2/19.
//

import SwiftUI

/// 垂直菜单过渡动画演示视图
/// 本示例展示了如何使用SwiftUI实现一个带有过渡动画的垂直弹出菜单
/// 主要技术点包括：
/// - 使用@State管理菜单的显示状态
/// - ZStack实现视图层叠布局
/// - SwiftUI动画和过渡效果
/// - 条件渲染和视图定位
struct ContentView: View {
    /// 控制菜单显示状态的属性包装器
    /// 当值改变时，SwiftUI会自动重新渲染相关视图
    @State private var showMenu = false

      var body: some View {
          // 使用ZStack创建层叠布局，使菜单可以覆盖在主内容之上
          ZStack {
              // 设置系统背景色并忽略安全区域，确保背景色填充整个屏幕
              Color(.systemBackground)
                  .ignoresSafeArea()

              // 主内容区域：使用VStack垂直排列内容
              // 包含标题文本和控制菜单显示的按钮
              VStack {
                  Spacer()
                  Text("主内容区域")
                      .font(.largeTitle)
                      .padding()
                  Spacer()
                  // 控制菜单显示/隐藏的按钮
                  // 使用withAnimation添加平滑的过渡动画
                  Button(action: {
                      withAnimation(.easeInOut(duration: 0.5)) {
                          showMenu.toggle()
                      }
                  }) {
                      Text(showMenu ? "关闭菜单" : "打开菜单")
                          .font(.headline)
                          .padding()
                          .frame(maxWidth: .infinity)
                          .background(Color.blue)
                          .foregroundColor(.white)
                          .cornerRadius(8)
                  }
                  .padding(.horizontal, 30)
                  .padding(.bottom, 50)
              }

              // 条件渲染菜单视图
              // 当showMenu为true时显示菜单
              // 使用VStack垂直排列菜单按钮
              if showMenu {
                  VStack(spacing: 20) {
                      // 控制菜单显示/隐藏的按钮
                  // 使用withAnimation添加平滑的过渡动画
                  Button(action: {
                          // 菜单项 1 的动作
                          print("点击了菜单项 1")
                          withAnimation(.easeInOut(duration: 0.5)) {
                              showMenu = false
                          }
                      }) {
                          Text("菜单项 1")
                              .font(.headline)
                              .padding()
                              .frame(maxWidth: .infinity)
                              .background(Color.green.opacity(0.8))
                              .cornerRadius(8)
                      }
                      // 控制菜单显示/隐藏的按钮
                  // 使用withAnimation添加平滑的过渡动画
                  Button(action: {
                          // 菜单项 2 的动作
                          print("点击了菜单项 2")
                          withAnimation(.easeInOut(duration: 0.5)) {
                              showMenu = false
                          }
                      }) {
                          Text("菜单项 2")
                              .font(.headline)
                              .padding()
                              .frame(maxWidth: .infinity)
                              .background(Color.orange.opacity(0.8))
                              .cornerRadius(8)
                      }
                      // 控制菜单显示/隐藏的按钮
                  // 使用withAnimation添加平滑的过渡动画
                  Button(action: {
                          // 菜单项 3 的动作
                          print("点击了菜单项 3")
                          withAnimation(.easeInOut(duration: 0.5)) {
                              showMenu = false
                          }
                      }) {
                          Text("菜单项 3")
                              .font(.headline)
                              .padding()
                              .frame(maxWidth: .infinity)
                              .background(Color.purple.opacity(0.8))
                              .cornerRadius(8)
                      }
                  }
                  .padding()
                  .background(Color(UIColor.systemGray6))
                  .cornerRadius(20)
                  .shadow(radius: 10)
                  // 设置菜单的过渡动画效果
                  // .transition定义视图的出现和消失效果
                  // .move(edge: .bottom)指定从底部滑入/滑出
                  .transition(.move(edge: .bottom))
                  // 配置动画曲线为easeInOut，使动画更自然
                  // value参数指定触发动画的状态变量
                  .animation(.easeInOut, value: showMenu)
                  .padding(.horizontal, 30)
                  // 使用position明确指定菜单在屏幕上的位置
                  // x坐标设置为屏幕宽度的一半，实现水平居中
                  // y坐标设置为屏幕高度减去200点，确保在底部显示
                  .position(x: UIScreen.main.bounds.width / 2,
                            y: UIScreen.main.bounds.height - 200)
              }
          }
      }
}

#Preview {
    ContentView()
}
