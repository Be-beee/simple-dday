//
//  ViewController.swift
//  SimpleDday
//
//  Created by 서보경 on 2021/03/18.
//

import UIKit

class MainViewController: UIViewController {
    
    let df = DateFormatter()

//    var ddayList:[DateCountModel] = []
    @IBOutlet weak var ddayListView: UITableView!
    @IBOutlet weak var emptyCoverView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBarUnderline()
        ddayListView.register(UINib(nibName: "DdayListCell", bundle: nil), forCellReuseIdentifier: "DdayListCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshListView()
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
        print("add data")
        let vc = sender.source as! AddDdayViewController
        DdayData.shared.ddayList.append(vc.newData)
        ddayListView.reloadData()
    }
    
    @IBAction func addDday(_ sender: UIBarButtonItem) {
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
        cell.ddayImage.backgroundColor = DdayData.shared.ddayList[indexPath.row].bgColor
        cell.ddayImage.image = DdayData.shared.ddayList[indexPath.row].bgImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DdayData.shared.ddayList.remove(at: indexPath.row)
            refreshListView()
        default:
            break
        }
    }
    
}
