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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setDateFormatter() {
        df.locale = Locale(identifier: "ko_KR")
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ddayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ddayCell", for: indexPath) as! DDayCell
        cell.titleLabel.text = ddayList[indexPath.row].title
        cell.dateLabel.text = setDdayLabel(date: ddayList[indexPath.row].date, isDday: ddayList[indexPath.row].isDday)
        
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
            return "D-day"
        } else {
            return "D+\(diff)"
        }
    }
    
}
