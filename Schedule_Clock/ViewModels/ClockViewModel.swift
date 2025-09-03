//
//  ClockViewModel.swift
//  Schedule_Clock
//
//  Created by Taiyo KOSHIBA on 2025/02/02.
//

import SwiftUI

// 時計の時間を管理する ViewModel
class ClockViewModel: ObservableObject {
    @Published var currentTime = Date()  // 現在の時間（1秒ごとに更新）
    private var timer: Timer?
    private var isTimerRunning = false  // タイマーの状態を追跡

    init() {
        startTimer()
    }

    func startTimer() {
        // 既にタイマーが動いている場合は何もしない（二重初期化を防止）
        guard !isTimerRunning else {
            print("タイマーは既に実行中です")
            return
        }

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.currentTime = Date()  // 1秒ごとに現在時刻を更新
        }
        isTimerRunning = true
        print("タイマーを開始しました")
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
        print("タイマーを停止しました")
    }

    deinit {
        stopTimer()  // クラスが破棄されるときにタイマーを停止（メモリリーク防止）
        print("ClockViewModel が破棄されました")
    }
}
