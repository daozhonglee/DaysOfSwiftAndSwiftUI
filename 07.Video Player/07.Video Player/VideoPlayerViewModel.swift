import SwiftUI
import AVKit
import PhotosUI

/// 视频播放器视图模型
/// 负责管理视频播放状态、控制播放行为和处理视频加载
class VideoPlayerViewModel: ObservableObject {
    /// AVPlayer实例，用于视频播放控制
    @Published var player = AVPlayer()
    /// 当前播放状态
    @Published var isPlaying = false
    /// 全屏显示状态
    @Published var isFullScreen = false
    /// 当前播放速率
    @Published var playbackRate: Float = 1.0
    /// 选中的视频文件项
    @Published var selectedItem: PhotosPickerItem? = nil
    
    /// 时间观察相关属性
    /// 当前播放时间（秒）
    @Published var currentTime: Double = 0
    /// 视频总时长（秒）
    @Published var duration: Double = 0
    /// 时间观察者引用
    private var timeObserver: Any?
    
    init() {
        setupTimeObserver()
    }
    
    /// 设置播放时间观察器
    /// 每秒更新一次当前播放时间和视频总时长
    private func setupTimeObserver() {
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { [weak self] time in
            self?.currentTime = time.seconds
            self?.duration = self?.player.currentItem?.duration.seconds ?? 0
        }
    }
    
    /// 从PhotosPicker加载选中的视频
    /// - Parameter item: 选中的视频文件项
    func loadVideo(from item: PhotosPickerItem) {
        item.loadTransferable(type: Movie.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movie):
                    if let url = movie?.url {
                        let playerItem = AVPlayerItem(url: url)
                        self?.player.replaceCurrentItem(with: playerItem)
                    }
                case .failure(let error):
                    print("Error loading video: \(error)")
                }
            }
        }
    }
    
    /// 切换播放/暂停状态
    func togglePlayPause() {
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        isPlaying.toggle()
    }
    
    /// 跳转到视频指定位置
    /// - Parameter percentage: 目标位置占总时长的百分比（0-1）
    func seek(to percentage: Double) {
        guard let duration = player.currentItem?.duration else { return }
        let totalSeconds = CMTimeGetSeconds(duration)
        let seekTime = totalSeconds * percentage
        let time = CMTime(seconds: seekTime, preferredTimescale: 1)
        player.seek(to: time)
    }
    
    /// 设置播放速率
    /// - Parameter rate: 目标播放速率
    func setPlaybackRate(_ rate: Float) {
        playbackRate = rate
        player.rate = rate
    }
    
    /// 切换全屏显示状态
    func toggleFullScreen() {
        isFullScreen.toggle()
    }
    
    deinit {
        if let observer = timeObserver {
            player.removeTimeObserver(observer)
        }
    }
}

/// 视频文件传输模型
/// 用于从PhotosPicker加载视频文件
struct Movie: Transferable {
    let url: URL
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .movie) { data in
            let fileName = "video_\(UUID().uuidString).mov"
            let url = URL.documentsDirectory.appending(path: fileName)
            try data.write(to: url)
            return Self.init(url: url)
        }
    }
}
