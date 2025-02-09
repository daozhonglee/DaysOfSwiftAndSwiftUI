//
//  ContentView.swift
//  04.LimitedInputTextField
//
//  Created by shanquan on 2025/2/10.
//

import SwiftUI

struct ContentView: View {
    // 用于存储用户输入的文本
    @State private var inputText: String = ""
    // 限制的最大字符数，例如设置为10个字符
    private let characterLimit: Int = 10

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("请输入内容（最多 \(characterLimit) 个字符）：")
                .font(.headline)

            TextEditor(text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            // 每当 inputText 变化时检查是否超出限制
                .onChange(of: inputText) { oldValue, newValue in
                    if newValue.count > characterLimit {
                        // 截取前 characterLimit 个字符，避免输入过长
                        inputText = String(newValue.suffix(characterLimit))
                        debugPrint("输入超过限制", oldValue)
                    }
                }
                .frame(height: 100)
                .padding(3)
                .border(Color.gray, width: 1)

            Text("当前字数：\(inputText.count)")
                .padding(.horizontal)

            Spacer()
        }
        .padding(.top, 50)
    }
}

#Preview {
    ContentView()
}
