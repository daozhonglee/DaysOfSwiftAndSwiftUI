//
//  ContentView.swift
//  06.Video Player
//
//  Created by shanquan on 2025/2/10.
//

// 导入必要的框架
import SwiftUI    // 用于构建用户界面
import AVKit      // 用于视频播放功能
import PhotosUI   // 用于访问照片库和视频选择

/// ContentView 是应用的主视图
/// 负责视频播放器的整体布局和功能实现
/// 包含视频播放控件、音量控制、播放速度调节等功能
struct ContentView: View {
    // MARK: - 视频播放相关状态属性
    @State private var playerItems: [AVPlayerItem] = []      // 存储所有待播放的视频项
    @State private var isVideoPickerPresented = false        // 控制视频选择器的显示状态
    @State private var isPlaying = false                     // 当前视频的播放状态
    @State private var player: AVPlayer?                     // 视频播放器实例
    @State private var currentTime: Double = 0               // 当前播放时间（秒）
    @State private var duration: Double = 0                  // 视频总时长（秒）
    @State private var isEditingSlider = false              // 是否正在拖动进度条
    @State private var volume: Float = 1.0                   // 播放音量（0.0-1.0）
    @State private var playbackRate: Float = 1.0             // 播放速度倍率
    @State private var selectedVideoIndex: Int = 0           // 当前选中的视频索引
    @State private var isFullScreenPresented = false         // 是否全屏显示

    // MARK: - 环境变量
    @Environment(\.dismiss) private var dismiss             // 用于关闭当前视图的环境变量

    // MARK: - 视频播放控制方法
      /// 初始化视频播放器
      /// - Parameter playerItem: 要播放的视频项
      /// - Note: 该方法负责初始化或更新播放器，并设置时间观察器
      private func initializePlayer(with playerItem: AVPlayerItem) {
          // 如果播放器不存在，创建新的播放器
          if player == nil {
              player = AVPlayer(playerItem: playerItem)
          } else {
              // 如果播放器已存在，替换当前播放项
              player?.replaceCurrentItem(with: playerItem)
          }

          // 重置播放时间和时长
          currentTime = 0
          duration = 0

          // 获取视频的总时长
          let durationTime = playerItem.asset.duration
          duration = CMTimeGetSeconds(durationTime)  // 将 CMTime 转换为秒

          // 创建一个 0.1 秒间隔的时间观察器
          let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
          // 添加周期性时间观察器，用于更新当前播放时间
          player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak player] time in
              // 如果用户没有在编辑进度条，则更新当前时间
              if !self.isEditingSlider {
                  self.currentTime = CMTimeGetSeconds(time)
              }
          }

          // 异步加载视频资产的时长信息
          playerItem.asset.loadValuesAsynchronously(forKeys: ["duration"]) {
              // 在主线程上更新 UI
              DispatchQueue.main.async {
                  var error: NSError?
                  // 检查时长信息的加载状态
                  let status = playerItem.asset.statusOfValue(forKey: "duration", error: &error)
                  if status == .loaded {
                      // 如果加载成功，更新时长并开始播放
                      let duration = playerItem.asset.duration
                      self.duration = CMTimeGetSeconds(duration)
                      self.isPlaying = true
                      self.player?.play()
                  }
              }
          }
      }


    // MARK: - Body 视图构建
    var body: some View {
        NavigationView {                    // 导航视图容器
            ScrollView {                     // 可滚动容器
                VStack(spacing: 16) {        // 垂直布局，子视图间距16点
                    // 关闭按钮视图
                    CloseButtonView(action: {
                        player?.pause()           // 暂停播放
                        player = nil             // 释放播放器
                        playerItems.removeAll()  // 清空播放列表
                        dismiss()                // 关闭视图
                    })

                    // 如果有视频项，显示播放器
                    if !playerItems.isEmpty {
                        if let player = player {
                            // 视频播放器视图
                            VideoPlayerView(
                                player: player,                              // 播放器实例
                                isFullScreenPresented: $isFullScreenPresented // 全屏状态绑定
                            )

                            VStack(spacing: 16) {
                                // 播放控制视图（包含播放/暂停、进度条等）
                                PlaybackControlView(
                                    isPlaying: $isPlaying,                    // 播放状态
                                    currentTime: $currentTime,                // 当前时间
                                    duration: $duration,                      // 总时长
                                    isEditingSlider: $isEditingSlider,       // 进度条编辑状态
                                    isFullScreenPresented: $isFullScreenPresented, // 全屏状态
                                    player: player                           // 播放器实例
                                )

                                // 媒体控制视图（音量和播放速度控制）
                                MediaControlView(
                                    volume: $volume,                         // 音量控制
                                    playbackRate: $playbackRate,             // 播放速度控制
                                    player: player                           // 播放器实例
                                )

                                // 当有多个视频时显示视频选择器
                                if playerItems.count > 1 {
                                    Picker("选择视频", selection: $selectedVideoIndex) {
                                        // 为每个视频创建选择项
                                        ForEach(0..<playerItems.count, id: \.self) { index in
                                            Text("视频 \(index + 1)").tag(index)
                                        }
                                    }
                                    .pickerStyle(SegmentedPickerStyle())    // 使用分段控件样式
                                    .padding(.horizontal)                    // 水平内边距
                                    // 当选择的视频改变时
                                    .onChange(of: selectedVideoIndex) { newIndex in
                                        player.replaceCurrentItem(with: playerItems[newIndex]) // 切换到新视频
                                        isPlaying = true                     // 设置为播放状态
                                        player.play()                        // 开始播放
                                    }
                                }
                            }
                        }
                    } else {
                        // 当没有视频时显示提示文本
                        Text("请选择一个视频")
                            .padding()
                            .foregroundColor(.gray)
                    }

                    // 选择视频按钮
                    Button("选择视频") {
                        isVideoPickerPresented = true          // 显示视频选择器
                    }
                    .padding()

                    // 视频选择器sheet视图
                    .sheet(isPresented: $isVideoPickerPresented) {
                        VideoPicker(playerItems: $playerItems) {
                            // 选择完成后，如果有视频则初始化播放器
                            if let firstItem = playerItems.first {
                                initializePlayer(with: firstItem)
                            }
                        }
                    }
                }
            }
        }
        // 定时器用于更新播放进度
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
            // 如果不在编辑进度条且播放器存在，更新当前时间
            if !isEditingSlider, let currentTime = player?.currentTime() {
                self.currentTime = CMTimeGetSeconds(currentTime)
            }
        }
        // 当视频列表发生变化时
        .onChange(of: playerItems) { _ in
            // 如果有视频，初始化播放器
            if let firstItem = playerItems.first {
                initializePlayer(with: firstItem)
            }
        }
    }
}

#Preview {
    ContentView()
}
