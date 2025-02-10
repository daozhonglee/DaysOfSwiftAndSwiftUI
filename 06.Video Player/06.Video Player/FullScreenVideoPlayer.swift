import SwiftUI
import AVKit

/// 全屏视频播放器组件
/// 提供视频的全屏播放功能，支持视频播放控制和退出全屏
struct FullScreenVideoPlayer: View {
    // MARK: - 属性
    let player: AVPlayer
    @Binding var isPresented: Bool
    
    // MARK: - 环境变量
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // 视频播放器
            VideoPlayer(player: player)
                .edgesIgnoringSafeArea(.all)
            
            // 关闭按钮
            VStack {
                HStack {
                    Button(action: {
                        isPresented = false
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                    }
                    Spacer()
                }
                Spacer()
            }
        }
        .statusBar(hidden: true)
        .onAppear {
            // 进入全屏时设置设备方向为横屏
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue,
                                    forKey: "orientation")
        }
        .onDisappear {
            // 退出全屏时恢复设备方向为竖屏
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue,
                                    forKey: "orientation")
        }
    }
}

#Preview {
    FullScreenVideoPlayer(
        player: AVPlayer(),
        isPresented: .constant(true)
    )
}