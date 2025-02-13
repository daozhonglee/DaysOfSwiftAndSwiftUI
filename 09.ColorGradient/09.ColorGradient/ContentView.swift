//
//  ContentView.swift
//  09.ColorGradient
//
//  Created by shanquan on 2025/2/14.
//

import SwiftUI

struct ContentView: View {
    // 用于记录拖动偏移
    @State private var dragOffset: CGSize = .zero

    // 根据拖动偏移计算第一个颜色（基于拖动水平位移）
    var dynamicColor1: Color {
        // 假设屏幕宽度为 375，映射偏移至 [0,1] 的 hue 值
        let normalized = abs(dragOffset.width) / 375
        return Color(hue: normalized.truncatingRemainder(dividingBy: 1),
                     saturation: 0.8,
                     brightness: 0.9)
    }

    // 根据拖动偏移计算第二个颜色（基于拖动垂直位移）
    var dynamicColor2: Color {
        // 假设屏幕高度为 667，映射偏移至 [0,1] 的 hue 值
        let normalized = abs(dragOffset.height) / 667
        return Color(hue: normalized.truncatingRemainder(dividingBy: 1),
                     saturation: 0.8,
                     brightness: 0.9)
    }

    // 固定渐变方向
    let startPoint: UnitPoint = .topLeading
    let endPoint: UnitPoint = .bottomTrailing

    var body: some View {
        ZStack {
            // 使用动态颜色创建线性渐变背景
            LinearGradient(gradient: Gradient(colors: [dynamicColor1, dynamicColor2]),
                           startPoint: startPoint,
                           endPoint: endPoint)
            .edgesIgnoringSafeArea(.all)
            // 拖动手势更新 dragOffset
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation
                    }
                    .onEnded { _ in
                        // 可根据需求选择保留拖动结果或恢复初始状态
                        // 这里保留最终状态，您也可以加上动画效果恢复到 .zero
                    }
            )

            // 提示文本
            Text("拖动屏幕改变渐变色")
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(8)
        }
    }
}

#Preview {
    ContentView()
}
