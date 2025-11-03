//
//  ScheduleListView.swift
//  Schedule_Clock
//
//  Created by Taiyo KOSHIBA on 2025/01/30.
//

import SwiftUI

struct ScheduleListView: View {
    @EnvironmentObject var scheduleViewModel: ScheduleViewModel

    var body: some View {
        List {
            ForEach(scheduleViewModel.schedules) { schedule in
                HStack {
                    Text(schedule.formattedStartTime)
                        .font(.headline)
                        .foregroundColor(.gray)
                        .font(.system(size: 20).monospaced())
                        .padding(.trailing)

                    Text(schedule.title)
                        .font(.headline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
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
