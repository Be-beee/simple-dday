//
//  ViewController.swift
//  SimpleDday
//
//  Created by 서보경 on 2021/03/18.
//

import UIKit
import WidgetKit
import UserNotifications

class MainViewController: UIViewController {
    
    let df = DateFormatter()

    @IBOutlet weak var ddayListView: UITableView!
    @IBOutlet weak var emptyCoverView: UIView!
    @IBOutlet weak var floatingBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFloatingBtn()
        hideNavigationBarUnderline()
        ddayListView.register(UINib(nibName: "DdayListCell", bundle: nil), forCellReuseIdentifier: "DdayListCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshListView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.ddayListView.visibleCells.count > 0, let count = LaunchingCount.main.getCount(), count > 0 {
            let cell = self.ddayListView.visibleCells[0] as! DdayListCell
            cell.animateSwipeHint()
            LaunchingCount.main.setCount(count-1)
        } else if LaunchingCount.main.getCount() == nil {
            LaunchingCount.main.setCount(nil)
        }
    }
    
    func setFloatingBtn() {
//        let color1 = UIColor(named: "lemon") ?? .systemBackground
        let color2 = UIColor(named: "soda") ?? .systemBackground
        
//        floatingBtn.setGradient(color1: color1, color2: color2)
        floatingBtn.backgroundColor = color2
        floatingBtn.layer.cornerRadius = floatingBtn.bounds.size.width / 2
//        floatingBtn.setSystemImage(systemName: "plus")
        floatingBtn.setBackgroundShadow()
    }
    
    func setDateFormatter() {
        df.locale = Locale(identifier: "ko_KR")
    }
    
    func refreshListView() {
        ddayListView.reloadData()
        if DdayData.shared.ddayList.isEmpty {
            emptyCoverView.isHidden = false
        } else {
            emptyCoverView.isHidden = true
        }
    }
    
    @IBAction func unwindToMain(sender: UIStoryboardSegue) {
        let vc = sender.source as! AddDdayViewController
        DdayData.shared.ddayListLabels.append("\(vc.newData.title)|\(vc.newData.createDate)")
        DdayData.shared.ddayList.append(vc.newData)
        DdayData.shared.saveData()
        refreshListView()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    @IBAction func deleteFromDetailView(sender: UIStoryboardSegue) {
        let vc = sender.source as! DetailDdayController
        let item = DdayData.shared.ddayList[vc.selectedIdx]
        DdayData.shared.ddayListLabels.remove(at: vc.selectedIdx)
        DdayData.shared.ddayList.remove(at: vc.selectedIdx)
        if item.shouldAlarm {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(item.title) \(item.createDate)"])
        }
        DdayData.shared.saveData()
        self.refreshListView()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    @IBAction func addDday(_ sender: UIButton) {
        if DdayData.shared.ddayList.count > 30 {
            let alert = UIAlertController(title: "알림", message: "디데이는 최대 30개 등록 가능합니다.😢\n(추후 업데이트 예정)", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
        } else {
            let addDdayVC = UIStoryboard(name: "AddDdayViewController", bundle: nil).instantiateViewController(withIdentifier: "NavVC") as! UINavigationController
            self.present(addDdayVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func syncSharedData(_ sender: UIBarButtonItem) {
        WidgetCenter.shared.reloadAllTimelines()
        refreshListView()
        showToastMessage(message: "위젯 데이터를 동기화했습니다.")
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DdayData.shared.ddayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DdayListCell", for: indexPath) as! DdayListCell
        
        let cellItem = DdayData.shared.ddayList[indexPath.row]
        cell.ddayTitle.text = cellItem.title
        cell.ddayDate.text = DdayLabelManager.setDdayLabel(date: cellItem.date, isDday: cellItem.isDday)
        
        let colorName = cellItem.bgColor
        cell.ddayImage.backgroundColor = UIColor(named: colorName)
        
        let imgData = cellItem.bgImage
        cell.ddayImage.image = UIImage(data: imgData)
        
        if cellItem.shouldAlarm {
            cell.alarmImageView.image = UIImage(systemName: "bell.fill")
        } else {
            cell.alarmImageView.image = UIImage(systemName: "bell.slash.fill")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section != 0 { return nil }
        
        let delete = UIContextualAction(style: .normal, title: "삭제") { (action, view, nil) in
            let item = DdayData.shared.ddayList[indexPath.row]
            DdayData.shared.ddayListLabels.remove(at: indexPath.row)
            DdayData.shared.ddayList.remove(at: indexPath.row)
            if item.shouldAlarm {
                NotificationManager.removeNotification(item)
            }
            DdayData.shared.saveData()
            self.refreshListView()
            
        }
        delete.backgroundColor = .systemRed
        
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailDdayVC = UIStoryboard(name: "DetailDdayController", bundle: nil).instantiateViewController(withIdentifier: "DetailDdayController") as? DetailDdayController else { return }
        detailDdayVC.selectedIdx = indexPath.row
        
        self.navigationController?.pushViewController(detailDdayVC, animated: true)
    }
    
}

// MARK:- Floating Button Setting
extension UIButton {
//    func setGradient(color1: UIColor, color2: UIColor) {
//        let gradient: CAGradientLayer = CAGradientLayer()
//        gradient.colors = [color1.cgColor, color2.cgColor]
//        gradient.locations = [0.0, 1.0]
//        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
//        gradient.frame = bounds
//        gradient.setCornerRadius()
//
//
//        layer.addSublayer(gradient)
//    }
    func setSystemImage(systemName: String) {
        let bgLayer = CALayer()
        let maskImageLayer = CALayer()
        maskImageLayer.frame = layer.bounds
        maskImageLayer.contents = UIImage(systemName: systemName)?.cgImage
        maskImageLayer.transform = CATransform3DMakeScale(0.4, 0.4, 1)
        
        bgLayer.mask = maskImageLayer
        bgLayer.backgroundColor = UIColor.white.cgColor
        
        bgLayer.frame = layer.bounds
        bgLayer.setCornerRadius()
        
        layer.addSublayer(bgLayer)
    }
    func setBackgroundShadow() {
        layer.shadowColor = UIColor.systemGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 2, height: 2)
    }
}

extension CALayer {
    func setCornerRadius() {
        cornerRadius = bounds.size.width/2
    }
}
