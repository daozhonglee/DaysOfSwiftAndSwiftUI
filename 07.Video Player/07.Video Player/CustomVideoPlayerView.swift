import SwiftUI
import AVKit
import PhotosUI

/// 自定义视频播放器视图
/// 提供视频播放、播放控制、全屏切换和视频选择等功能
struct CustomVideoPlayerView: View {
    /// 视频播放器的视图模型，管理播放状态和控制逻辑
    @StateObject private var viewModel = VideoPlayerViewModel()
    
    /// 可选的播放速率列表
    private let playbackRates: [Float] = [0.5, 1.0, 1.5, 2.0]
    
    /// 构建视图的主体部分
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // 视频播放器组件
                // 使用AVKit框架的VideoPlayer来展示视频内容
                VideoPlayer(player: viewModel.player)
                    .frame(height: viewModel.isFullScreen ? geometry.size.height : 300)
                
                // 非全屏模式下显示控制面板
                if !viewModel.isFullScreen {
                    // Controls
                    VStack(spacing: 20) {
                        // 时间进度滑块
                        // 显示当前播放时间和总时长，允许用户拖动调整播放进度
                        HStack {
                            Text(formatTime(viewModel.currentTime))
                            Slider(value: Binding(
                                get: { viewModel.currentTime / max(viewModel.duration, 1) },
                                set: { viewModel.seek(to: $0) }
                            ))
                            Text(formatTime(viewModel.duration))
                        }
                        .padding(.horizontal)
                        
                        // 播放控制按钮组
                        // 包含播放/暂停、播放速率选择和全屏切换按钮
                        HStack(spacing: 30) {
                            // 播放/暂停按钮
                            // 根据当前播放状态显示不同图标
                            Button(action: viewModel.togglePlayPause) {
                                Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                    .font(.system(size: 30))
                            }
                            
                            // 播放速率选择菜单
                            // 提供多个预设速率选项
                            Menu {
                                ForEach(playbackRates, id: \.self) { rate in
                                    Button(String(format: "%.1fx", rate)) {
                                        viewModel.setPlaybackRate(rate)
                                    }
                                }
                            } label: {
                                Text(String(format: "%.1fx", viewModel.playbackRate))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                            }
                            
                            // 全屏切换按钮
                            // 控制视频播放器的显示模式
                            Button(action: viewModel.toggleFullScreen) {
                                Image(systemName: "arrow.up.left.and.arrow.down.right")
                                    .font(.system(size: 20))
                            }
                        }
                        
                        // 视频选择器
                        // 使用PhotosPicker来访问设备相册中的视频
                        PhotosPicker(
                            selection: $viewModel.selectedItem,
                            matching: .videos
                        ) {
                            Label("Select Video", systemImage: "photo.fill")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.bottom)
                }
            }
        }
        .onChange(of: viewModel.selectedItem) { _ in
            if let item = viewModel.selectedItem {
                viewModel.loadVideo(from: item)
            }
        }
        .statusBar(hidden: viewModel.isFullScreen)
    }
    
    /// 将秒数转换为时间格式字符串（MM:SS）
    /// - Parameter timeInSeconds: 需要转换的秒数
    /// - Returns: 格式化后的时间字符串
    private func formatTime(_ timeInSeconds: Double) -> String {
        let minutes = Int(timeInSeconds / 60)
        let seconds = Int(timeInSeconds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    CustomVideoPlayerView()
}
