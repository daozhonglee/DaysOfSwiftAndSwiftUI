//
//  TodayWidgetBundle.swift
//  TodayWidget
//
//  Created by zhihu on 17/02/2025.
//

import WidgetKit
import SwiftUI

@main
struct TodayWidgetBundle: WidgetBundle {
    var body: some Widget {
        TodayWidget()
        TodayWidgetControl()
        TodayWidgetLiveActivity()
    }
}
