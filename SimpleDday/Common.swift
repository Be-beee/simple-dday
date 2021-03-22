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
    var memo: String?
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
