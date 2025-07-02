# Schedule_Clock

時計機能と予定管理機能を組み合わせたiOS/iPadOSアプリです。アナログ時計とデジタル時計で現在時刻を表示し、シンプルな予定管理機能を提供します。

## 機能

### 🕐 時計機能
- **アナログ時計**: クラシックな針式時計で現在時刻を表示
- **デジタル時計**: 見やすいデジタル表示で時刻を確認
- **リアルタイム更新**: 1秒ごとに自動更新

### 📅 予定管理機能
- **予定の追加**: タイトルと開始時間を設定して予定を登録
- **予定の表示**: 時間順に並んだ見やすい予定リスト
- **予定の削除**: スワイプ操作で簡単に削除
- **制限機能**: 最大5件までの予定登録（制限数は調整可能）

### 🌐 多言語対応
以下の言語に対応しています：
- 日本語 (ja)
- 英語 (en)
- 中国語簡体字 (zh-Hans)
- 中国語繁体字 (zh-Hant)
- スペイン語 (es)

### 📱 レスポンシブデザイン
- **iPhone縦向き**: コンパクトな縦並びレイアウト
- **iPhone横向き**: 時計と予定を横並びで表示
- **iPad**: 大画面を活用した最適化レイアウト

## 技術仕様

### 開発環境
- **プラットフォーム**: iOS/iPadOS
- **開発言語**: Swift
- **フレームワーク**: SwiftUI
- **アーキテクチャ**: MVVM (Model-View-ViewModel)

### 主要コンポーネント

#### Models
- `ScheduleModel`: 予定データの構造を定義

#### ViewModels
- `ScheduleViewModel`: 予定の管理ロジック（追加・削除・保存・読み込み）
- `ClockViewModel`: 時計の時刻管理

#### Views
- `MainView`: メイン画面（適応的レイアウト）
- `AnalogClockView`: アナログ時計コンポーネント
- `DigitalClockView`: デジタル時計コンポーネント
- `ScheduleListView`: 予定リスト表示
- `AddScheduleView`: 予定追加画面
- `FloatingActionButton`: 予定追加用のFABボタン

#### Helpers
- `TimeUtils`: 時刻フォーマット用のユーティリティクラス

### データ永続化
- **保存形式**: JSON
- **保存場所**: アプリのDocumentsディレクトリ
- **自動保存**: 予定の追加・削除時に自動的に保存


## 使用方法

### 予定の追加
1. 画面右下の青い「+」ボタンをタップ
2. 予定のタイトルを入力
3. 開始時間を設定
4. 「保存」ボタンをタップ

### 予定の削除
1. 予定リストで削除したい項目を左にスワイプ
2. 表示される「削除」ボタンをタップ

### 画面レイアウト
- **iPhone縦向き**: 上部に時計、下部に予定リスト
- **iPhone横向き・iPad**: 左側に時計、右側に予定リスト

## カスタマイズ

### 言語の追加
1. 新しい `.lproj` フォルダを作成
2. `Localizable.strings` ファイルを追加
3. 必要な文字列を翻訳


## プロジェクト構成

```
Schedule_Clock/
├── Models/
│   └── ScheduleModel.swift          # 予定データモデル
├── ViewModels/
│   ├── ScheduleViewModel.swift      # 予定管理ロジック
│   └── ClockViewModel.swift         # 時計管理ロジック
├── Views/
│   ├── MainView.swift               # メイン画面
│   ├── ClockView/
│   │   ├── AnalogClockView.swift    # アナログ時計
│   │   └── DigitalClockView.swift   # デジタル時計
│   ├── ScheduleView/
│   │   ├── ScheduleListView.swift   # 予定リスト
│   │   └── AddScheduleView.swift    # 予定追加画面
│   └── Components/
│       └── FloatingActionButton.swift # FABボタン
├── Helpers/
│   └── TimeUtils.swift              # 時刻ユーティリティ
├── Assets.xcassets/                 # アプリアイコンなど
└── *.lproj/                         # 多言語リソース
    └── Localizable.strings
```
