//
//  Schedule_ClockApp.swift
//  Schedule_Clock
//
//  Created by Taiyo KOSHIBA on 2025/01/26.
//

import SwiftUI

@main
struct Schedule_ClockApp: App {
    @StateObject private var scheduleViewModel = ScheduleViewModel()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(scheduleViewModel)
        }
    }
}
