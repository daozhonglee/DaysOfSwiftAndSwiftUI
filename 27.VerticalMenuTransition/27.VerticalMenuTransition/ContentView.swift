//
//  ContentView.swift
//  27.VerticalMenuTransition
//
//  Created by shanquan on 2025/2/19.
//

import SwiftUI

struct ContentView: View {
    // 控制菜单是否显示的状态变量
      @State private var showMenu = false

      var body: some View {
          ZStack {
              // 主背景
              Color(.systemBackground)
                  .ignoresSafeArea()

              // 主内容区域
              VStack {
                  Spacer()
                  Text("主内容区域")
                      .font(.largeTitle)
                      .padding()
                  Spacer()
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

              // 菜单视图：垂直排列的多个按钮
              if showMenu {
                  VStack(spacing: 20) {
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
                  // 菜单从底部滑入
                  .transition(.move(edge: .bottom))
                  .animation(.easeInOut, value: showMenu)
                  .padding(.horizontal, 30)
                  // 将菜单放在屏幕底部居中显示
                  .position(x: UIScreen.main.bounds.width / 2,
                            y: UIScreen.main.bounds.height - 200)
              }
          }
      }
}

#Preview {
    ContentView()
}
