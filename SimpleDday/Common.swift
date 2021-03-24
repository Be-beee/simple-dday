//
//  Common.swift
//  SimpleDday
//
//  Created by 서보경 on 2021/03/18.
//

import UIKit

struct DateCountModel {
    var date: Date
    var title: String
    var isDday: Bool // d-day or count date
    var shouldAlarm: Bool
    var bgImage: UIImage?
    var bgColor: UIColor?
}

extension UIViewController {
    func hideNavigationBarUnderline() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}

struct Theme {
    static let main = Theme()
    let colors: [UIColor] = [
        UIColor(cgColor: CGColor(red: 230/255, green: 168/255, blue: 105/255, alpha: 1)), // orange #E6A869
        UIColor(cgColor: CGColor(red: 180/255, green: 168/255, blue: 229/255, alpha: 1)), // purple #B4A8E5
        UIColor(cgColor: CGColor(red: 152/255, green: 178/255, blue: 218/255, alpha: 1)), // blue #98B2DA
        UIColor(cgColor: CGColor(red: 249/255, green: 157/255, blue: 201/255, alpha: 1)), // pink #F99DC9
        UIColor(cgColor: CGColor(red: 134/255, green: 155/255, blue: 104/255, alpha: 1)), // green #869B68
        UIColor(cgColor: CGColor(red: 242/255, green: 206/255, blue: 112/255, alpha: 1)), // yellow #F2CE70
        UIColor(cgColor: CGColor(red: 203/255, green: 125/255, blue: 125/255, alpha: 1)), // red #CB7D7D
        UIColor(cgColor: CGColor(red: 183/255, green: 183/255, blue: 183/255, alpha: 1)), // gray #B7B7B7
        
    ]
}

struct DdayData {
    static var shared = DdayData()
    var ddayList: [DateCountModel] = [
        DateCountModel(date: Date(), title: "iOS 공부 시작", isDday: false, shouldAlarm: false, bgImage: nil, bgColor: Theme.main.colors[0]),
        DateCountModel(date: Date(), title: "프로젝트 테스트", isDday: true, shouldAlarm: false, bgImage: nil, bgColor: Theme.main.colors[1])
        // test data
    ]
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
