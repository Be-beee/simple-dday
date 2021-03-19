//
//  AddDdayViewController.swift
//  SimpleDday
//
//  Created by 서보경 on 2021/03/18.
//

import UIKit

class AddDdayViewController: UITableViewController {
    
    let bgColor: [UIColor] = [.systemRed, .systemBlue, .systemPink, .systemTeal, .systemGreen, .systemOrange, .systemPurple, .systemIndigo, .systemYellow]
    
    let df = DateFormatter()
    var newData: DateCountModel = DateCountModel(date: Date(), title: "None", isDday: true, shouldAlarm: false)

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var ddayBtn: UIButton!
    @IBOutlet weak var dateCountBtn: UIButton!
    
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var ddayDatePicker: UIDatePicker!
    
    @IBOutlet weak var pushNotiSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        setDateFormatter()
        setButtonUI()
        setTapGestureAtImageView()
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
    func setTapGestureAtImageView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapEmptyImage))
        
        mainImageView.addGestureRecognizer(tap)
    }
    
    @objc func tapEmptyImage() {
        print("포토 라이브러리 접근")
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
        newData.bgColor = bgColor.randomElement()
        
        self.performSegue(withIdentifier: "toMain", sender: self)
    }
}
