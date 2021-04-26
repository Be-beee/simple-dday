//
//  AddDdayViewController.swift
//  SimpleDday
//
//  Created by 서보경 on 2021/03/18.
//

import UIKit
import UserNotifications

class AddDdayViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var editMode: Mode?
    var selectedIdx: Int?
    
    let df = DateFormatter()
    var newData: DateCountModel = DateCountModel(date: Date(), title: "None", isDday: true, shouldAlarm: false, bgImage: Data(), bgColor: "None", createDate: Date())
    
    var isImageFilled = false

    @IBOutlet weak var checkBarButton: UIBarButtonItem!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var ddayButton: UIStackView!
    @IBOutlet weak var dateCountButton: UIStackView!
    
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var ddayDatePicker: UIDatePicker!
    
    @IBOutlet weak var pushNotiSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleTextField.delegate = self
        hideNavigationBarUnderline()
        setDateFormatter()
        setEditModeData()
        setButtonUI()
        setTapGestureAtImageView()
        setTapGestureAtView()
    }
    
    func setEditModeData() {
        guard editMode == .edit else { return }
        guard let index = selectedIdx else { return }
        
        let selectedData = DdayData.shared.ddayList[index]
        self.navigationItem.title = "디데이 수정"
        mainImageView.image = selectedData.dataToImage()
        if mainImageView.image == UIImage() || mainImageView.image == nil {
            isImageFilled = false
        } else {
            isImageFilled = true
        }
        
        mainImageView.backgroundColor = Theme.main.colors[selectedData.bgColor]
        titleTextField.text = selectedData.title
        selectedDateLabel.text = df.string(from: selectedData.date)
        ddayDatePicker.date = selectedData.date
        pushNotiSwitch.isOn = selectedData.shouldAlarm
    }
    
    func setDateFormatter() {
        df.dateFormat = "yyyy년 MM월 dd일"
        
        selectedDateLabel.text = df.string(from: Date())
    }
    func setButtonUI() {
        if editMode == .edit {
            guard let idx = selectedIdx else { return }
            let item = DdayData.shared.ddayList[idx]
            switch item.isDday {
            case true:
                setDdayMode()
            default:
                setDateCountMode()
            }
            
        } else {
            checkBarButton.isEnabled = false
            setDdayMode()
        }
        
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
                self.loadImagePickerVC()
            }
            let delete = UIAlertAction(title: "이미지 삭제", style: .destructive) { _ in
                self.mainImageView.image = UIImage(named: "plus image")
                self.isImageFilled = false
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            
            modifyAlert.addAction(modify)
            modifyAlert.addAction(delete)
            modifyAlert.addAction(cancel)
            
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
    
    @IBAction func titleDidChange(_ sender: UITextField) {
        if let text = titleTextField.text, !text.isEmpty {
            checkBarButton.isEnabled = true
        } else {
            checkBarButton.isEnabled = false
        }
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
    
    @IBAction func saveDday(_ sender: UIBarButtonItem) {
        if let title = titleTextField.text {
            newData.title = title
        }
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: ddayDatePicker.date)
        newData.date = Calendar.current.date(from: dateComponents) ?? Date()
        newData.shouldAlarm = pushNotiSwitch.isOn
        
        if let mode = editMode, mode == .edit {
            guard let selectedIdx = self.selectedIdx else { return }
            newData.bgColor = DdayData.shared.ddayList[selectedIdx].bgColor
            if isImageFilled {
                newData.bgImage = mainImageView.image?.jpegData(compressionQuality: 0.5) ?? Data()
                // 기존 이미지를 변경하지 않고 수정할 때마다 이미지 품질이 떨어지는 이슈가 발생할 수 있음
            }
            newData.createDate = DdayData.shared.ddayList[selectedIdx].createDate
            
            if newData.shouldAlarm {
                NotificationManager.addNewNotification(newData)
            } else {
                NotificationManager.removeNotification(newData)
            }
            // 이미 NotificationRequests에 없는 request를 삭제하거나 기존에 있던 데이터를 중복 저장하는 이슈가 발생할 수 있음
            // 날짜만 바뀐 데이터의 경우 이전 request가 더미 데이터로 남는 이슈가 발생할 수 있음
            
            
            self.performSegue(withIdentifier: "toDetailViewFromModify", sender: self)
        } else {
            newData.bgColor = Theme.main.colors.randomElement()?.key ?? "None"
            if isImageFilled {
                newData.bgImage = mainImageView.image?.jpegData(compressionQuality: 0.5) ?? Data()
            }
            newData.createDate = Date()
            
            if newData.shouldAlarm {
                NotificationManager.addNewNotification(newData)
            }
            
            self.performSegue(withIdentifier: "toMain", sender: self)
            
            
        }
    }
}

extension AddDdayViewController {
    func setDdayMode() {
        ddayButton.backgroundColor = Theme.main.colors["yellow"]
        dateCountButton.backgroundColor = .clear
        
        ddayDatePicker.minimumDate = Date()
        ddayDatePicker.maximumDate = nil
    }
    
    func setDateCountMode() {
        ddayButton.backgroundColor = .clear
        dateCountButton.backgroundColor = Theme.main.colors["soda"]
        
        ddayDatePicker.minimumDate = nil
        ddayDatePicker.maximumDate = Date()
    }
}

extension AddDdayViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
