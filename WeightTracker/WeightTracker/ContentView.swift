import SwiftUI
import CoreData
import Charts
import UserNotifications

struct ContentView: View {
    let persistenceController = PersistenceController.shared

    var body: some View {
        TabView {
            ForEach(Person.allCases) { person in
                PersonWeightView(person: person)
                    .tabItem {
                        Label(person.displayName, systemImage: person == .me ? "person.fill" : "heart.fill")
                            .foregroundColor(person.color)
                    }
            }
        }
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}

struct PersonWeightView: View {
    let person: Person

    @Environment(\.managedObjectContext) private var viewContext

    private var weights: [Weight] {
        let request = NSFetchRequest<Weight>(entityName: "Weight")
        request.predicate = NSPredicate(format: "person == %@", person.rawValue)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Error fetching weights: \(error)")
            return []
        }
    }

    @State private var selectedDate: Date = Date()
    @State private var weightText: String = ""
    @State private var remindersEnabled: Bool = false
    @State private var averageDays: Int = 7
    @State private var yScaleMin: Double = 50.0
    @State private var yScaleMax: Double = 80.0
    @State private var yScaleMinText: String = "50.0"
    @State private var yScaleMaxText: String = "80.0"

    private let notif = NotificationManager()

    @FocusState private var isWeightFieldFocused: Bool
    @FocusState private var isYScaleMinFocused: Bool
    @FocusState private var isYScaleMaxFocused: Bool

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // 标题
                    HStack {
                        Text(person.displayName + "的体重记录")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                    }

                    // 表单区域
                    formArea

                    // 图表区域
                    chartArea

                    // 统计区域
                    statsArea

                    // 记录列表
                    listArea
                }
                .padding()
            }
            .navigationTitle("体重追踪")
            .onAppear { checkNotificationStatus() }
            .onTapGesture {
                isWeightFieldFocused = false
                isYScaleMinFocused = false
                isYScaleMaxFocused = false
            }
        }
    }

    private var formArea: some View {
        GroupBox(label: Label("添加记录", systemImage: "plus.circle")) {
            HStack(spacing: 12) {
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .labelsHidden()
                    .frame(maxWidth: 160)

                TextField("体重 (kg)", text: $weightText)
                    .keyboardType(.decimalPad)
                    .focused($isWeightFieldFocused)
                    .frame(maxWidth: 120)

                Button("保存") { saveEntry() }
                    .buttonStyle(.borderedProminent)
            }
        }
    }

    private var chartArea: some View {
        GroupBox(label: Label("体重曲线", systemImage: "chart.line.uptrend.xyaxis")) {
            if weights.isEmpty {
                Text("暂无数据")
                    .frame(maxWidth: .infinity, minHeight: 200)
                    .foregroundColor(.secondary)
            } else {
                VStack(spacing: 8) {
                    Chart {
                        ForEach(weights) { w in
                            LineMark(x: .value("日期", w.date), y: .value("体重", w.weight))
                                .foregroundStyle(person.color)
                            PointMark(x: .value("日期", w.date), y: .value("体重", w.weight))
                                .foregroundStyle(person.color)
                        }
                    }
                    .chartYScale(domain: yScaleMin...yScaleMax)
                    .chartXAxis {
                        AxisMarks(values: .automatic(desiredCount: 6)) { _ in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel(format: .dateTime.month().day())
                        }
                    }
                    .chartYAxis {
                        AxisMarks(values: .stride(by: calculateStride())) { _ in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel()
                        }
                    }
                    .frame(height: 240)

                    // 手动输入纵坐标范围
                    HStack(spacing: 12) {
                        Text("纵坐标范围:")
                            .font(.caption)

                        TextField("最小", text: $yScaleMinText)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 60)
                            .focused($isYScaleMinFocused)

                        Text("-")
                            .font(.caption)

                        TextField("最大", text: $yScaleMaxText)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 60)
                            .focused($isYScaleMaxFocused)

                        Text("kg")
                            .font(.caption)

                        Spacer()

                        Button(action: {
                            applyYScaleRange()
                            isYScaleMinFocused = false
                            isYScaleMaxFocused = false
                        }) {
                            Text("应用")
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(6)
                        }

                        Button(action: {
                            resetZoom()
                            isYScaleMinFocused = false
                            isYScaleMaxFocused = false
                        }) {
                            Text("重置")
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(6)
                        }
                    }
                }
            }
        }
    }

    private var statsArea: some View {
        GroupBox(label: Label("统计数据", systemImage: "chart.bar.doc.horizontal")) {
            VStack(alignment: .leading, spacing: 12) {
                // 平均天数选择
                HStack {
                    Text("平均天数：")
                    Spacer()
                    Picker("选择天数", selection: $averageDays) {
                        ForEach([3, 4, 5, 6, 7, 10, 14, 30], id: \.self) { days in
                            Text("\(days)天").tag(days)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 100)
                }

                Divider()

                // 统计数据
                HStack { Text("最新体重："); Spacer(); Text(latestWeightText()) }
                HStack { Text("\(averageDays)天平均："); Spacer(); Text(movingAverageText(window: averageDays)) }
                HStack { Text("最高体重："); Spacer(); Text(highestWeightText()) }
                HStack { Text("最低体重："); Spacer(); Text(lowestWeightText()) }

                Divider()

                // 提醒开关
                Toggle("每日提醒（22:00）", isOn: $remindersEnabled)
                    .onChange(of: remindersEnabled) { new in
                        if new { requestAndSchedule() } else { notif.cancelDaily() }
                    }
            }
            .padding(.vertical, 6)
        }
    }

    private var listArea: some View {
        GroupBox(label: Label("历史记录", systemImage: "list.bullet")) {
            List {
                ForEach(weights) { w in
                    HStack {
                        Text(w.date, style: .date)
                        Spacer()
                        Text(String(format: "%.2f kg", w.weight))
                            .foregroundColor(.secondary)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedDate = w.date
                        weightText = String(format: "%.2f", w.weight)
                    }
                }
                .onDelete(perform: delete)
                .listRowBackground(Color.clear)
            }
            .frame(height: weights.isEmpty ? 100 : 240)
        }
    }

    // MARK: - Data operations

    private func saveEntry() {
        guard let w = Double(weightText) else { return }
        let cal = Calendar.current
        let dayStart = cal.startOfDay(for: selectedDate)

        let req = NSFetchRequest<Weight>(entityName: "Weight")
        req.predicate = NSPredicate(format: "date >= %@ AND date < %@ AND person = %@",
                                   dayStart as NSDate,
                                   cal.date(byAdding: .day, value: 1, to: dayStart)! as NSDate,
                                   person.rawValue)
        req.fetchLimit = 1

        do {
            let res = try viewContext.fetch(req)
            if let existing = res.first {
                existing.weight = w
            } else {
                let newW = Weight(context: viewContext)
                newW.date = dayStart
                newW.weight = w
                newW.person = person.rawValue
            }
            try viewContext.save()
            weightText = ""
            isWeightFieldFocused = false
        } catch {
            print(error)
        }
    }

    private func delete(offsets: IndexSet) {
        offsets.map { weights[$0] }.forEach(viewContext.delete)
        do { try viewContext.save() } catch { print(error) }
    }

    // MARK: - Statistics

    private func latestWeightText() -> String {
        guard let last = weights.last else { return "—" }
        return String(format: "%.2f kg", last.weight)
    }

    private func highestWeightText() -> String {
        guard let highest = weights.max(by: { $0.weight < $1.weight }) else { return "—" }
        return String(format: "%.2f kg", highest.weight)
    }

    private func lowestWeightText() -> String {
        guard let lowest = weights.min(by: { $0.weight < $1.weight }) else { return "—" }
        return String(format: "%.2f kg", lowest.weight)
    }

    private func movingAverage(window: Int) -> [(Date, Double)] {
        let arr = weights.map { ($0.date, $0.weight) }
        guard !arr.isEmpty else { return [] }
        var res: [(Date, Double)] = []
        for i in 0..<arr.count {
            let start = max(0, i - window + 1)
            let slice = arr[start...i]
            let avg = slice.map { $0.1 }.reduce(0, +) / Double(slice.count)
            res.append((arr[i].0, avg))
        }
        return res
    }

    private func movingAverageText(window: Int) -> String {
        let ma = movingAverage(window: window)
        guard let last = ma.last else { return "—" }
        return String(format: "%.3f kg", last.1)
    }

    // MARK: - Zoom

    private func calculateStride() -> Double {
        let range = yScaleMax - yScaleMin
        if range <= 5 {
            return 1
        } else if range <= 10 {
            return 2
        } else if range <= 20 {
            return 5
        } else {
            return 10
        }
    }

    private func applyYScaleRange() {
        guard let minVal = Double(yScaleMinText),
              let maxVal = Double(yScaleMaxText) else {
            return
        }

        // 验证输入的范围
        if minVal >= 0 && maxVal <= 100 && minVal < maxVal && (maxVal - minVal) >= 2 {
            // 计算数据的实际范围
            guard let dataMin = weights.map({ $0.weight }).min(),
                  let dataMax = weights.map({ $0.weight }).max() else {
                return
            }

            // 自动调整范围，确保包含所有数据点
            // 添加 5% 的 padding 来确保曲线不会正好在边界上
            let padding = (maxVal - minVal) * 0.05
            let adjustedMin = min(minVal, dataMin - padding)
            let adjustedMax = max(maxVal, dataMax + padding)

            yScaleMin = adjustedMin
            yScaleMax = adjustedMax

            // 更新文本显示
            yScaleMinText = String(format: "%.1f", adjustedMin)
            yScaleMaxText = String(format: "%.1f", adjustedMax)
        }
    }

    private func resetZoom() {
        yScaleMin = 50.0
        yScaleMax = 80.0
        yScaleMinText = "50.0"
        yScaleMaxText = "80.0"
    }

    // MARK: - Notifications

    private func requestAndSchedule() {
        notif.requestAuthorization { granted in
            DispatchQueue.main.async {
                if granted {
                    notif.scheduleDaily(hour: 9, minute: 0)
                } else {
                    remindersEnabled = false
                }
            }
        }
    }

    private func checkNotificationStatus() {
        notif.getAuthorizationStatus { granted in
            DispatchQueue.main.async { remindersEnabled = granted }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

