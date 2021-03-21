//
//  AddDdayViewController.swift
//  SimpleDday
//
//  Created by 서보경 on 2021/03/18.
//

import UIKit

class AddDdayViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let bgColor: [UIColor] = [.systemRed, .systemBlue, .systemPink, .systemTeal, .systemGreen, .systemOrange, .systemPurple, .systemIndigo, .systemYellow]
    
    let df = DateFormatter()
    var newData: DateCountModel = DateCountModel(date: Date(), title: "None", isDday: true, shouldAlarm: false)
    
    var isImageFilled = false

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var ddayBtn: UIButton!
    @IBOutlet weak var dateCountBtn: UIButton!
    
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var ddayDatePicker: UIDatePicker!
    
    @IBOutlet weak var pushNotiSwitch: UISwitch!
    
    @IBOutlet weak var memoInputView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBarUnderline()
        setDateFormatter()
        setButtonUI()
        setTapGestureAtImageView()
    }
    
    func setDateFormatter() {
        df.dateFormat = "yyyy년 MM월 dd일"
//        df.locale = Locale(identifier: "ko_KR")
        
        selectedDateLabel.text = df.string(from: Date())
    }
    func setButtonUI() {
        ddayBtn.setTitleColor(.systemIndigo, for: .normal)
        dateCountBtn.setTitleColor(.systemGray, for: .normal)
    }
    func setTapGestureAtImageView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapEmptyImage))
        mainImageView.addGestureRecognizer(tap)
        mainImageView.isUserInteractionEnabled = true
    }
    
    @objc func tapEmptyImage() {
        if !isImageFilled {
            loadImagePickerVC()
        } else {
            let modifyAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let modify = UIAlertAction(title: "이미지 변경", style: .default) { _ in
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.delegate = self
                
                self.present(imagePickerController, animated: true, completion: nil)
            }
            let delete = UIAlertAction(title: "이미지 삭제", style: .destructive) { _ in
                self.mainImageView.image = UIImage(named: "plus image")
                self.isImageFilled = false
            }
            
            modifyAlert.addAction(modify)
            modifyAlert.addAction(delete)
            
            self.present(modifyAlert, animated: true, completion: nil)
        }
    }
    
    func loadImagePickerVC() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            return
        }
        
        mainImageView.image = selectedImage
        isImageFilled = true
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func selectDate(_ sender: UIDatePicker) {
        selectedDateLabel.text = df.string(from: ddayDatePicker.date)
    }
    
    @IBAction func selectDday(_ sender: UIButton) {
        ddayBtn.setTitleColor(.systemIndigo, for: .normal)
        dateCountBtn.setTitleColor(.systemGray, for: .normal)
        
        newData.isDday = true
    }
    
    @IBAction func selectDateCount(_ sender: UIButton) {
        ddayBtn.setTitleColor(.systemGray, for: .normal)
        dateCountBtn.setTitleColor(.systemIndigo, for: .normal)
        
        newData.isDday = false
    }
    
    @IBAction func dismissVC(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addDday(_ sender: UIBarButtonItem) {
        if let title = titleTextField.text {
            newData.title = title
        }
        newData.date = ddayDatePicker.date
        newData.shouldAlarm = pushNotiSwitch.isOn
        newData.bgColor = bgColor.randomElement()
        if isImageFilled {
            newData.bgImage = mainImageView.image
        }
        if !memoInputView.text.isEmpty {
            newData.memo = memoInputView.text
        }
        
        self.performSegue(withIdentifier: "toMain", sender: self)
    }
}
