//
//  ContentView.swift
//  24.CoreDataApp
//
//  Created by shanquan on 2025/2/19.
//

// CoreData与SwiftUI集成的主视图
// 展示了如何在SwiftUI中使用CoreData进行数据管理和展示

import SwiftUI
import CoreData

struct ContentView: View {
    // 在 Core Data 中，  viewContext   是一个   NSManagedObjectContext   的实例，用于管理对象的生命周期和数据的持久化。当你通过   viewContext   创建、修改或删除数据时，这些更改需要被保存到持久化存储中（如 SQLite 数据库）。
    // 通过环境变量获取托管对象上下文
    // 用于执行数据库操作
    @Environment(\.managedObjectContext) private var viewContext

    // 使用@FetchRequest从CoreData获取数据
    // @FetchRequest   是 SwiftUI 提供的一个属性包装器，用于从 Core Data 中自动获取和管理数据。它允许 SwiftUI 视图直接与 Core Data 的数据模型交互，并且能够响应数据的变化，从而实现数据的动态更新和展示。
    // sortDescriptors定义数据排序方式
    // animation指定数据变化时的动画效果
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            List {
                // 遍历并展示所有数据项
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        Text(item.timestamp!, formatter: itemFormatter)
                    }
                }
                .onDelete(perform: deleteItems) // 支持滑动删除
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton() // 启用编辑模式的按钮
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }

    // 添加新数据项的方法
    // 使用withAnimation确保UI更新时有动画效果
    private func addItem() {
        withAnimation {
            // 在当前上下文创建新的Item实例
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                // 保存上下文的更改到持久化存储
                try viewContext.save()
            } catch {
                // 错误处理
                // 在开发阶段使用fatalError便于调试
                // 生产环境应该实现proper错误处理
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    // 删除选中数据项的方法
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            // 将选中的索引转换为对应的Item对象并删除
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                // 保存删除操作到持久化存储
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

// 日期格式化器
// 用于格式化Item的timestamp属性
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

// 预览提供器
// 使用预览容器的viewContext
#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
