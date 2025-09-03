//
//  ScheduleViewModel.swift
//  Schedule_Clock
//
//  Created by Taiyo KOSHIBA on 2025/01/30.
//

import SwiftUI

// スケジュールを管理するクラス（予定の追加・削除・保存・読み込みを行う）
class ScheduleViewModel: ObservableObject {
    // スケジュールのリスト（アプリ全体で共有される）
    @Published var schedules: [ScheduleModel] = []

    // 予定の最大数指定
    @Published var maxScheduleCount: Int = 5

    // エラーメッセージとアラート表示の管理
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""

    // 保存するファイルの名前
    private let fileName = "schedules.json"

    // 初期化時に保存データを読み込む
    init() {
        loadSchedules()
    }

    // 予定の追加
    func addSchedule(title: String, startTime: Date) {
        // 予定が最大数に達していたら追加しない
        guard schedules.count < maxScheduleCount else {
            showUserAlert(
                title: NSLocalizedString("max_schedules_reached", comment: "予定の登録上限"),
                message: NSLocalizedString("schedule_limit_message", comment: "予定上限の詳細メッセージ")
            )
            return
        }

        // タイトルが空でないかチェック
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showUserAlert(
                title: NSLocalizedString("invalid_input", comment: "無効な入力"),
                message: NSLocalizedString("empty_title_message", comment: "タイトルが空の場合のメッセージ")
            )
            return
        }

        // 新しい予定を作成
        let newSchedule = ScheduleModel(title: title, startTime: startTime)
        // リストに追加
        schedules.append(newSchedule)
        // 予定を開始時間順に並び替え、保存
        sortAndSaveSchedules()
    }

    // 指定したインデックスの予定を削除
    func removeSchedule(at index: Int) {
        guard index >= 0 && index < schedules.count else {
            showUserAlert(
                title: NSLocalizedString("delete_error", comment: "削除エラー"),
                message: NSLocalizedString("invalid_schedule_index", comment: "無効なインデックス")
            )
            return
        }

        schedules.remove(at: index)
        saveSchedules() // 削除後にデータを保存
    }

    // 予定を時間順に並び替えて保存する
    private func sortAndSaveSchedules() {
        // 開始時間が早い順に並び替える
        schedules = schedules.sorted { $0.startTime < $1.startTime }
        saveSchedules()
    }

    // 予定をJSONファイルに保存する（改良版 - エラーハンドリング強化）
    func saveSchedules() {
        let encoder = JSONEncoder()  // JSONに変換するためのエンコーダー
        encoder.outputFormatting = .prettyPrinted // 見やすい形に整える

        do {
            let data = try encoder.encode(schedules)  // スケジュールをJSONデータに変換
            let url = getFileURL()  // 保存先のURLを取得
            try data.write(to: url)  // ファイルに書き込む

            // 成功時のログ（デバッグ用）
            print("スケジュールを正常に保存しました: \(schedules.count)件")

        } catch {
            // 保存エラーをユーザーに通知
            let errorMessage = String(format: NSLocalizedString("save_error_message", comment: "保存エラーメッセージ"), error.localizedDescription)

            showUserAlert(
                title: NSLocalizedString("save_error", comment: "保存エラー"),
                message: errorMessage
            )

            // 開発者用の詳細ログ
            print("保存エラー詳細: \(error)")
        }
    }

    // 保存された予定を読み込む（改良版 - エラーハンドリング強化）
    func loadSchedules() {
        let url = getFileURL()  // 読み込むファイルのURLを取得

        // ファイルが存在しない場合は何もしない（初回起動時など）
        guard FileManager.default.fileExists(atPath: url.path) else {
            print("保存ファイルが見つかりません。新規作成します。")
            return
        }

        do {
            let data = try Data(contentsOf: url)  // ファイルからデータを取得
            let decodedSchedules = try JSONDecoder().decode([ScheduleModel].self, from: data) // JSONをスケジュールデータに変換
            self.schedules = decodedSchedules.sorted { $0.startTime < $1.startTime } // 取得したデータを時間順に並び替える

            // 成功時のログ（デバッグ用）
            print("スケジュールを正常に読み込みました: \(schedules.count)件")

        } catch {
            // 読み込みエラーをユーザーに通知
            let errorMessage = String(format: NSLocalizedString("load_error_message", comment: "読み込みエラーメッセージ"), error.localizedDescription)

            showUserAlert(
                title: NSLocalizedString("load_error", comment: "読み込みエラー"),
                message: errorMessage
            )

            // 開発者用の詳細ログ
            print("読み込みエラー詳細: \(error)")

            // エラー時は空の配列で初期化（アプリがクラッシュしないように）
            self.schedules = []
        }
    }

    // ユーザーにアラートを表示するためのヘルパーメソッド
    private func showUserAlert(title: String, message: String) {
        DispatchQueue.main.async {
            self.alertTitle = title
            self.alertMessage = message
            self.showAlert = true
        }
    }

    // スケジュールの保存先となるファイルのURLを取得する
    private func getFileURL() -> URL {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! // アプリの保存フォルダを取得
        return directory.appendingPathComponent(fileName) // そこにファイル名を追加してURLを作成
    }
}
