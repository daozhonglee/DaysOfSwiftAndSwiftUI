//
//  ContentView.swift
//  01.CustomFont
//
//  Created by shanquan on 2025/2/9.
//

import SwiftUI // 导入SwiftUI框架，这是构建iOS UI所需的基础框架

// FontInfo是一个遵循Identifiable协议的结构体，用于在列表中唯一标识每个字体家族
// Identifiable要求结构体必须有一个id属性
struct FontInfo: Identifiable {
    let id = UUID() // 使用UUID生成唯一标识符
    let family: String // 字体家族名称
    let fonts: [String] // 该字体家族下的所有字体名称数组
}

// ContentView是主视图结构体，遵循View协议
// View协议要求实现body计算属性，返回某个View类型
struct ContentView: View {
    // 使用属性初始化器创建字体信息数组
    // 这是一个只读计算属性，在视图初始化时就会计算并保持不变
    let fontInfos: [FontInfo] = {
        let families = UIFont.familyNames.sorted() // 获取系统所有字体家族名称并排序
        return families.map { family in // 使用map转换数组
            let fonts = UIFont.fontNames(forFamilyName: family).sorted() // 获取每个家族的具体字体
            return FontInfo(family: family, fonts: fonts) // 创建FontInfo实例
        }
    }()

    // @State属性包装器用于在视图中创建可变状态
    // 当这个值改变时，SwiftUI会自动重新渲染相关视图
    @State private var familyName: String = "Arial"

    // body是View协议要求的计算属性，定义视图的内容和布局
    var body: some View {
        // Spacer()用于创建弹性空间，使内容均匀分布
        Spacer()

        // VStack创建垂直方向的视图堆栈
        VStack{
            Text("Hello Swift UI") // 创建文本视图
                .font(.custom(familyName, size: 40)) // 使用自定义字体
                .padding() // 添加内边距
        }
        .frame(height: 300)

        Spacer()
        // 创建一个按钮，点击时随机改变字体

        Button(action: {
            randAFamily() // 点击时调用随机选择字体的方法
        }){
            // 按钮的外观定义
            Text("Change Font Family")
                .font(.title) // 使用预定义的标题字体
                .padding() // 添加内边距
                .background(Color.blue) // 设置背景色
                .foregroundColor(.white) // 设置前景色（文字颜色）
                .cornerRadius(10) // 设置圆角
        }
        .padding(.bottom, 100) // 设置底部内边距

    }

    // 私有方法，用于随机选择一个字体家族
    private func randAFamily() {
        familyName = fontInfos.randomElement()!.family // 从字体数组中随机选择一个元素
    }

}

#Preview {
    ContentView()
}
