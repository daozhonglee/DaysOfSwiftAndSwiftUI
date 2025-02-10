//
//  ContentView.swift
//  06.Video Player
//
//  Created by shanquan on 2025/2/10.
//

import SwiftUI
import AVKit
import PhotosUI


struct ContentView: View {
    // MARK: - 视频播放相关状态属性
    @State private var playerItems: [AVPlayerItem] = []
    @State private var isVideoPickerPresented = false
    @State private var isPlaying = false
    @State private var player: AVPlayer?
    @State private var currentTime: Double = 0
    @State private var duration: Double = 0
    @State private var isEditingSlider = false
    @State private var volume: Float = 1.0
    @State private var playbackRate: Float = 1.0
    @State private var selectedVideoIndex: Int = 0
    @State private var isFullScreenPresented = false

    // MARK: - 环境变量
    @Environment(\.dismiss) private var dismiss

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


    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    CloseButtonView(action: {
                        player?.pause()
                        player = nil
                        playerItems.removeAll()
                        dismiss()
                    })

                    if !playerItems.isEmpty {
                        if let player = player {
                            VideoPlayerView(
                                player: player,
                                isFullScreenPresented: $isFullScreenPresented
                            )

                            VStack(spacing: 16) {
                                PlaybackControlView(
                                    isPlaying: $isPlaying,
                                    currentTime: $currentTime,
                                    duration: $duration,
                                    isEditingSlider: $isEditingSlider,
                                    isFullScreenPresented: $isFullScreenPresented,
                                    player: player
                                )

                                MediaControlView(
                                    volume: $volume,
                                    playbackRate: $playbackRate,
                                    player: player
                                )

                                if playerItems.count > 1 {
                                    Picker("选择视频", selection: $selectedVideoIndex) {
                                        ForEach(0..<playerItems.count, id: \.self) { index in
                                            Text("视频 \(index + 1)").tag(index)
                                        }
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                    .padding(.horizontal)
                                    .onChange(of: selectedVideoIndex) { newIndex in
                                        player.replaceCurrentItem(with: playerItems[newIndex])
                                        isPlaying = true
                                        player.play()
                                    }
                                }
                            }
                        }
                    } else {
                        Text("请选择一个视频")
                            .padding()
                            .foregroundColor(.gray)
                    }

                    Button("选择视频") {
                        isVideoPickerPresented = true
                    }
                    .padding()

                    .sheet(isPresented: $isVideoPickerPresented) {
                        VideoPicker(playerItems: $playerItems) {
                            if let firstItem = playerItems.first {
                                initializePlayer(with: firstItem)
                            }
                        }
                    }
                }
            }
        }
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
            if !isEditingSlider, let currentTime = player?.currentTime() {
                self.currentTime = CMTimeGetSeconds(currentTime)
            }
        }
        .onChange(of: playerItems) { _ in
            if let firstItem = playerItems.first {
                initializePlayer(with: firstItem)
            }
        }
    }
}

#Preview {
    ContentView()
}
