SwiftUI 本身尚未直接支持配置这些快捷操作, 所以需要与 uikit 集成完成该项目，这个项目里有 swiftUI 和 UIKit 如何桥接的逻辑。

需要在 info.plist 里添加以下配置：
<key>NSCoreSpotlightUsageDescription</key>
<string>我们希望通过Spotlight帮助您快速找到应用内容</string>

## 测试方法：
1. 运行应用使数据被索引
2. 返回主屏幕，下拉打开 Spotlight 搜索
3. 尝试搜索 "SwiftUI"、"Core Data" 或 "Combine"
4. 点击搜索结果即可跳转到应用对应内容
