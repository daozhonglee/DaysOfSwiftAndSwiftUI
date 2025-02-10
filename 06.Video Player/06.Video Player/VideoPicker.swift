// VideoPicker.swift
/// 视频选择器组件
/// 使用 PhotosUI 框架实现视频文件的选择功能
/// 支持多选和 iCloud 视频下载

// 导入所需的框架
import SwiftUI      // 用于构建用户界面
import PhotosUI     // 用于访问照片库和视频选择器
import Photos       // 用于处理照片和视频资产
import AVKit        // 用于视频播放功能

// MARK: - 视频选择器组件
/// 视频选择器视图
/// 遵循 UIViewControllerRepresentable 协议，将 UIKit 的选择器包装为 SwiftUI 视图
///
/// 使用方式：
/// ```swift
/// @State private var playerItems: [AVPlayerItem] = []
/// @State private var showPicker = false
///
/// var body: some View {
///     VideoPicker(playerItems: $playerItems) {
///         // 选择完成后的处理
///     }
/// }
/// ```
///
/// 功能特点：
/// - 支持多视频选择
/// - 支持 iCloud 视频
/// - 自动处理权限请求
/// - 主线程安全的UI更新
struct VideoPicker: UIViewControllerRepresentable {
    // 绑定属性，用于存储选中的视频项目列表
    @Binding var playerItems: [AVPlayerItem]
    
    // 可选的回调闭包，在视频选择完成后调用
    var onVideoSelected: (() -> Void)?

    // MARK: - UIViewControllerRepresentable 协议实现
    // 创建并返回视频选择器控制器
    func makeUIViewController(context: Context) -> PHPickerViewController {
        // 创建照片库选择器配置
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .videos // 限制只能选择视频
        config.selectionLimit = 0 // 0表示不限制选择数量
        
        // 创建选择器控制器并设置代理
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    // 更新视图控制器（此处不需要实现具体逻辑）
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    // 创建协调器实例
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // MARK: - 协调器类定义
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        // 持有对父视图的引用
        let parent: VideoPicker
        
        // 初始化协调器
        init(_ parent: VideoPicker) {
            self.parent = parent
        }
        
        // 处理视频选择完成的回调
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            // 关闭选择器界面
            picker.dismiss(animated: true)
            
            // 处理每个选中的结果
            for result in results {
                if let assetIdentifier = result.assetIdentifier {
                    // 通过标识符获取资源
                    let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetIdentifier], options: nil)
                    if let asset = fetchResult.firstObject {
                        // 加载视频资源
                        loadVideo(from: asset) { playerItem in
                            if let playerItem = playerItem {
                                // 在主线程更新UI
                                DispatchQueue.main.async {
                                    // 添加到播放列表
                                    self.parent.playerItems.append(playerItem)
                                    // 如果是第一个视频，调用选择完成回调
                                    if self.parent.playerItems.count == 1 {
                                        self.parent.onVideoSelected?()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // 从PHAsset加载视频资源
        private func loadVideo(from asset: PHAsset, completion: @escaping (AVPlayerItem?) -> Void) {
            // 配置视频加载选项
            let options = PHVideoRequestOptions()
            options.isNetworkAccessAllowed = true // 允许从iCloud下载
            
            // 请求视频资源
            PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { (avAsset, audioMix, info) in
                if let avAsset = avAsset {
                    // 创建播放项目
                    let playerItem = AVPlayerItem(asset: avAsset)
                    completion(playerItem)
                } else {
                    completion(nil)
                }
            }
        }
    }
}