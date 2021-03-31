//
//  AddDdayViewController.swift
//  SimpleDday
//
//  Created by 서보경 on 2021/03/18.
//

import UIKit

class AddDdayViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let df = DateFormatter()
    var newData: DateCountModel = DateCountModel(date: Date(), title: "None", isDday: true, shouldAlarm: false, bgImage: Data(), bgColor: "None")
    
    var isImageFilled = false

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var ddayButton: UIStackView!
    @IBOutlet weak var dateCountButton: UIStackView!
    
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var ddayDatePicker: UIDatePicker!
    
    @IBOutlet weak var pushNotiSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBarUnderline()
        setDateFormatter()
        setButtonUI()
        setTapGestureAtImageView()
        setTapGestureAtView()
    }
    
    func setDateFormatter() {
        df.dateFormat = "yyyy년 MM월 dd일"
//        df.locale = Locale(identifier: "ko_KR")
        
        selectedDateLabel.text = df.string(from: Date())
    }
    func setButtonUI() {
        setDdayMode()
        
        let ddayButtonTap = UITapGestureRecognizer(target: self, action: #selector(selectDday))
        ddayButton.addGestureRecognizer(ddayButtonTap)
        
        let dateCountButtonTap = UITapGestureRecognizer(target: self, action: #selector(selectDateCount))
        dateCountButton.addGestureRecognizer(dateCountButtonTap)
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
    
    func setTapGestureAtView() {
        let tapBG = UITapGestureRecognizer(target: self, action: #selector(tapBackground))
        self.view.addGestureRecognizer(tapBG)
    }
    
    @objc func tapBackground() {
        self.titleTextField.resignFirstResponder()
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
    
    @objc func selectDday() {
        setDdayMode()
        newData.isDday = true
    }
    
    @objc func selectDateCount(_ sender: UIButton) {
        setDateCountMode()
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
        newData.bgColor = Theme.main.colors.randomElement()?.key ?? "None"
        if isImageFilled {
            newData.bgImage = mainImageView.image?.jpegData(compressionQuality: 0.5) ?? Data()
            print(newData.bgImage)
        }
        
        self.performSegue(withIdentifier: "toMain", sender: self)
    }
}

extension AddDdayViewController {
    func setDdayMode() {
        ddayButton.backgroundColor = Theme.main.colors["green"]
        dateCountButton.backgroundColor = .clear
        
        ddayDatePicker.minimumDate = Date()
        ddayDatePicker.maximumDate = nil
    }
    
    func setDateCountMode() {
        ddayButton.backgroundColor = .clear
        dateCountButton.backgroundColor = Theme.main.colors["red"]
        
        ddayDatePicker.minimumDate = nil
        ddayDatePicker.maximumDate = Date()
    }
}
