//
//  ContentView.swift
//  13.EmojiSlotMachine
//
//  Created by shanquan on 2025/2/14.
//

import SwiftUI

/// ContentView 是应用的主视图结构体
/// 实现了一个简单的老虎机游戏界面
/// 包含三个可旋转的表情符号轮盘和一个开始按钮
struct ContentView: View {
    // 可选的 emoji 数组，作为轮盘显示的内容来源
    // 使用水果表情让游戏更有趣味性
    let emojis = ["🍒", "🍋", "🍊", "🍉", "🍇", "🍓", "🍎"]

    // @State 属性包装器用于创建视图的状态变量
    // 当这些状态值改变时，SwiftUI 会自动重新渲染相关视图
    
    // 三个轮盘当前显示的 emoji，初始值都设为樱桃
    @State private var reel1: String = "🍒"
    @State private var reel2: String = "🍒"
    @State private var reel3: String = "🍒"

    // Timer 可选类型，用于控制轮盘的旋转动画
    // 每个轮盘都需要独立的定时器以实现不同的停止时间
    @State private var timer1: Timer?
    @State private var timer2: Timer?
    @State private var timer3: Timer?

    // 标记当前是否正在旋转中
    // 用于控制按钮的禁用状态和外观
    @State private var isSpinning = false
    
    // 游戏结果提示信息
    // 用于显示是否中奖
    @State private var resultMessage = ""

    // body 是 View 协议要求实现的计算属性
    // 定义整个视图的内容和布局
    var body: some View {
        // VStack 创建垂直方向的视图堆栈
        // spacing: 40 设置子视图之间的间距为 40 点
        VStack(spacing: 40) {
            // HStack 创建水平方向的视图堆栈
            // 用于并排显示三个轮盘
            HStack(spacing: 20) {
                // 使用 Text 视图显示 emoji
                // 设置较大字号使轮盘更醒目
                Text(reel1)
                    .font(.system(size: 80))
                Text(reel2)
                    .font(.system(size: 80))
                Text(reel3)
                    .font(.system(size: 80))
            }

            // 条件渲染结果提示
            // 仅当有结果信息时才显示
            if !resultMessage.isEmpty {
                Text(resultMessage)
                    .font(.title)
                    // 根据结果设置不同的文字颜色
                    .foregroundColor(resultMessage.contains("Bingo") ? .green : .red)
            }

            // Spin 按钮
            // 点击时触发 spin() 函数开始游戏
            Button(action: {
                spin()
            }) {
                Text("Spin")
                    .font(.title2)
                    .padding()
                    .frame(width: 200)
                    // 旋转时显示灰色，表示禁用状态
                    .background(isSpinning ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            // 旋转过程中禁用按钮，防止重复触发
            .disabled(isSpinning)
        }
        .padding()
        // 添加双击手势
        // 双击屏幕可以检查当前是否中奖
        .onTapGesture(count: 2) {
            checkBingo()
        }
    }

    /// 开始游戏的核心函数
    /// 控制三个轮盘的旋转和停止
    /// 实现渐进式停止效果，增强游戏体验
    func spin() {
        // 清空上一次的结果信息
        resultMessage = ""
        // 设置正在旋转状态
        isSpinning = true

        // 创建三个定时器，分别控制三个轮盘
        // 每 0.1 秒随机更新一次显示的表情
        timer1 = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            reel1 = emojis.randomElement()!
        }
        timer2 = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            reel2 = emojis.randomElement()!
        }
        timer3 = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            reel3 = emojis.randomElement()!
        }

        // 使用 GCD 延时函数实现轮盘的渐进式停止
        // 三个轮盘分别在 1.0、1.5、2.0 秒后停止
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            timer1?.invalidate()
            timer1 = nil
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            timer2?.invalidate()
            timer2 = nil
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            timer3?.invalidate()
            timer3 = nil
            // 所有轮盘停止后，重置旋转状态
            isSpinning = false
            // 检查是否中奖
            checkBingo()
        }
    }

    /// 检查是否中奖
    /// 当三个轮盘显示相同表情时即为中奖
    func checkBingo() {
        if reel1 == reel2 && reel2 == reel3 {
            resultMessage = "Bingo! 🎉"
        } else {
            resultMessage = "Try Again"
        }
    }
}

#Preview {
    ContentView()
}
