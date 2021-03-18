//
//  AddDdayViewController.swift
//  SimpleDday
//
//  Created by 서보경 on 2021/03/18.
//

import UIKit

class AddDdayViewController: UITableViewController {
    
    let df = DateFormatter()
    var newData: DateCountModel = DateCountModel(date: Date(), title: "None", isDday: true, shouldAlarm: false)

    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var ddayBtn: UIButton!
    @IBOutlet weak var dateCountBtn: UIButton!
    
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var ddayDatePicker: UIDatePicker!
    
    @IBOutlet weak var pushNotiSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDateFormatter()
        setButtonUI()
    }
    
    func setDateFormatter() {
        df.dateFormat = "yyyy년 MM월 dd일"
//        df.locale = Locale(identifier: "ko_KR")
        
        selectedDateLabel.text = df.string(from: Date())
    }
    func setButtonUI() {
        ddayBtn.setTitleColor(.systemIndigo, for: .normal)
        dateCountBtn.setTitleColor(.systemGray, for: .normal)
    }
    @IBAction func selectDate(_ sender: UIDatePicker) {
        selectedDateLabel.text = df.string(from: ddayDatePicker.date)
    }
    
    @IBAction func selectDday(_ sender: UIButton) {
        ddayBtn.setTitleColor(.systemIndigo, for: .normal)
        dateCountBtn.setTitleColor(.systemGray, for: .normal)
        
        newData.isDday = true
    }
    
    @IBAction func selectDateCount(_ sender: UIButton) {
        ddayBtn.setTitleColor(.systemGray, for: .normal)
        dateCountBtn.setTitleColor(.systemIndigo, for: .normal)
        
        newData.isDday = false
    }
    
    @IBAction func dismissVC(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addDday(_ sender: UIBarButtonItem) {
        if let title = titleTextField.text {
            newData.title = title
        }
        newData.date = ddayDatePicker.date
        newData.shouldAlarm = pushNotiSwitch.isOn
        
        self.performSegue(withIdentifier: "toMain", sender: self)
    }
}
