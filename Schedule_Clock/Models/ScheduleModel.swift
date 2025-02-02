//
//  ScheduleModel.swift
//  Schedule_Clock
//
//  Created by Taiyo KOSHIBA on 2025/01/30.
//

import Foundation

// Identifiable を適用 → データをリスト表示する際に便利になる仕組み
// Codable → データを保存したり読み込んだりしやすくするための仕組み

// 予定を表すデータの型（設計図）
struct ScheduleModel: Identifiable, Codable {
    // 予定ごとに異なるIDを作る（他の予定と区別するため）
    var id: UUID = UUID()
    
    // 予定のタイトル
    var title: String

    // 予定の開始時間（日時情報）
    var startTime: Date

    // 開始時間を「H:mm」（例: "9:30"）の形式で表示するための変数
    var formattedStartTime: String {
        TimeUtils.formatTime(startTime, format: "H:mm")
    }
}
