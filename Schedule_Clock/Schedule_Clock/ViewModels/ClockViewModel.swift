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

    init() {
        startTimer()
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.currentTime = Date()  // 1秒ごとに現在時刻を更新
        }
    }

    deinit {
        timer?.invalidate()  // クラスが破棄されるときにタイマーを停止（メモリリーク防止）
    }
}
