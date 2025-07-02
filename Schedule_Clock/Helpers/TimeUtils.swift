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
            case "HH:mm", "H:mm":
                formatter.timeStyle = .short
                return formatter.string(from: date)
            default:
                // 未知のフォーマットの場合は固定フォーマットにフォールバック
                formatter.dateFormat = format
                return formatter.string(from: date)
            }
        } else {
            // 指定されたフォーマットを直接使用（地域設定に依存しない）
            formatter.dateFormat = format
            return formatter.string(from: date)
        }
    }

    // 便利メソッド: 予定表示用の時刻フォーマット（先頭ゼロ処理付き）
    static func formatScheduleTime(_ date: Date) -> String {
        let timeString = formatTime(date, format: "HH:mm", localized: false)

        // 先頭が "0" の場合、EN SPACE に置き換える
        return timeString.hasPrefix("0") ? "\u{2002}" + timeString.dropFirst() : timeString
    }

    // 便利メソッド: デジタル時計用の時刻フォーマット
    static func formatDigitalClockTime(_ date: Date) -> String {
        return formatTime(date, format: "H:mm:ss", localized: false)
    }
}
