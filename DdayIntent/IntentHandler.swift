//
//  IntentHandler.swift
//  DdayIntent
//
//  Created by 서보경 on 2021/03/23.
//

import Intents

class IntentHandler: INExtension, ConfigurationIntentHandling {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
    func provideDdayItemOptionsCollection(for intent: ConfigurationIntent, with completion: @escaping (INObjectCollection<DateCount>?, Error?) -> Void) {
        var items: [DateCount] = []
        DdayData.shared.loadLabelsData()
        for idx in DdayData.shared.ddayListLabels.indices {
            let data = DdayData.shared.ddayListLabels[idx]
            let newData = DateCount(identifier: "\(idx)", display: data)
            items.append(newData)
        }
        
        completion(INObjectCollection(items: items), nil)
    }
    
}
