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
            // 背景色
            Color.black
                .ignoresSafeArea()

            // 適応的レイアウト
            GeometryReader { geometry in
                adaptiveLayout(isPortrait: geometry.size.height > geometry.size.width)
            }

            // フローティングアクションボタン（画面右下）
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FloatingActionButton(isAddScheduleViewPresented: $isAddScheduleViewPresented)
                        .padding(.trailing, 30)
                }
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
    private func adaptiveLayout(isPortrait: Bool) -> some View {
        switch layoutMode {
        case .compact:
            // iPhone縦向き、小さいiPad
            compactLayout()
        case .regular:
            // iPad、iPhone横向き（Plus/Max）
            regularLayout()
        case .large:
            // 大きいiPad
            if isPortrait {
                largePortraitLayout()  // iPad縦向き（縦並び）
            } else {
                largeLayout()          // iPad横向き（横並び）
            }
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
            // 時計セクション
            clockSectionCard(clockMaxHeight: 320, digitalFontSize: 50)
                .frame(maxHeight: 380)

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
            clockSectionCard(clockMaxHeight: 300, digitalFontSize: 48)
                .frame(maxWidth: .infinity)

            // 予定セクション
            scheduleSectionCard()
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }

    // ラージレイアウト（大きいiPad横向き）
    private func largeLayout() -> some View {
        HStack(spacing: 30) {
            // 時計セクション（大きめ）
            clockSectionCard(clockMaxHeight: 480, digitalFontSize: 88)
                .frame(maxWidth: .infinity, maxHeight: 580)

            // 予定セクション（大きめ）
            scheduleSectionCard()
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 20)
    }

    // ラージポートレイトレイアウト（大きいiPad縦向き）
    private func largePortraitLayout() -> some View {
        VStack(spacing: 30) {
            // 時計セクション（さらに大きめ）
            clockSectionCard(clockMaxHeight: 500, digitalFontSize: 88)
                .frame(maxWidth: .infinity, maxHeight: 600)

            // 予定セクション
            scheduleSectionCard()
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 20)
    }

    // 時計セクションをカード形式で表示
    private func clockSectionCard(clockMaxHeight: CGFloat = 250, digitalFontSize: CGFloat = 40) -> some View {
        VStack(spacing: 15) {
            AnalogClockView()
                .frame(maxHeight: clockMaxHeight)

            DigitalClockView(fontSize: digitalFontSize)
        }
    }

    // 予定セクションをカード形式で表示
    private func scheduleSectionCard() -> some View {
        GeometryReader { geometry in
            let headerHeight: CGFloat = 50
            let bottomSpacerHeight: CGFloat = 80
            let availableForRows = max(geometry.size.height - headerHeight - bottomSpacerHeight, 0)
            let rowHeight = availableForRows / CGFloat(scheduleViewModel.maxScheduleCount)
            let fontSize = max(rowHeight * 0.45, 14)  // 最小14ptは確保

            VStack(spacing: 0) {
                // ヘッダー（タイトル + 件数）
                scheduleSectionHeader(headerHeight: headerHeight, fontSize: fontSize)

                // 予定コンテンツ（空状態とリスト表示を統合）
                if scheduleViewModel.schedules.isEmpty {
                    emptyScheduleView()
                } else {
                    ScheduleListView(rowHeight: rowHeight, fontSize: fontSize)
                        .background(Color.white)
                }

                // 最大予定数メッセージ
                if scheduleViewModel.schedules.count >= scheduleViewModel.maxScheduleCount {
                    maxScheduleReachedMessage()
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color.white.opacity(0.95))
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            )
            .clipped()
        }
    }

    // 予定セクションのヘッダー（タイトルと件数表示）
    private func scheduleSectionHeader(headerHeight: CGFloat, fontSize: CGFloat) -> some View {
        HStack {
            Text(NSLocalizedString("today_schedules", comment: "予定セクションのタイトル"))
                .font(.system(size: fontSize, weight: .semibold))
                .foregroundColor(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.5)

            Spacer()

            Text("\(scheduleViewModel.schedules.count)/\(scheduleViewModel.maxScheduleCount)")
                .font(.system(size: fontSize * 0.85, design: .monospaced))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 20)
        .frame(height: headerHeight)
        .background(Color.white)
        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
    }

    // 予定がない場合の表示（改良版 - より適切な多言語対応）
    private func emptyScheduleView() -> some View {
        VStack(spacing: 20) {
            Spacer()

            VStack(spacing: 16) {
                Image(systemName: "calendar.badge.plus")
                    .font(.system(size: 64))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.secondary)

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
                .environmentObject(ClockViewModel())
                .previewDevice("iPhone 14")
                .previewDisplayName("iPhone Portrait")

            // iPhone横向きプレビュー
            MainView()
                .environmentObject(ScheduleViewModel())
                .environmentObject(ClockViewModel())
                .previewDevice("iPhone 14")
                .previewInterfaceOrientation(.landscapeLeft)
                .previewDisplayName("iPhone Landscape")
        }
    }
}
