//
//  Theme.swift
//  SimpleDday
//
//  Created by 서보경 on 2021/04/27.
//

import UIKit

// MARK:- Main Colors
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
        "lemon": UIColor(cgColor: CGColor(red: 249/255, green: 242/255, blue: 170/255, alpha: 1)), // lemon #F9F2AA
        "soda": UIColor(cgColor: CGColor(red: 108/255, green: 205/255, blue: 205/255, alpha: 1)), // soda #6CCDCD
        
    ]
}

// MARK:- Navigation UI
extension UIViewController {
    func hideNavigationBarUnderline() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}

// MARK:- DdayLabel Design
struct DdayLabelManager {
    static func setDdayLabel(date: Date, isDday: Bool, needDetail: Bool = false) -> String {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let today = Calendar.current.date(from: dateComponents) ?? Date()
        let timeInterval = today.timeIntervalSince(date)
        let diff = Int(round(timeInterval/(60*60*24)))
        
        if diff < 0 {
            return needDetail ? "\(abs(diff))일 남았습니다.😲" : "D\(diff)"
        } else if diff == 0 {
            if isDday {
                return "D-day🎉"
            } else {
                return needDetail ? "오늘부터 1일!😘" : "D+1"
            }
        } else {
            if isDday {
                return needDetail ? "\(diff)일 지났습니다.😪" : "D+\(diff)"
            } else {
                return needDetail ? "시작일로부터 \(diff+1)일째 입니다.😍" : "D+\(diff+1)"
            }
        }
    }
}
