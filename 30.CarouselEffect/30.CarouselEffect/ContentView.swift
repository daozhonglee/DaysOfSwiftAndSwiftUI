//
//  ContentView.swift
//  30.CarouselEffect
//
//  Created by shanquan on 2025/2/19.
//

import SwiftUI


// 模型定义
struct CarouselItem: Identifiable {
    let id = UUID()
    let imageName: String
}

struct CarouselView: View {
    // 示例图片数据，请在 Assets 中添加相应图片
    let items: [CarouselItem] = [
        CarouselItem(imageName: "image"),
        CarouselItem(imageName: "image2"),
        CarouselItem(imageName: "image3"),
        CarouselItem(imageName: "image4"),
        CarouselItem(imageName: "image5")
    ]

    var body: some View {
        GeometryReader { outerGeometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(items) { item in
                        // 利用内层 GeometryReader 计算每个 item 与屏幕中心的距离
                        GeometryReader { innerGeometry in
                            let midX = innerGeometry.frame(in: .global).midX
                            let screenMidX = outerGeometry.size.width / 2
                            // 根据 item 中点与屏幕中点的距离，计算缩放比例，距离越近 scale 越大
                            let scale = max(0.8, 1 - abs(midX - screenMidX) / outerGeometry.size.width)

                            Image(item.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 200, height: 300)
                                .clipped()
                                .cornerRadius(10)
                                .scaleEffect(scale)
                                .animation(.easeOut, value: scale)
                        }
                        // 固定内层视图尺寸
                        .frame(width: 200, height: 300)
                    }
                }
                // 添加左右内边距，使第一个和最后一个 item 居中显示
                .padding(.horizontal, (outerGeometry.size.width - 200) / 2)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView: View {
    var body: some View {
        CarouselView()
    }
}


#Preview {
    ContentView()
}
