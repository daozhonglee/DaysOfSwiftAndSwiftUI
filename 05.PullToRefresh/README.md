从这个项目中，可以学到如下 swift 知识点：

1. **CoreLocation 框架的使用**
   - 位置服务的基本配置和使用
   - 位置权限的请求和处理
   - 地理编码和反向地理编码
   - 位置精度的设置

2. **iOS 代理模式**
   - CLLocationManagerDelegate 的实现
   - 代理方法的使用
   - 位置更新和错误处理的回调

3. **SwiftUI 状态管理**
   - ObservableObject 协议的使用
   - @Published 属性包装器
   - @StateObject 的应用
   - 状态驱动的 UI 更新

4. **异步编程**
   - DispatchQueue 的使用
   - 异步回调的处理
   - 主线程 UI 更新

5. **Swift 高级特性**
   - 可选值的安全处理（guard let）
   - 数组操作（compactMap）
   - 字符串处理（joined）
   - 错误处理机制

6. **SwiftUI 界面构建**
   - 视图的组织和布局
   - 条件渲染
   - SF Symbols 的使用
   - 界面样式定制
   

需要添加 info.plist 权限

<key>NSLocationWhenInUseUsageDescription</key>
<string>我们需要您的位置以提供更好的服务</string>

<key>NSLocationAlwaysUsageDescription</key>
<string>我们需要访问您的位置，即使应用在后台运行</string>