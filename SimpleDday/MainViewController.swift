//
//  ViewController.swift
//  SimpleDday
//
//  Created by 서보경 on 2021/03/18.
//

import UIKit
import WidgetKit

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
        DdayData.shared.loadListData()
        DdayData.shared.loadLabelsData()
        refreshListView()
    }
    
    func setFloatingBtn() {
        let color1 = Theme.main.colors["lemon"] ?? .systemBackground
        let color2 = Theme.main.colors["soda"] ?? .systemBackground
        
        floatingBtn.setGradient(color1: color1, color2: color2)
        floatingBtn.setSystemImage(systemName: "plus")
        floatingBtn.setBackgroundShadow()
    }
    
    func setDateFormatter() {
        df.locale = Locale(identifier: "ko_KR")
    }
    
    func refreshListView() {
//        WidgetCenter.shared.reloadAllTimelines()
        ddayListView.reloadData()
        if DdayData.shared.ddayList.isEmpty {
            emptyCoverView.isHidden = false
        } else {
            emptyCoverView.isHidden = true
        }
    }
    
    @IBAction func unwindToMain(sender: UIStoryboardSegue) {
        print("add data")
        let vc = sender.source as! AddDdayViewController
        DdayData.shared.ddayListLabels.append(vc.newData.title)
        DdayData.shared.ddayList.append(vc.newData)
        DdayData.shared.saveData()
        refreshListView()
    }
    
    @IBAction func addDday(_ sender: UIButton) {
        let addDdayVC = UIStoryboard(name: "AddDdayViewController", bundle: nil).instantiateViewController(withIdentifier: "NavVC") as! UINavigationController
        self.present(addDdayVC, animated: true, completion: nil)
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
        
        cell.ddayTitle.text = DdayData.shared.ddayList[indexPath.row].title
        cell.ddayDate.text = DdayLabelManager.setDdayLabel(date: DdayData.shared.ddayList[indexPath.row].date, isDday: DdayData.shared.ddayList[indexPath.row].isDday)
        
        let colorName = DdayData.shared.ddayList[indexPath.row].bgColor
        cell.ddayImage.backgroundColor = Theme.main.colors[colorName]
        
        let imgData = DdayData.shared.ddayList[indexPath.row].bgImage
        cell.ddayImage.image = UIImage(data: imgData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DdayData.shared.ddayListLabels.remove(at: indexPath.row)
            DdayData.shared.ddayList.remove(at: indexPath.row)
            DdayData.shared.saveData()
            refreshListView()
        default:
            break
        }
    }
    
}

// MARK:- Floating Button Setting
extension UIButton {
    func setGradient(color1: UIColor, color2: UIColor) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = bounds
        gradient.setCornerRadius()
        
        
        layer.addSublayer(gradient)
    }
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
