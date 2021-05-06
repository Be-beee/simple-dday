//
//  DdayWidget.swift
//  DdayWidget
//
//  Created by 서보경 on 2021/03/23.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> DdayEntry {
        DdayEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (DdayEntry) -> ()) {
        let entry = DdayEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [DdayEntry] = []
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let currentDate = Calendar.current.date(from: dateComponents) ?? Date()
        for offset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: offset, to: currentDate)!
            let entry = DdayEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct DdayEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct DdayWidgetEntryView : View {
    @Environment(\.widgetFamily) private var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        if let model = loadModelFromConfig(for: entry.configuration) {
            switch widgetFamily {
            case .systemSmall:
                SmallDdayWidget(model: model)
            default:
                MediumDdayWidget(model: model)
            }
        } else {
            Text("길게 탭하여\n위젯 편집")
                .multilineTextAlignment(.center)
        }
    }
    
    func loadModelFromConfig(for configuration: ConfigurationIntent) -> DateCountModel? {
        DdayData.shared.loadListData()
//        DdayData.shared.loadLabelsData()
        guard let id = configuration.ddayItem?.identifier else {
            return nil
        }
        guard !DdayData.shared.ddayList.isEmpty else { return nil }
        
        for item in DdayData.shared.ddayList {
            let key = "\(item.title)|\(item.createDate)"
            if key == id {
                return item
            }
        }
        return nil
    }
}

// MARK:- System Small Widget

struct SmallDdayWidget: View {
    var model: DateCountModel
    
    var body: some View {
        ZStack {
            if let colorName = model.bgColor {
                Color(Theme.main.colors[colorName] ?? .systemBackground)
            }
            Image(uiImage: model.dataToImage() ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fill)
            VStack {
                Text(model.title)
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                Text(DdayLabelManager.setDdayLabel(date: model.date, isDday: model.isDday))
                    .foregroundColor(.white)
                    .font(.title)
            }
        }
    }
}

// MARK:- System Medium Widget

struct MediumDdayWidget: View {
    var model: DateCountModel
    
    var body: some View {
        ZStack {
            if let colorName = model.bgColor {
                Color(Theme.main.colors[colorName] ?? .systemBackground)
            }
            Image(uiImage: model.dataToImage() ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fill)
            HStack {
                Text(model.title)
                    .frame(width: UIScreen.main.bounds.width/3, height: 100, alignment: .topLeading)
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .padding(.leading, 20)
                Text(DdayLabelManager.setDdayLabel(date: model.date, isDday: model.isDday))
                    .frame(width: UIScreen.main.bounds.width/3, height: 100, alignment: .bottomTrailing)
                    .foregroundColor(.white)
                    .font(.title)
                    .padding()
            }
        }
    }
}

// MARK:- Setting Widget Data
@main
struct DdayWidget: Widget {
    let kind: String = "DdayWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            DdayWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("dandi.")
        .description("위젯에 선택된 디데이를 표시할 수 있습니다.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct DdayWidget_Previews: PreviewProvider {
    static var previews: some View {
        DdayWidgetEntryView(entry: DdayEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
