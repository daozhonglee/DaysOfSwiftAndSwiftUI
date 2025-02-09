//
//  ContentView.swift
//  05.PullToRefresh
//
//  Created by shanquan on 2025/2/10.
//

import SwiftUI

struct ContentView: View {
    // @State是SwiftUI的属性包装器，用于在视图中创建可变状态
    // 当items数组发生变化时，SwiftUI会自动重新渲染相关视图
    @State private var items: [String] = []

    var body: some View {
        // NavigationView是SwiftUI提供的导航容器，用于实现页面导航功能
        NavigationView{
            // List是SwiftUI的列表容器，用于显示可滚动的数据列表
            // id: \.self表示使用数组元素本身作为唯一标识符
            List(items, id: \.self){ item in
                // 列表的每一行显示一个Text视图
                Text(item)
            }

            // .refreshable修饰符添加下拉刷新功能
            // 由于loadData是异步函数，这里使用await等待其完成
            .refreshable {
                await loadData()
            }
            // .onAppear修饰符在视图首次出现时触发
            .onAppear(){
                //初始化加载数据
                loadInitialData()
            }
            // .navigationTitle设置导航栏标题
            .navigationTitle("下拉刷新")
        }
    }

    // 初始加载数据的方法
    // 这是一个同步函数，直接设置初始数据
    func loadInitialData() {
        items = ["苹果", "香蕉", "橙子", "葡萄", "草莓"]
    }

    // 模拟刷新数据的异步方法
    // async关键字表明这是一个异步函数
    func loadData() async {
        // Task.sleep模拟网络延迟，参数单位是纳秒（这里是2秒）
        // try? 表示忽略可能的错误
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        // 生成一个随机的新水果项
        let newItem = "水果 \(Int.random(in: 1...100))"
        
        // MainActor.run确保在主线程上更新UI
        // 因为UI更新必须在主线程进行
        await MainActor.run {
            items.append(newItem)
        }
    }
}

// 预览提供器，用于在Xcode中实时预览UI
#Preview {
    ContentView()
}
