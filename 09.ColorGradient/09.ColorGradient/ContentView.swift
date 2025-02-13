//
//  ContentView.swift
//  09.ColorGradient
//
//  Created by shanquan on 2025/2/14.
//

// 导入SwiftUI框架，这是Apple提供的用于构建声明式用户界面的现代框架
import SwiftUI

// ContentView是主视图结构体，遵循View协议
// View协议是SwiftUI中最基本的协议，要求实现body计算属性来描述视图的内容和布局
struct ContentView: View {
    // @State是SwiftUI的属性包装器，用于创建视图的内部状态
    // 当状态值改变时，SwiftUI会自动重新渲染依赖于该状态的视图部分
    // dragOffset用于记录用户拖动的位移，类型为CGSize，初始值为零点
    @State private var dragOffset: CGSize = .zero

    // dynamicColor1是一个计算属性，根据水平拖动距离动态生成颜色
    // 使用计算属性可以实现数据的实时转换，每次访问都会重新计算
    var dynamicColor1: Color {
        // 将水平位移标准化到[0,1]范围，用于HSB颜色空间的色相值
        // abs函数确保负向拖动也能产生有效值
        let normalized = abs(dragOffset.width) / 375  // 375是参考屏幕宽度
        // 使用HSB(色相、饱和度、亮度)颜色空间创建颜色
        // truncatingRemainder确保色相值始终在[0,1]范围内循环
        return Color(hue: normalized.truncatingRemainder(dividingBy: 1),
                     saturation: 0.8,  // 固定的饱和度
                     brightness: 0.9)   // 固定的亮度
    }

    // dynamicColor2是另一个计算属性，根据垂直拖动距离动态生成颜色
    // 实现原理与dynamicColor1相同，但使用垂直位移作为输入
    var dynamicColor2: Color {
        // 使用屏幕高度667作为参考值进行标准化
        let normalized = abs(dragOffset.height) / 667
        return Color(hue: normalized.truncatingRemainder(dividingBy: 1),
                     saturation: 0.8,
                     brightness: 0.9)
    }

    // 定义渐变的起点和终点
    // UnitPoint是一个表示单位坐标系中点的类型，用于指定渐变的方向
    let startPoint: UnitPoint = .topLeading     // 左上角
    let endPoint: UnitPoint = .bottomTrailing   // 右下角

    // body是View协议要求实现的计算属性
    // 它定义了视图的内容和布局结构
    var body: some View {
        // ZStack是一个容器视图，将子视图按照添加顺序叠加显示
        // 后添加的视图会显示在先添加的视图上面
        ZStack {
            // LinearGradient创建一个线性渐变背景
            // 使用动态计算的颜色作为渐变的起始和结束颜色
            LinearGradient(gradient: Gradient(colors: [dynamicColor1, dynamicColor2]),
                           startPoint: startPoint,
                           endPoint: endPoint)
            // 忽略安全区域，使渐变背景填充整个屏幕
            .edgesIgnoringSafeArea(.all)
            // 添加拖动手势
            .gesture(
                // DragGesture用于处理拖动操作
                DragGesture()
                    // onChanged在拖动过程中持续调用
                    // value参数包含了拖动的相关信息，如位移等
                    .onChanged { value in
                        // 更新dragOffset状态，触发视图更新
                        dragOffset = value.translation
                    }
                    // onEnded在拖动结束时调用
                    .onEnded { _ in
                        // 这里选择保留最终的拖动状态
                        // 也可以添加动画效果使其恢复到初始状态
                    }
            )

            // 在渐变背景上添加提示文本
            Text("拖动屏幕改变渐变色")
                .font(.title)                        // 使用标题字体
                .foregroundColor(.white)             // 文字颜色为白色
                .padding()                           // 添加内边距
                .background(Color.black.opacity(0.3)) // 半透明黑色背景
                .cornerRadius(8)                     // 圆角效果
        }
    }

}

#Preview {
    ContentView()
}
