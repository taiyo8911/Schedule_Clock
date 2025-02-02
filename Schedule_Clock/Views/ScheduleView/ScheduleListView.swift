//
//  ScheduleListView.swift
//  Schedule_Clock
//
//  Created by Taiyo KOSHIBA on 2025/01/30.
//

import SwiftUI

//struct ScheduleListView: View {
//    @EnvironmentObject var scheduleViewModel: ScheduleViewModel
//    
//    var body: some View {
//        VStack {
//            // 予定が無い場合の表示
//            if scheduleViewModel.schedules.isEmpty {
//                Text("予定はありません")
//                    .font(.headline)
//                    .foregroundColor(.gray)
//            } else {
//                // 予定リストの表示
//                List {
//                    ForEach(scheduleViewModel.schedules) { schedule in
//                        HStack {
//                            Text(schedule.formattedStartTime)
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                                .padding(.leading)
//                            
//                            Text(schedule.title)
//                                .font(.headline)
//                        }
//                    }
//                    .onDelete(perform: deleteSchedule)  // スワイプで削除するアクション
//                }
//                .onAppear {
//                    scheduleViewModel.loadSchedules()  // リスト表示前に予定を読み込む
//                }
//            }
//        }
//    }
//    
//    // スワイプで削除する関数
//    private func deleteSchedule(at offsets: IndexSet) {
//        // 指定されたインデックスを削除
//        scheduleViewModel.schedules.remove(atOffsets: offsets)
//        
//        // 削除後に保存
//        scheduleViewModel.saveSchedules()
//    }
//}
//
//struct ScheduleListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleListView()
//            .environmentObject(ScheduleViewModel())
//    }
//}


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
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            // 予定のタイトル
                            Text(schedule.title)
                                .font(.headline)
                                .padding(.leading)
                        }
                    }
                    // 予定をスワイプで削除する
                    .onDelete(perform: deleteSchedule)
                }
                // 画面にリストが表示された時に予定を読み込む
                .onAppear {
                    scheduleViewModel.loadSchedules()
                }
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
            .environmentObject(ScheduleViewModel())  // プレビュー用にScheduleViewModelを環境オブジェクトとして渡す
    }
}
