//
//  DetailDdayController.swift
//  SimpleDday
//
//  Created by 서보경 on 2021/04/16.
//

import UIKit

class DetailDdayController: UITableViewController {
    var selectedIdx: Int = 0
    lazy var item = DdayData.shared.ddayList[selectedIdx]
    
    var rightBarButton: UIBarButtonItem?
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemDate: UILabel!
    @IBOutlet weak var itemDday: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDetailData()
        setNavigationBar()
    }
    
    func setNavigationBar() {
        let buttonImage = item.shouldAlarm ? UIImage(systemName: "bell.fill") : UIImage(systemName: "bell.slash.fill")
        rightBarButton = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(changeAlarmSetting))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        self.navigationController?.navigationBar.tintColor = .gray
        
    }
    
    @objc func changeAlarmSetting() {
        print("change alarm setting")
    }
    
    func setDetailData() {
        if let image = item.dataToImage() {
            itemImageView.image = image
        } else {
            itemImageView.backgroundColor = Theme.main.colors[item.bgColor]
        }
        itemImageView.image = item.dataToImage()
        itemTitle.text = item.title
        
        let df = DateFormatter()
        df.dateFormat = "yyyy년 MM월 dd일"
        itemDate.text = df.string(from: item.date)
    }
    
    @IBAction func moveToModifyDataView(_ sender: UIButton) {
        print("move to modify view")
    }
    
    @IBAction func deleteData(_ sender: UIButton) {
        print("delete data")
    }
    
    @IBAction func moveToHelpView(_ sender: UIButton) {
        print("move to help view")
    }
}
