import SwiftUI
import AVKit

/// 播放控制视图组件
/// 提供视频播放器的基本控制功能，包括播放/暂停、进度控制和全屏切换
struct PlaybackControlView: View {
    /// 播放状态绑定
    /// 控制视频的播放和暂停状态
    /// 当前播放时间（秒）
    /// 视频总时长（秒）
    /// 是否正在编辑进度条
    /// 是否显示全屏模式
    /// AVPlayer 实例，用于控制视频播放
    @Binding var isPlaying: Bool
    @Binding var currentTime: Double
    @Binding var duration: Double
    @Binding var isEditingSlider: Bool
    @Binding var isFullScreenPresented: Bool
    let player: AVPlayer?
    
    var body: some View {
        HStack(spacing: 20) {
            Button(action: {
                if isPlaying {
                    player?.pause()
                } else {
                    player?.play()
                }
                isPlaying.toggle()
            }) {
                Image(systemName: isPlaying ? "pause.circle" : "play.circle")
                    .font(.system(size: 30))
            }
            
            Slider(
                value: $currentTime,
                in: 0...duration,
                onEditingChanged: { editing in
                    isEditingSlider = editing
                    if !editing {
                        player?.seek(to: CMTime(seconds: currentTime, preferredTimescale: 1))
                    }
                }
            )
            .padding(.horizontal)
            
            Button(action: {
                isFullScreenPresented = true
            }) {
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                    .font(.system(size: 20))
            }
        }
        .padding(.horizontal)
    }
}