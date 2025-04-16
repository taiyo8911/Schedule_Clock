//
//  DigitalClockView.swift
//  Schedule_Clock
//
//  Created by Taiyo KOSHIBA on 2025/01/26.
//

//import SwiftUI
//
//class ClockViewModel: ObservableObject {
//    @Published var currentTime = Date()
//    private var timer: Timer?
//
//    init() {
//        startTimer()
//    }
//
//    func startTimer() {
//        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
//            self?.currentTime = Date()
//        }
//    }
//
//    deinit {
//        timer?.invalidate()
//    }
//}
//
//struct DigitalClockView: View {
//    @StateObject private var clockViewModel = ClockViewModel()
//
//    var body: some View {
//        Text(timeString)
//            .font(.system(size: 40, weight: .bold, design: .monospaced))
//            .onAppear {
//                clockViewModel.startTimer()
//            }
//    }
//
//    private var timeString: String {
//        TimeUtils.formatTime(clockViewModel.currentTime, format: "H:mm:ss")
//    }
//}
//
//#Preview {
//    DigitalClockView()
//}


import SwiftUI

struct DigitalClockView: View {
    @StateObject private var clockViewModel = ClockViewModel()  // 時計のデータを管理するViewModelを使用

    var body: some View {
        Text(timeString)  // 現在時刻を文字で表示
            .font(.system(size: 40, weight: .bold, design: .monospaced))
            .onAppear {
                clockViewModel.startTimer()  // 画面が表示されたらタイマーを開始
            }
    }

    // 現在の時間をフォーマットして文字列として取得
    private var timeString: String {
        TimeUtils.formatTime(clockViewModel.currentTime, format: "H:mm:ss")
    }
}


#Preview {
    DigitalClockView()
}
