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
        let data = loadModelFromConfig(for: configuration)
        let entry = DdayEntry(date: Date(), configuration: configuration, receivedData: data)
        entries.append(entry)
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
    
    func loadModelFromConfig(for configuration: ConfigurationIntent) -> DateCountModel? {
        guard let id = configuration.ddayItem?.identifier else {
            return nil
        }
        guard !DdayData.shared.ddayList.isEmpty else { return nil }
        return DdayData.shared.ddayList[Int(id) ?? 0]
    }
}

struct DdayEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    var receivedData: DateCountModel?
}

struct DdayWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        if let model = entry.receivedData {
            ZStack {
                if let colorName = model.bgColor {
                    Color(Theme.main.colors[colorName] ?? .systemBackground)
                }
                Image(uiImage: model.dataToImage() ?? UIImage())
                VStack {
                    Text(model.title)
                    Text(DdayLabelManager.setDdayLabel(date: model.date, isDday: model.isDday))
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
        } else {
            Text("길게 터치하여\n위젯 편집")
                .multilineTextAlignment(.center)
        }
    }
}

@main
struct DdayWidget: Widget {
    let kind: String = "DdayWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            DdayWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("dandi.")
        .description("위젯에 표시할 디데이를 선택해주세요.")
    }
}

struct DdayWidget_Previews: PreviewProvider {
    static var previews: some View {
        DdayWidgetEntryView(entry: DdayEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
