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
        let data = DdayData.shared.ddayList[selectedIdx]
        if data.shouldAlarm {
            rightBarButton?.image = UIImage(systemName: "bell.slash.fill")
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(data.title) \(data.createDate)"])
        } else {
            rightBarButton?.image = UIImage(systemName: "bell.fill")
            addNewNotification(data)
        }
        DdayData.shared.ddayList[selectedIdx].shouldAlarm.toggle()
        DdayData.shared.saveData()
    }
    
    func addNewNotification(_ item: DateCountModel) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "D-day"
        notificationContent.body = item.title
        
        var date = Calendar.current.dateComponents([.year, .month, .day], from: item.date)
        date.hour = 0
        print(date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: "\(item.title) \(item.createDate)", content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
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
        let alert = UIAlertController(title: "알림", message: "디데이 데이터가 영구적으로 삭제됩니다!\n정말 삭제하시겠습니까?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .destructive) { action in
            self.performSegue(withIdentifier: "deleteFromDetail", sender: self)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func moveToHelpView(_ sender: UIButton) {
        guard let helpVC = UIStoryboard(name: "WidgetHelpViewController", bundle: nil).instantiateViewController(withIdentifier: "WidgetHelpViewController") as? WidgetHelpViewController else { return }
        
        self.present(helpVC, animated: true, completion: nil)
    }
}
