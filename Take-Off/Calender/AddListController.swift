//
//  addListController.swift
//  Take-Off
//
//  Created by Jun on 2020/08/27.
//  Copyright © 2020 Jun. All rights reserved.
//

import UIKit
import Firebase

class AddListController: UIViewController {
    
    let titleLabel: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 20)
        
        tf.placeholder = "제목"
        tf.textColor = .black
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let startDateLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = UIFont.systemFont(ofSize: 20)
        lb.text = "시작"
        return lb
    }()
    
    let startDateTime: UIButton = {
       let lb = UIButton()
        var formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let time = formatter.string(from: Date())
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "ko_KR")
        dateformatter.dateFormat = "M월 d일"
        let date = dateformatter.string(from: Date())
        lb.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        lb.setTitle(date + " " + time, for: .normal)
        lb.setTitleColor(.black, for: .normal)
        //lb.addTarget(self, action: #selector(startShowPicker), for: .touchUpInside)
        return lb
    }()
    
    
    fileprivate let startPickerView: UIDatePicker = {
        let dp = UIDatePicker()
        //datePicker 모드 설정
        dp.datePickerMode = .dateAndTime
        //지역을 한국으로 설정
        dp.locale = Locale(identifier: "ko_KR")
        //날짜 값을 가져올때 사용
        dp.date = Date()
        //애니메이션 효과 적용
        dp.setDate(Date(), animated: true)
        dp.addTarget(self, action: #selector(startChangeTime), for: .valueChanged)
        return dp
    }()
    
    let endDateLabel: UILabel = {
        let lb = UILabel()
        var formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let time = formatter.string(from: Date())
        lb.font = UIFont.systemFont(ofSize: 20)
        lb.textColor = .black
        lb.text = "종료"
        return lb
    }()
    
    let endDateTime: UIButton = {
        let lb = UIButton()
        var formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let time = formatter.string(from: Date())
        lb.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        lb.setTitle(time, for: .normal)
        lb.setTitleColor(.black, for: .normal)
        //lb.addTarget(self, action: #selector(endShowPicker), for: .touchUpInside)
        return lb
    }()
    
    let endPickerView: UIDatePicker = {
        let dp = UIDatePicker()
        //datePicker 모드 설정
        dp.datePickerMode = .dateAndTime
        //지역을 한국으로 설정
        dp.locale = Locale(identifier: "ko_KR")
        //날짜 값을 가져올때 사용
        dp.date = Date()
        //애니메이션 효과 적용
        dp.setDate(Date(), animated: true)
        dp.addTarget(self, action: #selector(endChangeTime), for: .valueChanged)
        return dp
    }()
    
    var locationTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 20)
        tf.textColor = .black
        tf.placeholder = "장소"
        tf.tintColor = .none
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let locationButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "map"), for: .normal)
        bt.addTarget(self, action: #selector(handleLocationController), for: .touchUpInside)
        return bt
    }()
    
    @objc func handleLocationController() {
        let locationCV = LocationSelectorController()
        let navController = UINavigationController(rootViewController: locationCV)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
    
    let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("공유", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 250, green: 224, blue: 212)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(postList), for: .touchUpInside)
        button.isEnabled = true
        return button
    }()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(startDateLabel)
        view.addSubview(startDateTime)
        
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: view.frame.width, height: 60)
        startDateLabel.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        startDateTime.anchor(top: titleLabel.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        
        view.addSubview(startPickerView)
        startPickerView.anchor(top: startDateLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        
        
        view.addSubview(endDateLabel)
        view.addSubview(endDateTime)
        endDateLabel.anchor(top: startPickerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        endDateTime.anchor(top: startPickerView.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        
        
        view.addSubview(endPickerView)
        endPickerView.anchor(top: endDateLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        
        view.addSubview(locationTextField)
        view.addSubview(locationButton)
        view.addSubview(confirmButton)
        
        locationButton.anchor(top: endPickerView.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 20, height: 20)
        locationTextField.anchor(top: endPickerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: locationButton.leftAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        
        confirmButton.anchor(top: locationTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        
        setupNavigationItems()
    }
    
    
    @objc func startChangeTime() {
        let time = startPickerView.date
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        timeFormatter.locale = Locale(identifier: "ko_KR")
        let result1 = timeFormatter.string(from: time)
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "ko_KR")
        dateformatter.dateFormat = "M월 d일"
        let now = dateformatter.string(from: time)
        startDateTime.titleLabel?.text = now + " " + result1
        
    }
    
    @objc func endChangeTime() {
        let time = endPickerView.date
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ko_KR")
        let result = formatter.string(from: time)
        endDateTime.titleLabel?.text = result
        
    }
    
    @objc func handleTextInputChange() {
        let isFormValid = titleLabel.text?.isEmpty == false && locationTextField.text?.isEmpty == false
        
        if isFormValid {
            confirmButton.isEnabled = true
            confirmButton.backgroundColor = UIColor.rgb(red: 255, green: 85, blue: 54)
        } else {
            confirmButton.isEnabled = false
            confirmButton.backgroundColor = UIColor.rgb(red: 250, green: 224, blue: 212)
        }
    }
    
    func setupNavigationItems() {
        //왼쪽 버튼 설정
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "cancel_shadow"), style: .plain, target: self, action: #selector(handleCancel))
        //왼쪽 버튼 컬러지정
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func postList() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let location = locationTextField.text else { return }
        guard let event = titleLabel.text else { return }
        guard let startTmp = startDateTime.titleLabel?.text else { return }
        guard let endTmp = endDateTime.titleLabel?.text else { return }
        
        let tmp_dday = startTmp.dropLast(8)
        let dday = tmp_dday.trimmingCharacters(in: .whitespaces)
        let start = startTmp.dropFirst(7)
        let userCalendarRef = Database.database().reference().child("calendars").child(uid)
        let ref = userCalendarRef.childByAutoId()
        let values = ["user": uid, "event": event, "location": location, "dday": dday, "start": start, "end": endTmp] as [String: Any]
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                print("calendar DB error", err)
                return
            }
            print("Successfully saved calendar to DB")
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
