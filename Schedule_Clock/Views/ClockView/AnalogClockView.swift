//
//  AnalogClockView.swift
//  Schedule_Clock
//
//  Created by Taiyo KOSHIBA on 2025/01/26.
//



import SwiftUI

// メインのアナログ時計ビュー
struct AnalogClockView: View {
    @State private var currentTime = Date() // 現在の時間を保持

    // 1秒ごとに時間を更新するためのタイマー
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        // GeometryReader → 親ビューのサイズに応じて時計のレイアウトを自動調整
        GeometryReader { geometry in
            let clockSize = min(geometry.size.width, geometry.size.height) // 時計の大きさ（直径）を決定

            ZStack {
                // 時計の背景（円形の盤面と数字）
                ClockFace(geometry: geometry)

                // 時計の針（時針、分針、秒針）
                ClockHands(currentTime: $currentTime, clockSize: clockSize)

                // 時計の中心の小さな円（針の回転の支点）
                Circle()
                    .frame(width: clockSize * 0.04, height: clockSize * 0.04) // 時計の中心の円
            }
            // タイマーが通知を送るたびに処理を実行
            // timerは1秒ごとに通知（イベント）を送信するタイマー
            .onReceive(timer) { _ in
                self.currentTime = Date() // 1秒ごとに時間を更新
            }
        }
        .aspectRatio(1, contentMode: .fit) // 時計が正方形になるように調整
        .padding(20)
    }
}

// 時計の背景（目盛りや枠）
struct ClockFace: View {
    var geometry: GeometryProxy

    var body: some View {
        let clockSize = min(geometry.size.width, geometry.size.height) // 時計のサイズを取得

        return ZStack {
            // 時計の盤面（白い円）
            Circle()
                .fill(Color.white) // 文字盤の背景色
                .frame(width: clockSize, height: clockSize)
                .shadow(radius: 10)  // 影を追加

            // 時計の枠（黒い円）
            Circle()
                .stroke(Color.black, lineWidth: 2)
                .frame(width: clockSize, height: clockSize)
            
            // 12時間分の数字を配置（12, 1, 2, ..., 11）
            ForEach(0..<12) { hour in
                Text("\(hour == 0 ? 12 : hour)") // 0時を12として表示
                    .font(.system(size: clockSize * 0.08, weight: .bold)) // 時計のサイズに応じてフォントサイズを調整
                    .foregroundColor(.black) // 文字の色を黒にする
                    .rotationEffect(.degrees(Double(hour) * -30)) // 文字が正しい位置に並ぶように回転
                    .offset(y: -clockSize * 0.42) // 時計の中心から外側へずらす
                    .rotationEffect(.degrees(Double(hour) * 30)) // 文字の向きを調整
            }
        }
    }
}

// 時計の針（時針、分針、秒針）
struct ClockHands: View {
    @Binding var currentTime: Date
    let clockSize: CGFloat // 時計のサイズ

    var body: some View {
        ZStack {
            // 時針
            HandView(rotation: angleForHour(), lengthRatio: 0.3, color: .black, widthRatio: 0.04, clockSize: clockSize)

            // 分針
            HandView(rotation: angleForMinute(), lengthRatio: 0.4, color: .black, widthRatio: 0.02, clockSize: clockSize)

            // 秒針
            HandView(rotation: angleForSecond(), lengthRatio: 0.45, color: .red, widthRatio: 0.01, clockSize: clockSize)
        }
    }

    // 時針の角度を計算（360度 / 12 = 30度（1時間）、1分ごとに0.5度動く）
    func angleForHour() -> Angle {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: currentTime) % 12 // 12時間制
        let minute = calendar.component(.minute, from: currentTime)
        return Angle.degrees(Double(hour) * 30 + Double(minute) * 0.5)
    }

    // 分針の角度を計算（1分ごとに6度動く）
    func angleForMinute() -> Angle {
        let minute = Calendar.current.component(.minute, from: currentTime)
        return Angle.degrees(Double(minute) * 6)
    }

    // 秒針の角度を計算（1秒ごとに6度動く）
    func angleForSecond() -> Angle {
        let second = Calendar.current.component(.second, from: currentTime)
        return Angle.degrees(Double(second) * 6)
    }
}

// 時計の針（針のデザインと動作）
struct HandView: View {
    var rotation: Angle // 針の回転角度
    var lengthRatio: CGFloat // 時計のサイズに対する針の長さの割合
    var color: Color // 針の色
    var widthRatio: CGFloat // 時計のサイズに対する針の太さの割合
    let clockSize: CGFloat // 時計のサイズ

    var body: some View {
        Rectangle()
            .fill(color) // 針の色
            .frame(width: clockSize * widthRatio, height: clockSize * lengthRatio) // 針の太さと長さを調整
            .offset(y: -clockSize * lengthRatio / 2) // 針の根元を時計の中心に合わせる
            .rotationEffect(rotation) // 針を回転させて正しい位置にする
            .shadow(radius: 2) // 針に少し影をつけて立体感を強調
    }
}


#Preview {
    AnalogClockView()
}
