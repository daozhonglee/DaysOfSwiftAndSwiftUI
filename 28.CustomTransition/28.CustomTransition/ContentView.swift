//
//  ContentView.swift
//  28.CustomTransition
//
//  Created by shanquan on 2025/2/19.
//

import SwiftUI

/// 自定义转场动画演示视图
/// 本示例展示了如何在SwiftUI中实现自定义视图转场动画
/// 主要技术点包括：
/// - 使用@State管理视图状态
/// - ZStack实现视图层叠
/// - 自定义转场动画
/// - 视图绑定数据传递
struct ContentView: View {
    /// 控制详情视图显示状态的状态变量
    /// 当值改变时，SwiftUI会自动重新渲染相关视图并触发转场动画
    @State private var showDetail = false

    var body: some View {
        // 使用ZStack创建层叠布局，使详情视图可以覆盖在主视图之上
        ZStack {
            // 主视图：使用VStack垂直排列内容
            // 包含标题文本和触发详情视图显示的按钮
            VStack(spacing: 20) {
                Text("Main View")
                    .font(.largeTitle)
                Button("Show Detail") {
                    // 使用withAnimation添加平滑的过渡动画
                    // easeInOut提供渐入渐出效果，duration指定动画持续时间
                    withAnimation(.easeInOut(duration: 0.6)) {
                        showDetail = true
                    }
                }
            }

            // 条件渲染详情视图
            // 当showDetail为true时，使用自定义转场动画显示详情视图
            if showDetail {
                DetailView(showDetail: $showDetail)
                    .transition(.customTransition) // 应用自定义转场效果
            }
        }
        .edgesIgnoringSafeArea(.all) // 忽略安全区域，实现全屏效果
    }
}

/// 详情视图
/// 使用绑定属性实现与父视图的数据同步
struct DetailView: View {
    /// 通过绑定与父视图共享状态
    /// 使用@Binding确保状态变更能同步回父视图
    @Binding var showDetail: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Detail View")
                .font(.title)
                .padding()
            Button("Dismiss") {
                // 使用相同的动画配置确保一致的视觉效果
                withAnimation(.easeInOut(duration: 0.6)) {
                    showDetail = false
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // 扩展至全屏
        .background(Color.blue) // 设置背景色
        .foregroundColor(.white) // 设置前景色
        .edgesIgnoringSafeArea(.all) // 忽略安全区域
    }
}

/// 自定义转场效果扩展
/// 通过扩展AnyTransition实现自定义转场动画
extension AnyTransition {
    /// 自定义非对称转场效果
    /// - 插入时：从右侧滑入并淡入
    /// - 移除时：向左滑出并缩小
    static var customTransition: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing) // 从右侧滑入
                        .combined(with: .opacity), // 结合淡入效果
            removal: .move(edge: .leading) // 向左滑出
                        .combined(with: .scale) // 结合缩放效果
        )
    }
}

#Preview {
    ContentView()
}
