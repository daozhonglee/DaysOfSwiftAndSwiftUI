// 导入必要的框架
import SwiftUI          // SwiftUI框架，用于构建用户界面
import CoreSpotlight    // CoreSpotlight框架，用于实现Spotlight搜索功能
import UIKit           // UIKit框架，用于访问iOS系统功能

// MARK: - 数据模型
// SpotlightItem结构体：定义可搜索内容的数据模型
// 遵循Identifiable协议，使其可以在List等视图中唯一标识
struct SpotlightItem: Identifiable {
    let id: String
    let title: String
    let content: String
}

// MARK: - 主视图
// ContentView：应用程序的主要视图结构
// 负责显示可搜索项目的列表，并处理Spotlight搜索跳转
struct ContentView: View {
    let items = [
        SpotlightItem(id: "1", title: "SwiftUI 教程", content: "学习 SwiftUI 基础知识"),
        SpotlightItem(id: "2", title: "Core Data 指南", content: "掌握数据持久化技术"),
        SpotlightItem(id: "3", title: "Combine 入门", content: "响应式编程框架学习")
    ]

    // 使用@State属性包装器声明可变状态
    // 用于存储从Spotlight搜索结果选中的项目
    @State private var selectedItem: SpotlightItem?

    // 视图主体，定义UI布局和交互逻辑
    var body: some View {
        NavigationView {
            List(items) { item in
                NavigationLink(destination: DetailView(item: item)) {
                    VStack(alignment: .leading) {
                        Text(item.title)
                        Text(item.content)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("知识库")
            // 添加用户活动继续处理器，用于响应Spotlight搜索结果的点击
            .onContinueUserActivity(CSSearchableItemActionType, perform: handleSpotlightSelection)
        }
    }

    // 处理Spotlight搜索结果的选择
    // 当用户从Spotlight搜索结果中点击某项时，此方法被调用
    private func handleSpotlightSelection(_ userActivity: NSUserActivity) {
        if let identifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
            selectedItem = items.first { $0.id == identifier }
        }
    }
}

// MARK: - 详情视图
// DetailView：显示单个项目详细信息的视图
// 当用户从列表或Spotlight搜索结果中选择某项时显示
struct DetailView: View {
    let item: SpotlightItem

    var body: some View {
        VStack {
            Text(item.title)
                .font(.largeTitle)
            Text(item.content)
                .font(.body)
                .padding()
            Spacer()
        }
        .navigationTitle("详情")
    }
}

// MARK: - Spotlight 配置
// AppDelegate：应用程序委托类
// 负责在应用启动时配置和索引Spotlight搜索项目
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        indexSpotlightItems()
        return true
    }

    // 创建和更新Spotlight搜索索引
    // 将应用程序的内容项目添加到系统搜索索引中
    private func indexSpotlightItems() {
        let items = [
            SpotlightItem(id: "1", title: "SwiftUI 教程", content: "学习 SwiftUI 基础知识"),
            SpotlightItem(id: "2", title: "Core Data 指南", content: "掌握数据持久化技术"),
            SpotlightItem(id: "3", title: "Combine 入门", content: "响应式编程框架学习")
        ]

        // 将SpotlightItem转换为系统可搜索项目
        let searchableItems = items.map { item in
            // 创建搜索属性集，设置内容类型为文本
            let attributeSet = CSSearchableItemAttributeSet(contentType: .text)
            attributeSet.title = item.title                    // 设置搜索结果标题
            attributeSet.contentDescription = item.content      // 设置搜索结果描述
            attributeSet.thumbnailData = UIImage(systemName: "book.fill")?.pngData()  // 设置搜索结果缩略图

            // 创建可搜索项目
            return CSSearchableItem(
                uniqueIdentifier: item.id,                      // 唯一标识符
                domainIdentifier: "com.yourcompany.spotlightdemo", // 域标识符
                attributeSet: attributeSet                      // 搜索属性集
            )
        }

        CSSearchableIndex.default().indexSearchableItems(searchableItems) { error in
            if let error = error {
                print("索引失败: \(error.localizedDescription)")
            } else {
                print("索引成功")
            }
        }
    }
}

// MARK: - 入口
// @main标记此结构体为应用程序的入口点
@main
// SpotlightDemoApp：应用程序主结构体
// 遵循App协议，定义应用程序的根级结构
struct SpotlightDemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
