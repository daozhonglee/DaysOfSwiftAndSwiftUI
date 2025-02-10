import SwiftUI
import AVKit
import Vision

/// 视频播放器视图组件
/// 提供视频播放和对象检测结果的可视化显示
struct VideoPlayerView: View {
    /// AVPlayer 实例，用于控制视频播放
    let player: AVPlayer
    /// 是否显示全屏模式的绑定
    @Binding var isFullScreenPresented: Bool
    
    var body: some View {
        GeometryReader { geometry in
            // 使用 ZStack 叠加视频播放器和检测结果显示
            ZStack {
                // 视频播放器组件，设置 16:9 的宽高比
                VideoPlayer(player: player)
                    .frame(width: geometry.size.width, height: geometry.size.width * 9/16)
                    // 添加检测结果的可视化覆盖层
                    // 全屏模式切换
                    .fullScreenCover(isPresented: $isFullScreenPresented) {
                        // 显示全屏播放器组件
                        FullScreenVideoPlayer(player: player, isPresented: $isFullScreenPresented)
                    }
            }
        }
        .frame(height: UIScreen.main.bounds.width * 9/16)
    }
}

/// 关闭按钮视图组件
/// 提供一个标准的关闭按钮，通常用于模态视图或全屏视图的顶部
struct CloseButtonView: View {
    let action: () -> Void

    var body: some View {
        HStack {
            Button(action: action) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            .padding()
            Spacer()
        }
    }
}
