// ContentView.swift
// 11.StretchyHeader - 一个展示可伸缩头部效果的SwiftUI示例
// 创建日期：2025/2/14

// 导入SwiftUI框架，这是Apple提供的用于构建声明式用户界面的现代框架
import SwiftUI

// ContentView是主视图结构体，遵循View协议
// View协议是SwiftUI中最基本的协议，要求实现body计算属性来描述视图的内容和布局
struct ContentView: View {
    // body是View协议要求实现的计算属性
    // 它定义了视图的内容和布局结构
    var body: some View {
           // ScrollView创建一个可滚动的容器
           // 用户可以在垂直方向上滚动其内容
           ScrollView {
               // GeometryReader用于获取父视图提供的几何信息
               // 它可以读取视图的大小和位置信息，用于实现响应式布局
               GeometryReader { geometry in
                   // 获取视图在全局坐标系中的垂直偏移量
                   // minY表示视图顶部距离屏幕顶部的距离
                   let offset = geometry.frame(in: .global).minY
                   
                   // 创建头部图片视图
                   Image("samplephoto")
                       // 允许图片调整大小
                       .resizable()
                       // 设置图片填充模式为填充，保持宽高比
                       .aspectRatio(contentMode: .fill)
                       // 设置图片框架
                       // 宽度固定为屏幕宽度
                       // 高度根据下拉距离动态调整，实现伸缩效果
                       .frame(width: UIScreen.main.bounds.width,
                              height: offset > 0 ? 250 + offset : 250)
                       // 裁剪超出框架的部分
                       .clipped()
                       // 根据下拉距离调整图片位置
                       // 确保图片始终从顶部开始显示，避免出现空白
                       .offset(y: offset > 0 ? -offset : 0)
               }
               // 设置GeometryReader的固定高度
               .frame(height: 250)

               // 创建列表内容区域
               // VStack用于垂直排列子视图
               VStack(alignment: .leading, spacing: 16) {
                   // 使用ForEach创建20个示例行项目
                   ForEach(0..<20) { index in
                       // 创建行项目视图
                       Text("Row \(index)")
                           // 添加内边距
                           .padding()
                           // 设置框架宽度填充父视图，左对齐
                           .frame(maxWidth: .infinity, alignment: .leading)
                           // 设置白色背景
                           .background(Color.white)
                           // 添加圆角效果
                           .cornerRadius(8)
                           // 添加阴影效果
                           .shadow(radius: 2)
                   }
               }
               // 为列表内容添加内边距
               .padding()
           }
           // 忽略顶部安全区域，使内容延伸到状态栏
           .edgesIgnoringSafeArea(.top)
           // 设置系统分组背景色
           .background(Color(.systemGroupedBackground))
       }
}

#Preview {
    ContentView()
}
