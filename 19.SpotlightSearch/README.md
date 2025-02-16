# _9_SpotlightSearchApp

需要在 info.plist 里添加以下配置：
<key>NSCoreSpotlightUsageDescription</key>
<string>我们希望通过Spotlight帮助您快速找到应用内容</string>

## 测试方法：
1. 运行应用使数据被索引
2. 返回主屏幕，下拉打开 Spotlight 搜索
3. 尝试搜索 "SwiftUI"、"Core Data" 或 "Combine"
4. 点击搜索结果即可跳转到应用对应内容


# _9_SpotlightSearchAppDemo02

使用 SwiftUI 的现代应用生命周期（无需 AppDelegate）

要测试第二个 demo，可以将第一个 demo 中的@main 这行注释掉