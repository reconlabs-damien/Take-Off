//
//  addListController.swift
//  Take-Off
//
//  Created by Jun on 2020/08/27.
//  Copyright © 2020 Jun. All rights reserved.
//

import UIKit
import TextFieldEffects
import Firebase

class AddListController: UIViewController {
    
    let titleLabel: HoshiTextField = {
        let tf = HoshiTextField()
        tf.font = UIFont.systemFont(ofSize: 30)
        tf.placeholder = "제목"
        tf.borderActiveColor = .black
        tf.placeholderColor = .black
        tf.placeholderFontScale = 0.5
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let startDateLabel: UILabel = {
        let lb = UILabel()
        var formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let time = formatter.string(from: Date())
        lb.font = UIFont.systemFont(ofSize: 20)
        lb.text = "시작 : " + time
        return lb
    }()
    
    let startPickerView: UIDatePicker = {
        let dp = UIDatePicker()
        
        //datePicker 모드 설정
        dp.datePickerMode = .dateAndTime
        //지역을 한국으로 설정
        dp.locale = Locale(identifier: "ko_KR")
        //날짜 값을 가져올때 사용
        dp.date = Date()
        //애니메이션 효과 적용
        dp.setDate(Date(), animated: true)
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
        lb.text = "종료 : " + time
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
        return dp
    }()
    
    let locationTextField: HoshiTextField = {
        let tf = HoshiTextField()
        tf.font = UIFont.systemFont(ofSize: 30)
        tf.placeholder = "장소"
        tf.borderActiveColor = .black
        tf.placeholderColor = .black
        tf.placeholderFontScale = 0.5
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
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
        let cc = CalenderController()
        navigationItem.title = cc.headTitle.text
        view.addSubview(titleLabel)
        view.addSubview(startDateLabel)
        view.addSubview(startPickerView)
        view.addSubview(endDateLabel)
        view.addSubview(endPickerView)
        view.addSubview(locationTextField)
        view.addSubview(confirmButton)
        startPickerView.addTarget(self, action: #selector(startChangeTime), for: .valueChanged)
        endPickerView.addTarget(self, action: #selector(endChangeTime), for: .valueChanged)
        
        
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: view.frame.width, height: 60)
        
        startDateLabel.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 0)
        
        startPickerView.anchor(top: startDateLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 1, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 0)
        
        endDateLabel.anchor(top: startPickerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 1, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 0)
        
        endPickerView.anchor(top: endDateLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 1, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 0)
        
        locationTextField.anchor(top: endPickerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: view.frame.width, height: 60)
        
        confirmButton.anchor(top: locationTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: view.frame.width, height: 0)
        
        
        
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
        
        self.navigationItem.title = now
        startDateLabel.text = "시작 : " + result1
        
    }
    
    @objc func endChangeTime() {
        let time = endPickerView.date
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ko_KR")
        let result = formatter.string(from: time)
        endDateLabel.text = "종료 : " + result
        
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
    
    
    @objc func postList() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let location = locationTextField.text else { return }
        guard let event = titleLabel.text else { return }
        guard let dday = navigationItem.title else { return }
        guard let startTmp = startDateLabel.text else { return }
        guard let endTmp = endDateLabel.text else { return }
        
        let start = startTmp.dropFirst(5)
        let end = endTmp.dropFirst(5)
        let userCalendarRef = Database.database().reference().child("calendars").child(uid)
        let ref = userCalendarRef.childByAutoId()
        
        let values = ["event": event, "location": location, "dday": dday, "start": start, "end": end] as [String: Any]
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                print("calendar DB error", err)
                return
            }
            print("Successfully saved calendar to DB")
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
}
