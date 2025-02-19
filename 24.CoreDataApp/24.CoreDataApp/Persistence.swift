//
//  Persistence.swift
//  24.CoreDataApp
//
//  Created by shanquan on 2025/2/19.
//

// CoreData持久化存储的管理类
// 负责初始化和配置CoreData栈，提供数据持久化服务

import CoreData

struct PersistenceController {
    // 单例模式，确保整个应用使用同一个持久化控制器
    static let shared = PersistenceController()

    // 预览数据提供器
    // 用于SwiftUI预览功能，创建一个内存中的临时存储
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        // 创建示例数据
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // 错误处理
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    // 持久化容器
    // 包含了CoreData栈的核心组件：管理对象模型、持久化存储协调器和管理对象上下文
    let container: NSPersistentContainer

    // 初始化方法
    // inMemory参数决定是否使用内存存储（用于预览和测试）
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "_4_CoreDataApp")
        if inMemory {
            // 对于内存存储，将存储URL设置为/dev/null
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        // 加载持久化存储
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                /*
                 常见错误原因包括：
                 * 父目录不存在、无法创建或不允许写入
                 * 设备锁定时由于权限或数据保护导致持久化存储不可访问
                 * 设备存储空间不足
                 * 存储无法迁移到当前模型版本
                 请检查错误信息以确定具体问题
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        // 启用自动合并来自父上下文的更改
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
