//
//  ContentView.swift
//  14.AnimationInTableViewCell
//
//  Created by shanquan on 2025/2/14.
//

import SwiftUI

// ContentView是主视图结构体，遵循View协议
// 实现了一个带有动画效果的列表视图
struct ContentView: View {
    // 示例数据：使用Array和map创建20个列表项
    // map函数将每个数字转换为"Item X"格式的字符串
    let items = Array(1...20).map { "Item \($0)" }

    var body: some View {
        // NavigationView是SwiftUI提供的导航容器
        // 用于实现具有导航栏的页面层次结构
        NavigationView {
            // ScrollView创建可滚动的容器视图
            ScrollView {
                // LazyVStack创建垂直方向的视图堆栈，懒加载方式
                // 只有当视图出现在屏幕上时才会被创建，提高性能
                LazyVStack(spacing: 10) {
                    // ForEach用于遍历数组创建动态列表项
                    // id: \.self表示使用数组元素本身作为唯一标识符
                    ForEach(items, id: \.self) { item in
                        AnimatedCell(item: item)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            // 设置背景色为系统分组背景色
            .background(Color(UIColor.systemGroupedBackground))
            // 设置导航栏标题
            .navigationTitle("Animated Cells")
        }
    }
}

/// 单个动画cell视图
/// 实现了淡入和位移的组合动画效果
struct AnimatedCell: View {
    // 存储cell的文本内容
    let item: String
    // @State属性包装器用于管理视图的动画状态
    // 当animate值改变时，相关的动画修饰符会自动触发动画
    @State private var animate: Bool = false

    var body: some View {
        Text(item)
            // 添加内边距
            .padding()
            // 设置最大宽度为无限，左对齐
            .frame(maxWidth: .infinity, alignment: .leading)
            // 设置背景色为白色
            .background(Color.white)
            // 添加圆角效果
            .cornerRadius(8)
            // 添加阴影效果
            .shadow(radius: 2)
            // 设置透明度动画：从完全透明(0)到不透明(1)
            .opacity(animate ? 1 : 0)
            // 设置垂直位移动画：从下方20点移动到原位
            .offset(y: animate ? 0 : 20)
            // 当视图出现时触发动画
            .onAppear {
                // 使用spring弹簧动画
                // response: 响应时间，值越大动画越慢
                // dampingFraction: 阻尼系数，控制弹簧效果，值越小弹性越大
                // blendDuration: 混合持续时间，用于多个动画之间的过渡
                withAnimation(.spring(response: 0.8, dampingFraction: 6.8, blendDuration: 0)) {
                    animate = true
                }
            }
    }
}

#Preview {
    ContentView()
}
