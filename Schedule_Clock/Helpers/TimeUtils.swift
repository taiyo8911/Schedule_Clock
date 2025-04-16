//
//  TimeUtils.swift
//  Schedule_Clock
//
//  Created by Taiyo KOSHIBA on 2025/01/30.
//


import Foundation

struct TimeUtils {
    // 指定フォーマットで時間を文字列として返すメソッド
    // 例: formatTime(Date(), format: "HH:mm") → "14:30"
    static func formatTime(_ date: Date, format: String) -> String {
        let formatter = DateFormatter() // 日付を文字列に変換するためのフォーマッターを作成
        formatter.locale = .current  // 現在の地域設定（ロケール）を適用
        formatter.timeZone = .current // 現在のタイムゾーンを適用
        formatter.dateFormat = format // フォーマットを設定
        return formatter.string(from: date) // フォーマットで日付を文字列に変換して返す
    }
}
