//
//  ContentView.swift
//  20.TodayWidget
//
//  Created by shanquan on 2025/2/16.
//

import WidgetKit
import SwiftUI
import Intents

// MARK: - Timeline Entry 模型
struct SimpleEntry: TimelineEntry {
    let date: Date
    let text: String
}

// MARK: - Timeline Provider
struct Provider: TimelineProvider {
    // 提供占位数据
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), text: "加载中...")
    }

    // 快照模式，通常用于 Widget 配置预览
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), text: "Hello, Widget!")
        completion(entry)
    }

    // 构建时间线
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()

        // 这里以每 30 分钟更新一次为例，可根据需要调整刷新频率
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!

        // 从共享 UserDefaults 中获取数据
        let sharedDefaults = UserDefaults(suiteName: "group.com.yourcompany.appgroup")
        let text = sharedDefaults?.string(forKey: "TodayWidgetText") ?? "默认内容"

        let entry = SimpleEntry(date: currentDate, text: text)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .after(refreshDate))
        completion(timeline)
    }
}

// MARK: - Widget 显示界面
struct TodayWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        // 这里可以根据需要自定义布局和样式
        VStack(alignment: .center, spacing: 8) {
            Text("Today Widget")
                .font(.headline)
                .foregroundColor(.accentColor)
            Text(entry.text)
                .font(.body)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
