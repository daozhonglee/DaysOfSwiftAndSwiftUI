import SwiftUI
import CoreSpotlight
import UIKit

// MARK: - 统一实现
struct SpotlightItem02: Identifiable, Hashable {
    let id: String
    var title: String
    var content: String
    var keywords: [String]
    var lastUpdated: Date
    var priority: Int
}

struct ContentView02: View {
    // 示例数据
    @State private var items = [
        SpotlightItem02(
            id: "1",
            title: "SwiftUI 教程",
            content: "学习声明式界面开发",
            keywords: ["界面", "动画"],
            lastUpdated: .now,
            priority: 5
        ),
        SpotlightItem02(
            id: "2",
            title: "Core Data 指南",
            content: "数据持久化解决方案",
            keywords: ["数据库", "存储"],
            lastUpdated: .now.addingTimeInterval(-3600),
            priority: 3
        )
    ]

    @State private var selectedItemID: String?
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationStack {
            List(items) { item in
                NavigationLink(
                    destination: DetailView0202(item: item),
                    tag: item.id,
                    selection: $selectedItemID
                ) {
                    VStack(alignment: .leading) {
                        Text(item.title)
                            .font(.headline)
                        Text(item.content)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("知识库")
            .onContinueUserActivity(CSSearchableItemActionType) { activity in
                handleSpotlightActivity(activity)
            }
            .task(indexOnAppear) // iOS 15+ 的异步任务修饰器
            .onChange(of: scenePhase) {
                if scenePhase == .active {
                    Task { await indexItems() }
                }
            }
        }
    }

    // 初始化索引
    @Sendable func indexOnAppear() async {
        await indexItems()
    }

    // 处理 Spotlight 跳转
    private func handleSpotlightActivity(_ activity: NSUserActivity) {
        guard let identifier = activity.userInfo?[CSSearchableItemActivityIdentifier] as? String else { return }
        selectedItemID = identifier
    }

    // 索引逻辑
    private func indexItems() async {
        let searchableItems = items.map { item in
            let attributes = CSSearchableItemAttributeSet(contentType: .text)
            attributes.title = item.title
            attributes.contentDescription = item.content
            attributes.keywords = item.keywords
            attributes.rankingHint = NSNumber(value:item.priority)
            attributes.lastUsedDate = item.lastUpdated
            attributes.thumbnailData = UIImage(systemName: "book.closed.fill")?.pngData()

            return CSSearchableItem(
                uniqueIdentifier: item.id,
                domainIdentifier: "com.example.spotlight",
                attributeSet: attributes
            )
        }

        do {
            try await CSSearchableIndex.default().indexSearchableItems(searchableItems)
            print("索引更新成功")
        } catch {
            print("索引失败: \(error.localizedDescription)")
        }
    }
}

struct DetailView0202: View {
    let item: SpotlightItem02

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(item.title)
                .font(.largeTitle.bold())

            Text(item.content)
                .font(.title3)
                .foregroundStyle(.secondary)

            VStack(alignment: .leading) {
                Text("最后更新: \(item.lastUpdated.formatted(date: .abbreviated, time: .shortened))")
                Text("优先级: \(item.priority)")
                Text("关键词: \(item.keywords.joined(separator: ", "))")
            }
            .font(.caption)
            .foregroundStyle(.tertiary)

            Spacer()
        }
        .padding()
        .navigationTitle("详情")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 应用入口
@main
struct SpotlightApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView02()
        }
    }
}
