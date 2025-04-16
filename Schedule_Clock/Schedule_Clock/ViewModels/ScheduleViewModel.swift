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

    // 予定の最大数指定（これ以上は追加できない）
    @Published var maxScheduleCount: Int = 10

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
            print("スケジュールは\(maxScheduleCount)つまでです")
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
        schedules.remove(at: index)
        saveSchedules() // 削除後にデータを保存
    }

    // 予定を時間順に並び替えて保存する
    private func sortAndSaveSchedules() {
        // 開始時間が早い順に並び替える
        schedules = schedules.sorted { $0.startTime < $1.startTime }
        saveSchedules()
    }

    // 予定をJSONファイルに保存する
    func saveSchedules() {
        let encoder = JSONEncoder()  // JSONに変換するためのエンコーダー
        encoder.outputFormatting = .prettyPrinted // 見やすい形に整える
        do {
            let data = try encoder.encode(schedules)  // スケジュールをJSONデータに変換
            let url = getFileURL()  // 保存先のURLを取得
            try data.write(to: url)  // ファイルに書き込む
        } catch {
            print("保存エラー: \(error)")
        }
    }

    // 保存された予定を読み込む
    func loadSchedules() {
        let url = getFileURL()  // 読み込むファイルのURLを取得
        do {
            let data = try Data(contentsOf: url)  // ファイルからデータを取得
            let decodedSchedules = try JSONDecoder().decode([ScheduleModel].self, from: data) // JSONをスケジュールデータに変換
            self.schedules = decodedSchedules.sorted { $0.startTime < $1.startTime } // 取得したデータを時間順に並び替える
        } catch {
            print("読み込みエラー: \(error)")
        }
    }

    // スケジュールの保存先となるファイルのURLを取得する
    private func getFileURL() -> URL {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! // アプリの保存フォルダを取得
        return directory.appendingPathComponent(fileName) // そこにファイル名を追加してURLを作成
    }
}
