//
//  DetailDdayController.swift
//  SimpleDday
//
//  Created by 서보경 on 2021/04/16.
//

import UIKit

enum Mode {
    case add, edit
}

class DetailDdayController: UITableViewController {
    var selectedIdx: Int = 0
    lazy var item = DdayData.shared.ddayList[selectedIdx]
    
    var rightBarButton: UIBarButtonItem?
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var alarmButton: UIButton!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemDate: UILabel!
    @IBOutlet weak var itemDday: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDetailData()
    }
    
    func setNavigationBar() {
        let buttonImage = item.shouldAlarm ? UIImage(systemName: "bell.fill") : UIImage(systemName: "bell.slash.fill")
        alarmButton.setBackgroundImage(buttonImage, for: .normal)
        rightBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editDdayData))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        self.navigationController?.navigationBar.tintColor = .label
        
    }
    
    @objc func editDdayData() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let modify = UIAlertAction(title: "디데이 수정", style: .default) { (action) in
            guard let modifyVC = UIStoryboard(name: "AddDdayViewController", bundle: nil).instantiateViewController(withIdentifier: "NavVC") as? UINavigationController else { return }
            guard let root = modifyVC.viewControllers[0] as? AddDdayViewController else { return }
            root.editMode = .edit
            root.newData = DdayData.shared.ddayList[self.selectedIdx]
            root.selectedIdx = self.selectedIdx
            
            self.present(modifyVC, animated: true, completion: nil)
        }
        
        let delete = UIAlertAction(title: "디데이 삭제", style: .destructive) { (action) in
            let alert = UIAlertController(title: "알림", message: "디데이 데이터가 영구적으로 삭제됩니다!\n정말 삭제하시겠습니까?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .destructive) { action in
                self.performSegue(withIdentifier: "deleteFromDetail", sender: self)
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            
            alert.addAction(cancel)
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(modify)
        alert.addAction(delete)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func changeAlarmSetting(_ sender: UIButton) {
        let data = DdayData.shared.ddayList[selectedIdx]
        if data.shouldAlarm {
            alarmButton.setBackgroundImage(UIImage(systemName: "bell.slash.fill"), for: .normal)
            NotificationManager.removeNotification(data)
        } else {
            alarmButton.setBackgroundImage(UIImage(systemName: "bell.fill"), for: .normal)
            NotificationManager.addNewNotification(data)
        }
        DdayData.shared.ddayList[selectedIdx].shouldAlarm.toggle()
        DdayData.shared.saveData()
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
        itemDday.text = DdayLabelManager.setDdayLabel(date: item.date, isDday: item.isDday, needDetail: true)
    }
    
    @IBAction func moveToHelpView(_ sender: UIButton) {
        guard let helpVC = UIStoryboard(name: "WidgetHelpViewController", bundle: nil).instantiateViewController(withIdentifier: "HelpNavigationVIewController") as? UINavigationController else { return }
        
        self.present(helpVC, animated: true, completion: nil)
    }
    
    @IBAction func unwindToDetailViewFromModify(sender: UIStoryboardSegue) {
        let vc = sender.source as! AddDdayViewController
        DdayData.shared.ddayList[selectedIdx] = vc.newData
        DdayData.shared.ddayListLabels[selectedIdx] = "\(vc.newData.title) \(vc.newData.createDate)"
        DdayData.shared.saveData()
        // 변경된 데이터가 바로 상세 화면에 반영되지 않음
    }
}
