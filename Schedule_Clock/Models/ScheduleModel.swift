//
//  ScheduleModel.swift
//  Schedule_Clock
//
//  Created by Taiyo KOSHIBA on 2025/01/30.
//

import Foundation

// Identifiable を適用 → データをリスト表示する際に便利になる仕組み
// Codable → データの保存、読み込みに便利な仕組み

// 予定データの型（設計図）
struct ScheduleModel: Identifiable, Codable {
    // 予定のID
    var id: UUID = UUID()

    // 予定のタイトル
    var title: String

    // 予定の開始時間（日時情報）
    var startTime: Date

    // 開始時間を "H:mm" のように表示するための変数（例: "9:30"）
    // 専用の便利メソッドを使用して一貫したフォーマットを適用
    var formattedStartTime: String {
        return TimeUtils.formatScheduleTime(startTime)
    }
}
