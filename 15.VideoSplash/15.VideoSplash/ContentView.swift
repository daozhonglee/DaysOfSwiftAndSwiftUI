//
//  ContentView.swift
//  15.VideoSplash
//
//  Created by shanquan on 2025/2/14.
//

// 导入所需的框架
import SwiftUI    // 用于构建用户界面
import AVKit      // 用于视频播放功能

/// 主视图结构体
/// 实现一个带有视频背景的启动页面，包含欢迎文本和开始按钮
struct ContentView: View {

    // MARK: - 属性
    /// 视频URL
    /// 这里使用一个在线视频作为示例
    /// 在实际应用中，建议将视频文件添加到项目资源中以提高加载速度和可靠性
    private var videoURL: URL? = URL("https://vjs.zencdn.net/v/oceans.mp4")

    // MARK: - 视图主体
    var body: some View {
        // 使用ZStack创建层叠布局，将视频播放器作为背景，UI元素叠加在上面
        ZStack {
            // 条件渲染：如果视频URL有效则显示视频，否则显示黑色背景
            if let url = videoURL {
                // 使用SwiftUI的VideoPlayer组件播放视频
                VideoPlayer(player: AVPlayer(url: url))
                    // 设置视频填充模式为填充以覆盖整个屏幕
                    .aspectRatio(contentMode: .fill)
                    // 忽略安全区域，使视频真正全屏显示
                    .edgesIgnoringSafeArea(.all)
                    // 视图出现时配置视频循环播放
                    .onAppear {
                        // 监听视频播放完成事件
                        // 使用NotificationCenter观察视频播放结束的通知
                        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: .main) { _ in
                            // 创建新的播放器实例
                            let player = AVPlayer(url: url)
                            // 将播放位置重置到开始
                            player.seek(to: .zero)
                            // 开始播放
                            player.play()
                        }
                    }
            } else {
                // 视频URL无效时显示的占位符
                Color.black
            }

            // MARK: - UI元素
            // 使用VStack垂直排列欢迎文本和按钮
            VStack {
                // 欢迎文本
                Text("Welcome to My App")
                    .font(.largeTitle)         // 使用大标题字体
                    .foregroundColor(.white)   // 设置文本颜色为白色
                    .padding()                 // 添加内边距

                // 开始按钮
                Button(action: {
                    // 这里可以添加按钮点击事件的处理逻辑
                    // 例如：导航到主页面或显示登录界面
                }) {
                    // 按钮的视觉样式
                    Text("Get Started")
                        .font(.headline)        // 使用标题字体
                        .foregroundColor(.white) // 文本颜色为白色
                        .padding()              // 添加内边距
                        .background(Color.blue) // 蓝色背景
                        .cornerRadius(10)       // 圆角效果
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
