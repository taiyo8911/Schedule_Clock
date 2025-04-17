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
    // ただし、フォーマット自体は "HH:mm" で行い、先頭のゼロを削除する形にする
    var formattedStartTime: String {
        // 指定された時刻 (startTime) を "HH:mm" 形式でフォーマット
        let timeString = TimeUtils.formatTime(startTime, format: "HH:mm")
        
        // もし時刻の先頭が "0"（例: "01:00"）なら、"0" を EN SPACE（\u{2002}）に置き換える
        // EN SPACE は半角スペースより少し広く、フォントによるズレを抑える
        return timeString.hasPrefix("0") ? "\u{2002}" + timeString.dropFirst() : timeString
    }
}
