//
//  ViewController.swift
//  SimpleDday
//
//  Created by 서보경 on 2021/03/18.
//

import UIKit

class MainViewController: UIViewController {
    
    let df = DateFormatter()

    var ddayList:[DateCountModel] = []
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
        if ddayList.isEmpty {
            emptyCoverView.isHidden = false
        } else {
            emptyCoverView.isHidden = true
        }
    }
    
    @IBAction func unwindToMain(sender: UIStoryboardSegue) {
        print("add data")
        let vc = sender.source as! AddDdayViewController
        ddayList.append(vc.newData)
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
        return ddayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DdayListCell", for: indexPath) as! DdayListCell
        
        cell.ddayTitle.text = ddayList[indexPath.row].title
        cell.ddayDate.text = setDdayLabel(date: ddayList[indexPath.row].date, isDday: ddayList[indexPath.row].isDday)
        cell.ddayImage.backgroundColor = ddayList[indexPath.row].bgColor
        cell.ddayImage.image = ddayList[indexPath.row].bgImage
        
        return cell
    }
    
    func setDdayLabel(date: Date, isDday: Bool) -> String {
        let today = Date()
        let timeInterval = today.timeIntervalSince(date)
        let diff = Int(round(timeInterval/(60*60*24)))
        print(diff)
        
        if diff < 0 {
            return "D\(diff)"
        } else if diff == 0 {
            if isDday {
                return "D-day"
            } else {
                return "D+1"
            }
        } else {
            if isDday {
                return "D+\(diff)"
            } else {
                return "D+\(diff+1)"
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            ddayList.remove(at: indexPath.row)
            refreshListView()
        default:
            break
        }
    }
    
}
