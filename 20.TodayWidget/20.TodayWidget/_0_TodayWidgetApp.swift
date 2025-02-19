//
//  _0_TodayWidgetApp.swift
//  20.TodayWidget
//
//  Created by shanquan on 2025/2/16.
//

import SwiftUI
import WidgetKit
import SwiftUI
import Intents


@main
struct TodayWidgetApp: Widget{
    let kind: String = "TodayWidget"

      var body: some WidgetConfiguration {
          StaticConfiguration(kind: kind, provider: Provider()) { entry in
              TodayWidgetEntryView(entry: entry)
          }
          .configurationDisplayName("我的 Today Widget")
          .description("显示来自共享数据的内容。")
          .supportedFamilies([.systemSmall, .systemMedium])
      }
}
