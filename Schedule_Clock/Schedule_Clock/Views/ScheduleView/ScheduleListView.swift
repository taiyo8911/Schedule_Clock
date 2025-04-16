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
        VStack {
            // 予定が無い場合に表示するメッセージ
            if scheduleViewModel.schedules.isEmpty {
                Text("予定はありません")
                    .font(.headline)
                    .foregroundColor(.gray)
            } else {
                // 予定リストの表示
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
                    }
                    // 予定をスワイプで削除する
                    .onDelete(perform: deleteSchedule)
                }
                // 画面にリストが表示された時に予定を読み込む
                .onAppear {
                    scheduleViewModel.loadSchedules()
                }
                .listStyle(PlainListStyle())
                .frame(maxHeight: 230)
            }
        }
    }
    
    // 予定をスワイプで削除するための関数
    private func deleteSchedule(at offsets: IndexSet) {
        // インデックスに基づいて指定された予定を削除
        scheduleViewModel.schedules.remove(atOffsets: offsets)
        
        // 削除後にスケジュールを保存
        scheduleViewModel.saveSchedules()
    }
}


struct ScheduleListView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleListView()
            .environmentObject(ScheduleViewModel())
    }
}
