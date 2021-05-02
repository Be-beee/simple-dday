//
//  Common.swift
//  SimpleDday
//
//  Created by 서보경 on 2021/03/18.
//

import UIKit

// MARK:- Data Model & UserDefaults Extension
struct DateCountModel: Codable {
    var date: Date
    var title: String
    var isDday: Bool // d-day or count date
    var shouldAlarm: Bool
    var bgImage: Data
    var bgColor: String
    var createDate: Date
    
    func dataToImage() -> UIImage? {
        return UIImage(data: bgImage)
    }
}

struct DdayData {
    static var shared = DdayData()
    var ddayList: [DateCountModel] = []
    var ddayListLabels: [String] = []
    
    func saveData() {
        Storage.save(ddayList, at: "ddayList")
        UserDefaults.shared?.saveDataAtShared(ddayListLabels, at: "ddayListLabels")
    }
    
    mutating func loadListData() {
        ddayList = Storage.load(at: "ddayList", [DateCountModel].self) ?? []
    }
    
    mutating func loadLabelsData() {
        ddayListLabels = UserDefaults.shared?.loadDataFromShared(at: "ddayListLabels") ?? []
    }
}

extension UserDefaults {
    static var shared: UserDefaults? {
        let shared = UserDefaults(suiteName: "group.com.sbk.ddaycontainer")
        return shared
    }
    func saveDataAtShared(_ data: [String], at path: String) {
        UserDefaults.shared?.set(data, forKey: path)
        UserDefaults.shared?.synchronize()
    }
    
    func loadDataFromShared(at path: String) -> [String]? {
        let data = UserDefaults.shared?.stringArray(forKey: path)
        return data
    }
}

// MARK:- App Open count
struct LaunchingCount {
    static var main = LaunchingCount()
    
    mutating func setCount(_ num: Int?) {
        if let n = num {
            UserDefaults.standard.set(n, forKey: "launchCount")
        } else {
            UserDefaults.standard.set(2, forKey: "launchCount")
        }
    }
    
    func getCount() -> Int? {
        return UserDefaults.standard.value(forKey: "launchCount") as? Int
    }
}
