//
//  ContentView.swift
//  10.SwipeableCell
//
//  Created by shanquan on 2025/2/14.
//

// 导入SwiftUI框架，提供了用于构建用户界面的声明式API
import SwiftUI

// ContentView是主视图结构体，遵循View协议
// 实现了一个支持侧滑操作的列表视图
struct ContentView: View {
    // @State是SwiftUI的属性包装器，用于在视图中创建可变状态
    // 当items数组发生变化时，SwiftUI会自动重新渲染相关视图
    @State private var items = ["Item A", "Item B", "Item C", "Item D"]

    // body是View协议要求实现的计算属性
    // 定义视图的内容和布局结构
    var body: some View {
        // NavigationView是SwiftUI提供的导航容器
        // 用于实现具有导航栏的页面层次结构
        NavigationView {
            // List是SwiftUI的列表容器，用于显示可滚动的数据列表
            List {
                // ForEach用于遍历数组创建动态列表项
                // id: \.self表示使用数组元素本身作为唯一标识符
                ForEach(items, id: \.self) { item in
                    // 创建文本视图显示列表项内容
                    Text(item)
                        // 添加侧滑操作功能
                        // edge: .trailing表示从右侧滑动
                        // allowsFullSwipe: true允许完整滑动触发操作
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            // 删除按钮，使用destructive角色表示删除操作
                            Button(role: .destructive) {
                                // 查找并删除对应的数组元素
                                if let index = items.firstIndex(of: item) {
                                    items.remove(at: index)
                                }
                            } label: {
                                // 使用系统提供的trash图标
                                Label("删除", systemImage: "trash")
                            }

                            // 编辑按钮
                            Button {
                                // 这里可添加编辑逻辑
                                print("编辑 \(item)")
                            } label: {
                                // 使用系统提供的pencil图标
                                Label("编辑", systemImage: "pencil")
                            }
                            // 设置按钮的颜色为蓝色
                            .tint(.blue)
                        }
                }
            }
            // 设置导航栏标题
            .navigationTitle("Swipeable Cells")
        }
    }
}

// 预览提供器，用于在Xcode中实时预览UI效果
#Preview {
    ContentView()
}
