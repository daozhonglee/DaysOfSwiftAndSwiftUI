//
//  ContentView.swift
//  17.LoginAnimation
//
//  Created by shanquan on 2025/2/14.
//

import SwiftUI

/// ContentView 是应用的主视图结构体
/// 实现了一个带有动画效果的登录界面
/// 包含用户名和密码输入框、加载动画、以及登录成功后的欢迎界面
struct ContentView: View {
    // @State属性包装器用于创建视图的状态变量
    // 当这些状态值改变时，SwiftUI会自动重新渲染相关视图
    @State private var username: String = ""     // 用户名输入
    @State private var password: String = ""     // 密码输入
    @State private var isLoading: Bool = false   // 加载状态
    @State private var loginSuccess: Bool = false // 登录成功状态

    // body是View协议要求的计算属性
    // 定义整个视图的内容和布局
    var body: some View {
        // VStack创建垂直方向的视图堆栈
        VStack {
            // 使用条件渲染显示不同的界面状态
            if loginSuccess {
                // 登录成功后的欢迎界面
                Text("Welcome, \(username)!")
                    .font(.largeTitle)  // 使用大标题字体
                    // 添加从右侧滑入的转场动画
                    .transition(.move(edge: .trailing))
            } else {
                // 登录表单界面
                // 用户名输入框
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .disabled(isLoading)  // 加载时禁用输入

                // 密码输入框
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .disabled(isLoading)  // 加载时禁用输入

                // 根据加载状态显示不同的内容
                if isLoading {
                    // 加载动画指示器
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    // 登录按钮
                    Button(action: {
                        // 点击时触发登录动画
                        withAnimation {
                            isLoading = true
                        }
                        // 模拟网络请求延迟
                        // 使用GCD在主线程延迟执行
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isLoading = false
                                loginSuccess = true
                            }
                        }
                    }) {
                        // 按钮的外观定义
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)  // 按钮宽度填充父视图
                            .background(Color.blue)      // 蓝色背景
                            .cornerRadius(10)           // 圆角效果
                            .padding(.horizontal)
                    }
                    // 当用户名或密码为空时禁用按钮
                    .disabled(username.isEmpty || password.isEmpty)
                }
            }
        }
        .padding()
        // 为整个视图添加过渡动画
        // 当loginSuccess状态改变时使用缓入缓出动画
        .animation(.easeInOut, value: loginSuccess)
    }
}

// 预览提供器
#Preview {
    ContentView()
}
