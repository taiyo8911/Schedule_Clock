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

    // 適切な画面サイズクラスの取得
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    var body: some View {
        ZStack {
            // 背景グラデーション
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // 適応的レイアウト
            adaptiveLayout()

            // フローティングアクションボタン（画面下中央）
            VStack {
                Spacer()
                FloatingActionButton(isAddScheduleViewPresented: $isAddScheduleViewPresented)
            }
        }
        .sheet(isPresented: $isAddScheduleViewPresented) {
            AddScheduleView(isAddScheduleViewPresented: $isAddScheduleViewPresented)
        }
        .alert(scheduleViewModel.alertTitle, isPresented: $scheduleViewModel.showAlert) {
            Button("OK") {
                scheduleViewModel.showAlert = false
            }
        } message: {
            Text(scheduleViewModel.alertMessage)
        }
    }

    // 画面サイズに応じた適応的レイアウト
    @ViewBuilder
    private func adaptiveLayout() -> some View {
        switch layoutMode {
        case .compact:
            // iPhone縦向き、小さいiPad
            compactLayout()
        case .regular:
            // iPad、iPhone横向き（Plus/Max）
            regularLayout()
        case .large:
            // 大きいiPad
            largeLayout()
        }
    }

    // レイアウトモードの判定
    private var layoutMode: LayoutMode {
        switch (horizontalSizeClass, verticalSizeClass) {
        case (.regular, .regular):
            // iPad縦向き・横向き
            return .large
        case (.regular, .compact):
            // iPhone横向き（Plus/Max）、iPad横向き（一部）
            return .regular
        case (.compact, .regular):
            // iPhone縦向き
            return .compact
        case (.compact, .compact):
            // iPhone横向き（標準サイズ）
            return .regular
        default:
            return .compact
        }
    }

    // コンパクトレイアウト（iPhone縦向き）
    private func compactLayout() -> some View {
        VStack(spacing: 20) {
            // 時計セクション（小さめ）
            clockSectionCard()
                .frame(maxHeight: 300)

            // 予定セクション
            scheduleSectionCard()
                .frame(maxHeight: .infinity)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }

    // レギュラーレイアウト（iPhone横向き、中型iPad）
    private func regularLayout() -> some View {
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

    // ラージレイアウト（大きいiPad）
    private func largeLayout() -> some View {
        HStack(spacing: 30) {
            // 時計セクション（大きめ）
            clockSectionCard()
                .frame(maxWidth: .infinity, maxHeight: 400)

            // 予定セクション（大きめ）
            scheduleSectionCard()
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 20)
    }

    // 時計セクションをカード形式で表示
    private func clockSectionCard() -> some View {
        VStack(spacing: 15) {
            AnalogClockView()
                .frame(maxHeight: layoutMode == .large ? 300 : 250)

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

            // 予定コンテンツ（空状態とリスト表示を統合）
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

    // 予定がない場合の表示（改良版 - より適切な多言語対応）
    private func emptyScheduleView() -> some View {
        VStack(spacing: 20) {
            Spacer()

            VStack(spacing: 12) {
                // メインメッセージ（多言語対応）
                Text(NSLocalizedString("no_schedules", comment: "予定がない場合に表示するメッセージ"))
                    .font(.headline)
                    .foregroundColor(.primary)

                // サブメッセージ（多言語対応のために追加の文字列リソースを使用）
                Text(NSLocalizedString("add_schedule_hint", comment: "予定追加のヒントメッセージ"))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
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

// レイアウトモードの列挙型
enum LayoutMode {
    case compact    // iPhone縦向き
    case regular    // iPhone横向き（Plus/Max）
    case large      // iPad
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // iPhone縦向きプレビュー
            MainView()
                .environmentObject(ScheduleViewModel())
                .previewDevice("iPhone 14")
                .previewDisplayName("iPhone Portrait")

            // iPhone横向きプレビュー
            MainView()
                .environmentObject(ScheduleViewModel())
                .previewDevice("iPhone 14")
                .previewInterfaceOrientation(.landscapeLeft)
                .previewDisplayName("iPhone Landscape")
        }
    }
}
