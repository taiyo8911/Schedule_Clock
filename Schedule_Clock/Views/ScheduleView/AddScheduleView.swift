//
//  AddScheduleView.swift
//  Schedule_Clock
//
//  Created by Taiyo KOSHIBA on 2025/01/30.
//


import SwiftUI


struct AddScheduleView: View {
    @Binding var isAddScheduleViewPresented: Bool  // 親ビューから渡されたデータを受け取る（双方向データバインディング）
    @State private var title = ""  // 予定のタイトルを保持する変数
    @State private var selectedStartTime = Date()  // 開始時間を保持するState変数
    
    @EnvironmentObject var scheduleViewModel: ScheduleViewModel  // スケジュールを管理するViewModelを取得
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("予定を入力", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                DatePicker("開始時間", selection: $selectedStartTime, displayedComponents: [.hourAndMinute])
                    .padding()
                
                Button(action: {
                    // ボタンが押されたら
                    // 入力されたタイトルと開始時間で新しい予定を追加
                    scheduleViewModel.addSchedule(title: title, startTime: selectedStartTime)
                    
                    // 入力フィールドをクリア
                    title = ""
                    
                    // シートを閉じる（予定追加画面を閉じる）
                    isAddScheduleViewPresented = false
                }) {
                    // ボタンのラベル
                    Text("保存")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)  // ボタンを横幅いっぱいに広げる
                        .padding()
                        .background(Color.blue)  // 背景色
                        .foregroundColor(.white)  // 文字色
                        .cornerRadius(10)  // 角丸
                }
                .padding()
            }
            .navigationTitle("新規予定追加")  // ナビゲーションバーのタイトル
            .padding()
        }
    }
}


struct AddScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        AddScheduleView(isAddScheduleViewPresented: .constant(true))  // シートが開いている状態でプレビュー
            .environmentObject(ScheduleViewModel())  // ダミーのViewModelを適用
    }
}
