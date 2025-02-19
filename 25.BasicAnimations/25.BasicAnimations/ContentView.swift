import SwiftUI

struct BasicAnimationsView: View {
    // 用于“位置动画”的状态：水平偏移量
    @State private var offset: CGFloat = 0
    // 用于“透明度动画”的状态：是否淡出
    @State private var fadeOut = false
    // 用于“缩放动画”的状态：缩放比例
    @State private var scale: CGFloat = 1.0
    // 用于“旋转动画”的状态：旋转角度（单位：度）
    @State private var rotation: Double = 0
    // 用于“背景颜色动画”的状态：是否切换颜色
    @State private var changeColor = false

    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                // 位置动画示例
                VStack(spacing: 10) {
                    Text("位置动画")
                        .font(.headline)
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 100, height: 100)
                        .offset(x: offset)
                        .animation(.easeInOut(duration: 1), value: offset)
                    Button("移动") {
                        offset = offset == 0 ? 100 : 0
                    }
                }

                // 透明度动画示例
                VStack(spacing: 10) {
                    Text("透明度动画")
                        .font(.headline)
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: 100, height: 100)
                        .opacity(fadeOut ? 0.2 : 1.0)
                        .animation(.easeInOut(duration: 1), value: fadeOut)
                    Button("切换透明度") {
                        fadeOut.toggle()
                    }
                }

                // 缩放动画示例
                VStack(spacing: 10) {
                    Text("缩放动画")
                        .font(.headline)
                    Circle()
                        .fill(Color.red)
                        .frame(width: 100, height: 100)
                        .scaleEffect(scale)
                        .animation(.spring(response: 0.5, dampingFraction: 0.6), value: scale)
                    Button("切换缩放") {
                        scale = scale == 1.0 ? 1.5 : 1.0
                    }
                }

                // 旋转动画示例
                VStack(spacing: 10) {
                    Text("旋转动画")
                        .font(.headline)
                    Rectangle()
                        .fill(Color.orange)
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(rotation))
                        .animation(.linear(duration: 1), value: rotation)
                    Button("旋转 45°") {
                        rotation += 45
                    }
                }

                // 背景颜色动画示例
                VStack(spacing: 10) {
                    Text("背景颜色动画")
                        .font(.headline)
                    Rectangle()
                        .fill(changeColor ? Color.purple : Color.yellow)
                        .frame(width: 100, height: 100)
                        .animation(.easeInOut(duration: 1), value: changeColor)
                    Button("切换颜色") {
                        changeColor.toggle()
                    }
                }
            }
            .padding()
        }
    }
}

struct BasicAnimationsView_Previews: PreviewProvider {
    static var previews: some View {
        BasicAnimationsView()
    }
}
