//
//  MainView.swift
//  Schedule_Clock
//
//  Created by Taiyo KOSHIBA on 2025/01/26.
//


import SwiftUI

struct MainView: View {
    @EnvironmentObject var scheduleViewModel: ScheduleViewModel  // ScheduleViewModelからスケジュールデータを取得
    @State private var isAddScheduleViewPresented = false  // 新規スケジュール追加画面を表示するフラグ

    var body: some View {
        // GeometryReaderを使って画面のサイズを取得して画面の向きを判定
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height  // 横向き（ランドスケープ）か縦向き（ポートレート）かを判定

            Group {
                if isLandscape {
                    // 横向きの場合はHStackで時計とスケジュールを横に並べる
                    HStack {
                        clockSection()  // 時計表示部分
                            .frame(maxWidth: .infinity, maxHeight: .infinity)  // 幅と高さを最大に
                        
                        scheduleSection()  // 予定表示部分
                            .frame(maxWidth: .infinity, maxHeight: .infinity)  // 幅と高さを最大に
                    }
                } else {
                    // 縦向きの場合はVStackで時計とスケジュールを縦に並べる
                    VStack {
                        clockSection()  // 時計表示部分
                        scheduleSection()  // 予定表示部分
                    }
                }
            }
            .overlay(
                // フローティングアクションボタン（FAB）を配置
                FloatingActionButton(isAddScheduleViewPresented: $isAddScheduleViewPresented),
                alignment: .bottomTrailing  // 右下に配置
            )
            .sheet(isPresented: $isAddScheduleViewPresented) {
                // FABをタップした時に新規スケジュール追加画面を表示
                AddScheduleView(isAddScheduleViewPresented: $isAddScheduleViewPresented)
            }
        }
    }

    // 時計の表示部分（アナログとデジタル時計）
    private func clockSection() -> some View {
        VStack {
            AnalogClockView()  // アナログ時計表示
            DigitalClockView()  // デジタル時計表示
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)  // 幅と高さを最大に
    }

    // 予定の表示部分
    private func scheduleSection() -> some View {
        VStack {
            // 予定が無い場合
            if scheduleViewModel.schedules.isEmpty {
                VStack {
                    Text("予定はありません")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()  // 空のスペースを入れて表示位置を調整
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)  // 幅と高さを最大に
            // 予定がある場合
            } else {
                ScheduleListView()
            }
            
            // 予定数が最大値に達している場合にメッセージを表示
            if scheduleViewModel.schedules.count >= scheduleViewModel.maxScheduleCount {
                Text("予定はこれ以上作成できません")
                    .font(.subheadline)
                    .foregroundColor(.red)
                    .padding(.bottom, 60)  // 画面下部に配置
                    .frame(maxWidth: .infinity, alignment: .center)  // 幅を最大にして中央揃え
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)  // 幅と高さを最大に
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(ScheduleViewModel())  // ScheduleViewModelを環境オブジェクトとして提供
    }
}
