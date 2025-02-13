//
//  ContentView.swift
//  16.TumblrMenu
//
//  Created by shanquan on 2025/2/14.
//

import SwiftUI

// ContentView是主视图结构体，遵循View协议
// 实现了一个类似Tumblr风格的弹出菜单界面
struct ContentView: View {
    // @State是SwiftUI的属性包装器，用于在视图中创建可变状态
    // 当这些状态值改变时，SwiftUI会自动重新渲染相关视图
    @State private var isMenuOpen = false  // 控制菜单是否打开
    @State private var selectedItem: String? = nil  // 记录选中的菜单项，可选类型

    // 菜单项数据，使用元组数组存储
    // 每个元组包含两个元素：显示文本和对应的SF Symbols图标名称
    let menuItems = [
        ("文字", "textformat"),
        ("照片", "photo"),
        ("引用", "quote.bubble"),
        ("链接", "link"),
        ("聊天", "bubble.left.and.bubble.right"),
        ("视频", "video")
    ]

    // body是View协议要求实现的计算属性
    // 定义视图的内容和布局结构
    var body: some View {
        // ZStack创建层叠布局，后面的视图叠加在前面的视图上
        ZStack {
            // 主界面内容
            // NavigationView提供导航栏和导航功能
            NavigationView {
                // VStack创建垂直方向的视图堆栈
                VStack {
                    // 条件渲染：根据是否有选中项显示不同内容
                    if let selectedItem = selectedItem {
                        Text("您选择了：\(selectedItem)")
                            .font(.title)
                            .padding()
                    } else {
                        Text("请选择一个菜单项")
                            .font(.title)
                            .padding()
                    }
                    Spacer()  // 弹性空间，将内容推到顶部
                }
                .navigationTitle("Tumblr Menu")  // 设置导航栏标题
                .toolbar {
                    // 在导航栏右侧添加菜单按钮
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            // 使用spring动画切换菜单状态
                            withAnimation(.spring()) {
                                isMenuOpen.toggle()
                            }
                        }) {
                            // 使用SF Symbols系统图标
                            Image(systemName: "plus.circle.fill")
                                .font(.largeTitle)
                        }
                    }
                }
            }
            // 当菜单打开时添加模糊效果
            .blur(radius: isMenuOpen ? 5 : 0)

            // 条件渲染：菜单打开时显示半透明背景和菜单项
            if isMenuOpen {
                // 半透明黑色背景，点击时关闭菜单
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            isMenuOpen = false
                        }
                    }

                // 菜单项列表
                VStack(spacing: 20) {
                    // 使用ForEach遍历菜单项数组
                    // id: \.0表示使用元组的第一个元素（文本）作为标识符
                    ForEach(menuItems, id: \.0) { item in
                        Button(action: {
                            // 点击菜单项时，更新选中项并关闭菜单
                            withAnimation(.spring()) {
                                selectedItem = item.0
                                isMenuOpen = false
                            }
                        }) {
                            // 菜单项的视觉样式
                            HStack {
                                Image(systemName: item.1)
                                    .font(.title)
                                Text(item.0)
                                    .font(.title2)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        }
                        // 添加从底部滑入的转场动画
                        .transition(.move(edge: .bottom))
                    }
                }
                .padding(.bottom, 50)
            }
        }
    }
}

// 预览提供器，用于在Xcode中实时预览UI效果
#Preview {
    ContentView()
}
