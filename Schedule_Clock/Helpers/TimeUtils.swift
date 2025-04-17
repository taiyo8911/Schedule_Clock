//
//  TimeUtils.swift
//  Schedule_Clock
//
//  Created by Taiyo KOSHIBA on 2025/01/30.
//


import Foundation

struct TimeUtils {
    // 指定フォーマットで時間を文字列として返すメソッド
    // 例: formatTime(Date(), format: "HH:mm", localized: false) → "14:30"
    static func formatTime(_ date: Date, format: String, localized: Bool = true) -> String {
        let formatter = DateFormatter() // 日付を文字列に変換するためのフォーマッターを作成
        formatter.locale = .current // 現在の地域設定（ロケール）を適用
        formatter.timeZone = .current // 現在のタイムゾーンを適用

        if localized {
            // 地域に合わせた日付スタイルを使用
            switch format {
            case "H:mm:ss":
                formatter.timeStyle = .medium
                return formatter.string(from: date)
            case "HH:mm":
                formatter.timeStyle = .short
                return formatter.string(from: date)
            default:
                formatter.dateFormat = format
                return formatter.string(from: date)
            }
        } else {
            // 指定されたフォーマットを直接使用
            formatter.dateFormat = format
            return formatter.string(from: date)
        }
    }
}
