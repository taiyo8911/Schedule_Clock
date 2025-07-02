//
//  MainView.swift
//  Schedule_Clock
//
//  Created by Taiyo KOSHIBA on 2025/01/26.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var scheduleViewModel: ScheduleViewModel
    @State private var isAddScheduleViewPresented = false

    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height

            ZStack {
                // 背景グラデーション
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                if isLandscape {
                    landscapeLayout()
                } else {
                    portraitLayout()
                }

                // フローティングアクションボタン
                // フローティングアクションボタン（画面下中央）
                VStack {
                    Spacer()
                    FloatingActionButton(isAddScheduleViewPresented: $isAddScheduleViewPresented)
                }
            }
            .sheet(isPresented: $isAddScheduleViewPresented) {
                AddScheduleView(isAddScheduleViewPresented: $isAddScheduleViewPresented)
            }
        }
    }

    // 横向きレイアウト
    private func landscapeLayout() -> some View {
        HStack(spacing: 20) {
            // 時計セクション
            clockSectionCard()
                .frame(maxWidth: .infinity)

            // 予定セクション
            scheduleSectionCard()
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }

    // 縦向きレイアウト
    private func portraitLayout() -> some View {
        VStack(spacing: 20) {
            // 時計セクション
            clockSectionCard()
                .frame(maxHeight: .infinity, alignment: .center)

            // 予定セクション
            scheduleSectionCard()
                .frame(maxHeight: .infinity)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }

    // 時計セクションをカード形式で表示
    private func clockSectionCard() -> some View {
        VStack(spacing: 15) {
            AnalogClockView()
                .frame(maxHeight: 250)

            DigitalClockView()
        }
    }

    // 予定セクションをカード形式で表示
    private func scheduleSectionCard() -> some View {
        VStack(spacing: 0) {
            // ヘッダー
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.blue)
                    .font(.title2)

                Text("今日の予定")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Spacer()

                // 予定数表示
                Text("\(scheduleViewModel.schedules.count)/\(scheduleViewModel.maxScheduleCount)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .dynamicTypeSize(...DynamicTypeSize.xxxLarge)


            Divider()

            // 予定コンテンツ
            if scheduleViewModel.schedules.isEmpty {
                emptyScheduleView()
            } else {
                ScheduleListView()
                    .background(Color.white)
            }

            // 最大予定数メッセージ
            if scheduleViewModel.schedules.count >= scheduleViewModel.maxScheduleCount {
                maxScheduleReachedMessage()
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .clipped()
    }

    // 予定がない場合の表示
    private func emptyScheduleView() -> some View {
        VStack(spacing: 20) {
            Spacer()

            VStack(spacing: 8) {
                Text(NSLocalizedString("no_schedules", comment: "予定がない場合に表示するメッセージ"))
                    .font(.headline)
                    .foregroundColor(.primary)

                Text("ボタンから予定を追加できます")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)

    }

    // 最大予定数メッセージ
    private func maxScheduleReachedMessage() -> some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)

            Text(NSLocalizedString("max_schedules_reached", comment: "予定の登録上限で表示するメッセージ"))
                .font(.caption)
                .foregroundColor(.orange)

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.orange.opacity(0.1))
        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // 縦向きプレビュー
            MainView()
                .environmentObject(ScheduleViewModel())
                .previewDisplayName("Portrait")

            // 横向きプレビュー
            MainView()
                .environmentObject(ScheduleViewModel())
                .previewInterfaceOrientation(.landscapeLeft)
                .previewDisplayName("Landscape")
        }
    }
}
