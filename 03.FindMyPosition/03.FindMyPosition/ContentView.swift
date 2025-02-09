//
//  ContentView.swift
//  03.FindMyPosition
//
//  Created by shanquan on 2025/2/9.
//

// 导入SwiftUI框架，用于构建声明式用户界面
import SwiftUI
// 导入CoreLocation框架，用于获取和处理位置信息
import CoreLocation

// LocationManager类：负责处理位置相关的功能
// NSObject：继承自基础类，用于实现Objective-C运行时特性
// ObservableObject：遵循该协议使类可以在SwiftUI中作为状态对象使用
// CLLocationManagerDelegate：遵循位置管理器代理协议，用于接收位置更新和错误
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    // 创建CLLocationManager实例，用于管理和访问位置服务
    private let locationManager = CLLocationManager()
    // @Published属性包装器：当值改变时会自动通知观察者
    @Published var location: CLLocation?  // 可选类型，存储位置信息
    @Published var address: String = "未获取地址"  // 存储地理编码后的地址
    @Published var error: Error?  // 存储可能发生的错误
    @Published var isLoading: Bool = false  // 添加加载状态标识
    
    // 初始化方法
    override init() {
        super.init()  // 调用父类初始化方法
        locationManager.delegate = self  // 设置代理为当前类实例
        locationManager.desiredAccuracy = kCLLocationAccuracyBest  // 设置最高精度
    }
    
    // 请求位置权限并开始定位
    func requestLocation() {
        isLoading = true  // 开始加载
        error = nil  // 清除之前的错误
        locationManager.requestWhenInUseAuthorization()  // 请求使用期间的位置权限
        locationManager.requestLocation()  // 请求单次位置更新
    }
    
    // CLLocationManagerDelegate代理方法：处理位置更新
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        isLoading = false  // 位置更新完成，结束加载
        guard let location = locations.last else { return }  // 获取最新的位置信息
        self.location = location
        
        // 创建CLGeocoder实例用于反向地理编码（将坐标转换为地址）
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                // 在主线程更新UI相关的属性
                DispatchQueue.main.async {
                    self.error = error
                }
                return
            }
            
            if let placemark = placemarks?.first {
                DispatchQueue.main.async {
                    // 组合地址信息：城市、区域、街道、门牌号
                    self.address = [placemark.locality, placemark.subLocality, placemark.thoroughfare, placemark.subThoroughfare]
                        .compactMap { $0 }  // 过滤nil值
                        .joined(separator: "")  // 连接字符串
                }
            }
        }
    }

    // CLLocationManagerDelegate代理方法：处理定位错误
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.error = error
        isLoading = false  // 发生错误时也要结束加载
    }
}

// ContentView：SwiftUI的主视图结构
struct ContentView: View {
    // @StateObject属性包装器：创建并管理引用类型的状态对象
    @StateObject private var locationManager = LocationManager()
    
    // 实现View协议要求的body属性
    var body: some View {
        // VStack：垂直堆栈容器
        VStack(spacing: 20) {
            if locationManager.isLoading {
                ProgressView("正在获取位置...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            }
            // 显示地址文本
            Text(locationManager.address)
                .font(.title2)  // 设置字体样式
                .padding()  // 添加内边距

            // 获取位置按钮
            Button(action: {
                locationManager.requestLocation()  // 点击时请求位置
            }) {
                // HStack：水平堆栈容器
                HStack {
                    // 使用SF Symbols系统图标
                    Image(systemName: "location.circle.fill")
                        .imageScale(.large)
                    Text("获取当前位置")
                }
                .padding()
                .background(Color.blue)  // 设置背景色
                .foregroundColor(.white)  // 设置前景色
                .cornerRadius(10)  // 设置圆角
            }
            .disabled(locationManager.isLoading)  // 在加载状态下禁用按钮
            
            // 条件视图：当有错误时显示
            if let error = locationManager.error {
                Text(error.localizedDescription)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
    }
}

// 预览提供器
#Preview {
    ContentView()
}
