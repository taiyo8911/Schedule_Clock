//
//  DigitalClockView.swift
//  Schedule_Clock
//
//  Created by Taiyo KOSHIBA on 2025/01/26.
//

import SwiftUI

struct DigitalClockView: View {
    @EnvironmentObject var clockViewModel: ClockViewModel  // アプリ全体で共有する時計データ
    var fontSize: CGFloat = 40  // 表示フォントサイズ（呼び出し側でlayoutModeに応じて指定）

    var body: some View {
        Text(timeString)
            .font(.system(size: fontSize, weight: .bold, design: .monospaced))
            .foregroundColor(.white)
    }

    // 現在の時間をフォーマットして文字列として取得
    private var timeString: String {
        TimeUtils.formatDigitalClockTime(clockViewModel.currentTime)
    }
}

#Preview {
    DigitalClockView()
        .environmentObject(ClockViewModel())
        .background(Color.black)
}
