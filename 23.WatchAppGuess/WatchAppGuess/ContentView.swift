import SwiftUI

struct ContentView: View {
    // 随机生成目标数字，范围 1 ~ 100
    @State private var targetNumber = Int.random(in: 1...100)
    // 用户当前猜测的数字，初始值设为 50
    @State private var guess = 50
    // 显示的反馈信息
    @State private var feedback = "猜一个 1~100 的数字"
    // 游戏是否结束的标识
    @State private var gameOver = false

    var body: some View {
        VStack(spacing: 0) {
            Text("猜数字游戏")
                .font(.headline)

            Text("目标范围：1 ~ 100")
                .font(.footnote)

            Text("当前猜测：\(guess)")
                .font(.subheadline)

            // 使用 Stepper 调整猜测值
            Stepper("猜测：\(guess)", value: $guess, in: 1...100)
                .padding(.vertical, 0)


            Button(action: checkGuess) {
                Text("提交")
                    .frame(maxWidth: .infinity)
            }
            .disabled(gameOver)
            .buttonStyle(.borderedProminent)

            Text(feedback)
                .multilineTextAlignment(.center)
                .padding(.top, 5)

            if gameOver {
                Button(action: resetGame) {
                    Text("新游戏")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .padding(.top, 10)
            }
        }
        .padding()
    }

    // 检查用户猜测
    func checkGuess() {
        if guess < targetNumber {
            feedback = "太低了！"
        } else if guess > targetNumber {
            feedback = "太高了！"
        } else {
            feedback = "正确！答案是 \(targetNumber)。"
            gameOver = true
        }
    }

    // 重置游戏
    func resetGame() {
        targetNumber = Int.random(in: 1...100)
        guess = 50
        feedback = "猜一个 1~100 的数字"
        gameOver = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
