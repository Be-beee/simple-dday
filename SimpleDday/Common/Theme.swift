//
//  Theme.swift
//  SimpleDday
//
//  Created by 서보경 on 2021/04/27.
//

import UIKit

// MARK:- Navigation UI
extension UIViewController {
    func hideNavigationBarUnderline() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}

// MARK:- DdayLabel Design
struct DdayLabelManager {
    static func setDdayLabel(date: Date, isDday: Bool, needDetail: Bool = false) -> String {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let today = Calendar.current.date(from: dateComponents) ?? Date()
        let timeInterval = today.timeIntervalSince(date)
        let diff = Int(round(timeInterval/(60*60*24)))
        
        if diff < 0 {
            return needDetail ? "\(abs(diff))일 남았습니다.😲" : "D\(diff)"
        } else if diff == 0 {
            if isDday {
                return needDetail ? "D-day🎉" : "D-day"
            } else {
                return needDetail ? "오늘부터 1일!😘" : "D+1"
            }
        } else {
            if isDday {
                return needDetail ? "\(diff)일 지났습니다.😪" : "D+\(diff)"
            } else {
                return needDetail ? "시작일로부터 \(diff+1)일째 입니다.😍" : "D+\(diff+1)"
            }
        }
    }
}

extension UIViewController {
    func showToastMessage(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height-100, width: 200, height: 35))
        toastLabel.backgroundColor = UIColor.systemGray
        toastLabel.textColor = .white
        
        toastLabel.font = .systemFont(ofSize: 14.0)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 1.5, delay: 0.3, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { isCompleted in
            toastLabel.removeFromSuperview()
        })
    }
}

struct ResizingManager {
    static func resizeImage(image: UIImage) -> UIImage? {
        let originalImage = image
        let newWidth: CGFloat = (UIScreen.main.bounds.width + 100)
        let newHeight: CGFloat = (UIScreen.main.bounds.width + 100) * (originalImage.size.height / originalImage.size.width)
        let targetSize = CGSize(width: newWidth, height: newHeight)
        
        let size = image.size

        let widthRatio = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
