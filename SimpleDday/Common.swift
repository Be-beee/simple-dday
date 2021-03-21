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
