//
//  _4_CoreDataAppApp.swift
//  24.CoreDataApp
//
//  Created by shanquan on 2025/2/19.
//

// 应用程序的主入口
// 负责初始化CoreData环境并将其注入到SwiftUI视图层级中

import SwiftUI

@main
struct _4_CoreDataAppApp: App {
    // 创建持久化控制器实例
    // 使用共享实例确保整个应用使用相同的CoreData栈
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                // 通过环境注入托管对象上下文
                // 使得所有子视图都能访问到CoreData上下文
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
