//
//  ContentView.swift
//  12.GradientInTableView
//
//  Created by shanquan on 2025/2/14.
//

// 导入SwiftUI框架，这是Apple提供的用于构建声明式用户界面的现代框架
import SwiftUI

// ContentView是主视图结构体，遵循View协议
// View协议是SwiftUI中最基本的协议，要求实现body计算属性来描述视图的内容和布局
struct ContentView: View {
    // 示例数据数组，用于在列表中显示
    // 在实际应用中，这可能来自网络请求、数据库或其他数据源
    let items = ["Row 1", "Row 2", "Row 3", "Row 4", "Row 5"]

    // body是View协议要求实现的计算属性
    // 它定义了视图的内容和布局结构
    var body: some View {
        // NavigationView是SwiftUI提供的导航容器
        // 用于实现具有导航栏的页面层次结构
        NavigationView {
            // List是SwiftUI的列表容器，用于显示可滚动的数据列表
            List {
                // ForEach用于遍历数组创建动态列表项
                // id: \.self表示使用数组元素本身作为唯一标识符
                ForEach(items, id: \.self) { item in
                    // 使用自定义的GradientRow视图作为列表项
                    GradientRow(text: item)
                        // 设置列表行的内边距，使用EdgeInsets定义四个方向的间距
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        // 隐藏列表行之间的默认分割线，使设计更清爽
                        .listRowSeparator(.hidden)
                }
            }
            // 使用PlainListStyle()移除列表的默认样式，使其更简洁
            .listStyle(PlainListStyle())
            // 设置导航栏标题
            .navigationTitle("Gradient in List")
        }
    }
}


/// 自定义的渐变背景列表行视图
/// 使用SwiftUI的视图构建器创建具有渐变背景的单个列表项
struct GradientRow: View {
    // 显示的文本内容
    var text: String
    // 定义渐变背景的颜色数组
    // 默认使用从蓝色到紫色的渐变
    // 可以在创建GradientRow实例时自定义这些颜色
    var gradientColors: [Color] = [Color.blue, Color.purple]

    // 定义视图的布局和外观
    var body: some View {
        Text(text)
            // 添加内边距，使文本不会贴近边缘
            .padding()
            // 设置框架宽度填充父视图，并左对齐文本
            .frame(maxWidth: .infinity, alignment: .leading)
            // 使用LinearGradient作为背景
            // 创建从左到右的渐变效果
            .background(
                LinearGradient(gradient: Gradient(colors: gradientColors),
                               startPoint: .leading,
                               endPoint: .trailing)
            )
            // 添加圆角效果
            .cornerRadius(8)
            // 设置文本颜色为白色，确保在渐变背景上清晰可见
            .foregroundColor(.white)
    }
}

// 预览提供器
// 用于在Xcode中实时预览UI效果
#Preview {
    ContentView()
}
