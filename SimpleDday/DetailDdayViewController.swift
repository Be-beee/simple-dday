//
//  DetailDdayViewController.swift
//  SimpleDday
//
//  Created by 서보경 on 2021/03/21.
//

import UIKit

class DetailDdayViewController: UITableViewController {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var ddayTitle: UILabel!
    @IBOutlet weak var ddayDate: UILabel!
    @IBOutlet weak var pushNotiSwitch: UISwitch!
    @IBOutlet weak var ddayMemo: UILabel!
    
    var selectedData = DateCountModel(date: Date(), title: "", isDday: false, shouldAlarm: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBarUnderline()
        setContents()
    }
    
    func setContents() {
        mainImage.image = selectedData.bgImage
        mainImage.backgroundColor = selectedData.bgColor
        ddayTitle.text = selectedData.title
        ddayDate.text = setDdayLabel(date: selectedData.date, isDday: selectedData.isDday)
        ddayMemo.text = selectedData.memo ?? "작성된 메모가 없습니다."
        
        pushNotiSwitch.isOn = selectedData.shouldAlarm
    }
    
    func setDdayLabel(date: Date, isDday: Bool) -> String {
        let today = Date()
        let timeInterval = today.timeIntervalSince(date)
        let diff = Int(round(timeInterval/(60*60*24)))
        print(diff)
        
        if diff < 0 {
            return "D\(diff)"
        } else if diff == 0 {
            return "D-day"
        } else {
            return "D+\(diff)"
        }
    }
    
    @IBAction func changeNotiInfo(_ sender: UISwitch) {
        // shouldAlarm 값 변경
    }
}
