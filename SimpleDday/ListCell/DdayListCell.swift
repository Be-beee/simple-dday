//
//  DdayListCell.swift
//  SimpleDday
//
//  Created by 서보경 on 2021/03/19.
//

import UIKit

class DdayListCell: UITableViewCell {
    @IBOutlet weak var ddayTitle: UILabel!
    @IBOutlet weak var ddayDate: UILabel!
    @IBOutlet weak var ddayImage: UIImageView!
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var alarmImageView: UIImageView!
    
    func animateSwipeHint() {
        slideFromRight()
    }
    
    private func slideFromRight() {
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [.curveEaseOut]) {
            self.mainView.transform = CGAffineTransform(translationX: -20, y: 0)
        } completion: { (success) in
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveLinear], animations: {
                self.mainView.transform = .identity
            }, completion: nil)
        }
    }
}
