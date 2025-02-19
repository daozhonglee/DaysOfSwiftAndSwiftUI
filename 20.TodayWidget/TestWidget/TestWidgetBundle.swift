//
//  TestWidgetBundle.swift
//  TestWidget
//
//  Created by shanquan on 2025/2/16.
//

import WidgetKit
import SwiftUI

@main
struct TestWidgetBundle: WidgetBundle {
    var body: some Widget {
        TestWidget()
        TestWidgetControl()
        TestWidgetLiveActivity()
    }
}
