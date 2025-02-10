import SwiftUI
import AVKit

/// 媒体控制视图组件
/// 提供音量和播放速度的控制功能
struct MediaControlView: View {
    /// 音量值的双向绑定（0-1之间）
    @Binding var volume: Float
    /// 播放速度的双向绑定（0.5-2.0之间）
    @Binding var playbackRate: Float
    /// AVPlayer 实例，用于控制媒体播放
    let player: AVPlayer?
    
    var body: some View {
        // 使用水平堆叠布局排列控制元素
        HStack(spacing: 20) {
            // 音量控制部分
            HStack {
                // 扬声器图标
                Image(systemName: "speaker.fill")
                // 音量滑块，范围为 0-1
                Slider(value: $volume, in: 0...1) { editing in
                    // 当用户停止拖动滑块时更新播放器的音量
                    if !editing {
                        player?.volume = volume
                    }
                }
                .frame(maxWidth: 150)  // 限制滑块的最大宽度
            }
            
            // 播放速度控制部分
            HStack {
                // 显示当前播放速度，保留一位小数
                Text("倍速: \(playbackRate, specifier: "%.1f")x")
                // 速度滑块，范围为 0.5-2.0，每步长 0.5
                Slider(value: $playbackRate, in: 0.5...2.0, step: 0.5) { editing in
                    // 当用户停止拖动滑块时更新播放器的速度
                    if !editing {
                        player?.rate = playbackRate
                    }
                }
                .frame(maxWidth: 150)  // 限制滑块的最大宽度
            }
        }
        .padding(.horizontal)
    }
}