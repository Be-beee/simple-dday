//
//  WidgetHelpViewController.swift
//  SimpleDday
//
//  Created by 서보경 on 2021/04/18.
//

import UIKit

class WidgetHelpViewController: UIViewController {

    @IBOutlet weak var helpTableView: UITableView!
    let helpData: [(imgName: String, content: String)] = [
        (imgName: "help_1", content: "1. 화면 편집 상태에서 + 버튼을 통해 dandi. 위젯을 추가합니다."),
        (imgName: "help_2", content: "2. 원하는 크기의 위젯을 선택해 위젯을 추가해주세요."),
        (imgName: "help_3", content: "3. 추가한 위젯을 길게 탭한 후 위젯 편집을 탭해주세요."),
        (imgName: "help_4", content: "4. 선택을 탭하여 위젯에 표시할 디데이 정보를 선택할 수 있습니다."),
        (imgName: "help_5", content: "5. 다양한 크기의 위젯을 추가해보세요!")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBarUnderline()
    }
    @IBAction func dismissHelpView(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        
    }
}

extension WidgetHelpViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return helpData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = helpTableView.dequeueReusableCell(withIdentifier: "HelpTableCell", for: indexPath) as? HelpTableCell else { return UITableViewCell() }
        
        let data = helpData[indexPath.row]
        cell.helpImage.image = UIImage(named: data.imgName)
        cell.helpContents.text = data.content
        return cell
    }
    
    
}

class HelpTableCell: UITableViewCell {
    @IBOutlet weak var helpImage: UIImageView!
    @IBOutlet weak var helpContents: UILabel!
}
