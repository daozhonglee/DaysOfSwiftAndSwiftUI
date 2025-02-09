//
//  ContentView.swift
//  02.StopWatch
//
//  Created by shanquan on 2025/2/9.
//

import SwiftUI

struct ContentView: View {

    @State private var isRuning: Bool = false
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?

    var body: some View {

        //VStack 本身也是一个像 View 一样的结构体。我们可以为 VStack 提供参数
        //VStack 也被称为 @ViewBuilder。@ViewBuilder 可以将视图列表（Image、Text）转换为 TupleView。
        //VStack 是一个 返回 content 参数列表中视图组的函数
        VStack(alignment: .leading ,spacing: 0 ) {
            VStack(spacing: 0){
                Text(String(format: "%.1f", elapsedTime))
                    .font(.system(size: 100, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black)
                Divider()
            }

            HStack(spacing: 0){
                Button(action: {
                    pauseResume()
                }){
                    Image(systemName: isRuning ? "pause.fill" : "play.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                Divider()
                    .frame(height: .infinity)
                    .background(.white)

                Button(action: {
                    resetTimer()
                }){
                    Image(systemName:  "arrow.trianglehead.counterclockwise")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color.black)
        }
        //padding 叫 View modifier 视图修饰符，可以改变视图
        .padding(0)
    }

    //invalidate() 的作用是：
    //    - 停止计时器的运行
    //    - 从运行循环中移除计时器
    //    - 释放计时器占用的系统资源
    private func resetTimer(){
        timer?.invalidate()
        timer = nil
        elapsedTime = 0
    }

    private func pauseResume(){
        if isRuning {
            timer?.invalidate()
            timer = nil
        } else {
            // 开始计时器
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                // 更新 @State变量后，SwiftUI 会自动重新渲染视图
                elapsedTime += 0.01
            }
        }
        isRuning.toggle()
    }

}

#Preview {
    ContentView()
}
