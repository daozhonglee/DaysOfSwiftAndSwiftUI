//
//  ContentView.swift
//  02.StopWatch
//
//  Created by shanquan on 2025/2/9.
//

import SwiftUI

// 定义主视图结构体，遵循View协议
// View协议是SwiftUI中最基本的协议，要求实现body计算属性
struct ContentView: View {

    // @State是SwiftUI的属性包装器，用于创建可变状态
    // 当这些状态值改变时，SwiftUI会自动重新渲染相关视图
    @State private var isRuning: Bool = false  // 控制计时器运行状态
    @State private var elapsedTime: TimeInterval = 0  // 记录经过的时间，使用TimeInterval类型（实际是Double）
    @State private var timer: Timer?  // 可选类型Timer，用于控制计时器

    // body是View协议要求的计算属性，定义视图的内容和布局
    var body: some View {

        // VStack创建垂直方向的视图堆栈
        // alignment参数控制子视图的水平对齐方式
        // spacing参数控制子视图之间的间距
        VStack(alignment: .leading ,spacing: 0 ) {
            // 嵌套的VStack，用于显示计时器数值
            VStack(spacing: 0){
                // Text视图显示格式化后的时间
                // String(format:)用于格式化浮点数，保留一位小数
                Text(String(format: "%.1f", elapsedTime))
                    // 使用系统字体，设置大小、粗细和等宽字体设计
                    .font(.system(size: 100, weight: .bold, design: .monospaced))
                    // 设置文本颜色为白色
                    .foregroundColor(.white)
                    // frame修饰符设置视图框架，maxWidth和maxHeight设为.infinity表示填充可用空间
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    // 设置背景色为黑色
                    .background(Color.black)
                // Divider是一个系统提供的分隔线视图
                Divider()
            }

            // HStack创建水平方向的视图堆栈
            HStack(spacing: 0){
                // 创建暂停/继续按钮
                Button(action: {
                    // 点击时调用pauseResume函数
                    pauseResume()
                }){
                    // SF Symbols系统图标，根据isRuning状态显示不同图标
                    Image(systemName: isRuning ? "pause.fill" : "play.fill")
                        // 允许图片缩放
                        .resizable()
                        // 设置图片大小
                        .frame(width: 80, height: 80)
                        // 设置图片颜色
                        .foregroundColor(.white)
                }
                // 设置按钮框架填充可用空间
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // 添加垂直分隔线
                Divider()
                    .frame(height: .infinity)
                    .background(.white)

                // 创建重置按钮
                Button(action: {
                    // 点击时调用resetTimer函数
                    resetTimer()
                }){
                    // 使用系统提供的重置图标
                    Image(systemName:  "arrow.trianglehead.counterclockwise")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            // 设置HStack的背景色
            .background(Color.black)
        }
        // padding是视图修饰符，用于添加内边距
        .padding(0)
    }

    // 重置计时器的私有方法
    private func resetTimer(){
        timer?.invalidate()  // 停止并释放计时器
        timer = nil  // 清空计时器引用
        elapsedTime = 0  // 重置计时时间
    }

    // 处理暂停/继续功能的私有方法
    private func pauseResume(){
        if isRuning {
            timer?.invalidate()  // 如果正在运行，停止计时器
            timer = nil
        } else {
            // 如果已暂停，创建新的计时器
            // withTimeInterval: 0.01表示每0.01秒触发一次
            // repeats: true表示重复执行
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                // 闭包中更新经过的时间
                elapsedTime += 0.01
            }
        }
        // toggle()方法切换布尔值
        isRuning.toggle()
    }

}

#Preview {
    ContentView()
}
