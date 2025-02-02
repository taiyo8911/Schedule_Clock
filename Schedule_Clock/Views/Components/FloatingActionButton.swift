//
//  FloatingActionButton.swift
//  Schedule_Clock
//
//  Created by Taiyo KOSHIBA on 2025/01/30.
//


import SwiftUI

// 予定を追加するためのフローティングアクションボタン（FAB）
struct FloatingActionButton: View {
    // スケジュールのデータを管理するViewModelを取得（アプリ全体で共有される）
    @EnvironmentObject var scheduleViewModel: ScheduleViewModel

    // 「追加画面を表示するかどうか」を管理する変数
    @Binding var isAddScheduleViewPresented: Bool

    var body: some View {
        // 予定の数が最大数未満の場合にFABを表示
        if scheduleViewModel.schedules.count < scheduleViewModel.maxScheduleCount {
            Button(action: {
                // ボタンが押されたら、追加画面を表示する（フラグを切り替え）
                isAddScheduleViewPresented.toggle()
            }) {
                // ボタンの見た目（＋アイコン）
                Image(systemName: "plus.circle.fill")
                    .resizable() // サイズ変更可能にする
                    .scaledToFit() // 縦横比を維持したまま拡大・縮小
                    .frame(width: 60, height: 60) // アイコンの大きさ
                    .foregroundColor(.white) // アイコンの色
                    .background(Color.blue) // 背景色
                    .clipShape(Circle()) // 円形にする
                    .shadow(radius: 10) // 影をつけて立体的にする
            }
            .padding(.bottom, 30) // 画面下から30ptの位置に配置
            .padding(.trailing, 20) // 画面右端から20ptの位置に配置
        }
    }
}


struct FloatingActionButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingActionButton(isAddScheduleViewPresented: .constant(false)) // プレビュー用に固定値を設定
            .environmentObject(ScheduleViewModel()) // 仮のデータを適用
    }
}

