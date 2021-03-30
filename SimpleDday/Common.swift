//
//  Common.swift
//  SimpleDday
//
//  Created by 서보경 on 2021/03/18.
//

import UIKit

struct DateCountModel: Codable {
    var date: Date
    var title: String
    var isDday: Bool // d-day or count date
    var shouldAlarm: Bool
    var bgImage: Data
    var bgColor: String
    
    func dataToImage() -> UIImage? {
        return UIImage(data: bgImage)
    }
}

extension UIViewController {
    func hideNavigationBarUnderline() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}

struct Theme {
    static let main = Theme()
    let colors: [String: UIColor] = [
        "orange": UIColor(cgColor: CGColor(red: 230/255, green: 168/255, blue: 105/255, alpha: 1)), // orange #E6A869
        "purple": UIColor(cgColor: CGColor(red: 180/255, green: 168/255, blue: 229/255, alpha: 1)), // purple #B4A8E5
        "blue": UIColor(cgColor: CGColor(red: 152/255, green: 178/255, blue: 218/255, alpha: 1)), // blue #98B2DA
        "pink": UIColor(cgColor: CGColor(red: 249/255, green: 157/255, blue: 201/255, alpha: 1)), // pink #F99DC9
        "green": UIColor(cgColor: CGColor(red: 134/255, green: 155/255, blue: 104/255, alpha: 1)), // green #869B68
        "yellow": UIColor(cgColor: CGColor(red: 242/255, green: 206/255, blue: 112/255, alpha: 1)), // yellow #F2CE70
        "red": UIColor(cgColor: CGColor(red: 203/255, green: 125/255, blue: 125/255, alpha: 1)), // red #CB7D7D
        "gray": UIColor(cgColor: CGColor(red: 183/255, green: 183/255, blue: 183/255, alpha: 1)), // gray #B7B7B7
        
    ]
}

struct DdayData {
    static var shared = DdayData()
    var ddayList: [DateCountModel] = []
    var ddayListLabels: [String] = []
    
    func saveData() {
        Storage.save(ddayList, at: "ddayList.json")
        UserDefaults.shared?.saveDataAtShared(ddayListLabels, at: "ddayListLabels")
    }
    
    mutating func loadListData() {
        ddayList = Storage.load(at: "ddayList.json", [DateCountModel].self) ?? []
    }
    
    mutating func loadLabelsData() {
        ddayListLabels = UserDefaults.shared?.loadDataFromShared(at: "ddayListLabels") ?? []
    }
}

struct DdayLabelManager {
    static func setDdayLabel(date: Date, isDday: Bool) -> String {
        let today = Date()
        let timeInterval = today.timeIntervalSince(date)
        let diff = Int(round(timeInterval/(60*60*24)))
        print(diff)
        
        if diff < 0 {
            return "D\(diff)"
        } else if diff == 0 {
            if isDday {
                return "D-day"
            } else {
                return "D+1"
            }
        } else {
            if isDday {
                return "D+\(diff)"
            } else {
                return "D+\(diff+1)"
            }
        }
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
