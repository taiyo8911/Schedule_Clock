//
//  ScheduleListView.swift
//  Schedule_Clock
//
//  Created by Taiyo KOSHIBA on 2025/01/30.
//

import SwiftUI

struct ScheduleListView: View {
    @EnvironmentObject var scheduleViewModel: ScheduleViewModel  // スケジュールのデータを取得

    var body: some View {
        // 予定リストの表示（空状態の処理は MainView で行う）
        List {
            // 予定を1つずつ表示
            ForEach(scheduleViewModel.schedules) { schedule in
                HStack {
                    // 予定の開始時間
                    Text(schedule.formattedStartTime)
                        .font(.headline)
                        .foregroundColor(.gray)
                        .font(.system(size: 20).monospaced())
                        .padding(.trailing)

                    // 予定のタイトル
                    Text(schedule.title)
                        .font(.headline)
                        .lineLimit(1)  // 1行に制限
                        .minimumScaleFactor(0.5)  // 長い文字はサイズ縮小
                }
                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
            }
            // 予定をスワイプで削除する
            .onDelete(perform: deleteSchedule)
        }
        // 画面にリストが表示された時に予定を読み込む
        .onAppear {
            scheduleViewModel.loadSchedules()
        }
    }

    // 予定をスワイプで削除するための関数（修正版）
    private func deleteSchedule(at offsets: IndexSet) {
        // ViewModelの removeSchedule メソッドを使用して適切に削除
        // IndexSet を配列に変換し、逆順で削除（インデックスのずれを防ぐため）
        let indices = Array(offsets).sorted(by: >)

        for index in indices {
            scheduleViewModel.removeSchedule(at: index)
        }

        // 注意: ViewModelの removeSchedule メソッド内で既に saveSchedules() が呼ばれているため、
        // ここで再度呼ぶ必要はありません
    }
}

struct ScheduleListView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleListView()
            .environmentObject(ScheduleViewModel())
    }
}
