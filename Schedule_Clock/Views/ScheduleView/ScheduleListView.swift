//
//  ScheduleListView.swift
//  Schedule_Clock
//
//  Created by Taiyo KOSHIBA on 2025/01/30.
//

import SwiftUI

struct ScheduleListView: View {
    @EnvironmentObject var scheduleViewModel: ScheduleViewModel
    var rowHeight: CGFloat = 60   // 1行の高さ（呼び出し側で画面サイズに応じて指定）
    var fontSize: CGFloat = 20    // 表示フォントサイズ

    var body: some View {
        List {
            ForEach(scheduleViewModel.schedules) { schedule in
                HStack {
                    Text(schedule.formattedStartTime)
                        .font(.system(size: fontSize, weight: .semibold, design: .monospaced))
                        .foregroundColor(.gray)
                        .padding(.trailing)

                    Text(schedule.title)
                        .font(.system(size: fontSize, weight: .semibold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: rowHeight)
                .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
            }
            .onDelete(perform: deleteSchedule)

            // FAB用のスペーサーをリストの最後に追加
            Color.clear
                .frame(height: 80)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .onAppear {
            scheduleViewModel.loadSchedules()
        }
    }

    private func deleteSchedule(at offsets: IndexSet) {
        let indices = Array(offsets).sorted(by: >)
        for index in indices {
            scheduleViewModel.removeSchedule(at: index)
        }
    }
}

struct ScheduleListView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleListView()
            .environmentObject(ScheduleViewModel())
    }
}
