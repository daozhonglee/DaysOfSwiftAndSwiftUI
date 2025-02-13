//
//  ContentView.swift
//  08.SimplePhotoBrowser
//
//  Created by shanquan on 2025/2/14.
//

// 导入SwiftUI框架，用于构建声明式用户界面
import SwiftUI

// ContentView02是主视图结构体，遵循View协议
// 实现了一个简单的图片浏览器，支持缩放和拖动功能
struct ContentView02: View {
    // 示例图片名称，用于显示的图片资源
    // 确保在Assets.xcassets中添加了名为"samplephoto"的图片资源
    let imageName = "samplephoto"

    // @State属性包装器用于创建视图的内部状态
    // 当这些状态值改变时，SwiftUI会自动重新渲染相关视图
    
    // scale: 当前缩放比例
    // lastScale: 上一次缩放操作结束时的比例，用于计算新的缩放值
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    
    // offset: 当前图片的偏移量
    // lastOffset: 上一次拖动操作结束时的偏移量，用于计算新的偏移值
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    // body是View协议要求实现的计算属性
    // 定义视图的内容和布局结构
    var body: some View {
        // GeometryReader可以读取父视图提供的尺寸信息
        // 用于实现响应式布局
        GeometryReader { geo in
            // ZStack用于层叠布局，后面的视图叠加在前面的视图上
            ZStack {
                // 设置半透明黑色背景
                // opacity设置透明度为0.8
                Color.black.opacity(0.8)
                    // 忽略安全区域，实现全屏显示
                    .edgesIgnoringSafeArea(.all)

                // 创建图片视图
                Image(imageName)
                    // 允许图片调整大小
                    .resizable()
                    // 保持图片的原始宽高比
                    .aspectRatio(contentMode: .fit)
                    // 设置图片宽度等于屏幕宽度
                    .frame(width: geo.size.width)
                    // 应用缩放效果
                    .scaleEffect(scale)
                    // 应用偏移效果
                    .offset(offset)
                    // 添加手势支持
                    .gesture(
                        // MagnificationGesture用于处理捏合缩放手势
                        MagnificationGesture()
                            // 手势变化时更新缩放比例
                            .onChanged { value in
                                scale = lastScale * value
                            }
                            // 手势结束时保存最终的缩放比例
                            .onEnded { _ in
                                lastScale = scale
                            }
                            // simultaneously允许同时处理多个手势
                            .simultaneously(with:
                                // DragGesture用于处理拖动手势
                                DragGesture()
                                    // 拖动时更新偏移量
                                    .onChanged { value in
                                        offset = CGSize(
                                            width: lastOffset.width + value.translation.width,
                                            height: lastOffset.height + value.translation.height
                                        )
                                    }
                                    // 拖动结束时保存最终的偏移量
                                    .onEnded { _ in
                                        lastOffset = offset
                                    }
                            )
                    )
            }
        }
    }
}

// 预览提供器，用于在Xcode中实时预览UI效果
#Preview {
    ContentView02()
}
