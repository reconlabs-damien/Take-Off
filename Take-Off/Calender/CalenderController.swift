//
//  CalenderController.swift
//  Take-Off
//
//  Created by Jun on 2020/06/19.
//  Copyright © 2020 Jun. All rights reserved.
//

import UIKit
import FSCalendar
import Firebase

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}
class CalenderController: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDelegate, FSCalendarDataSource {
    
    var calendars = [Calendar]()
    var calendarsAll: [String] = []
    let cellId = "cellId"
    var tableView: UITableView!
    
    private lazy var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.dataSource = self
        calendar.delegate = self
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.weekdayTextColor = .black
        calendar.appearance.todayColor = .orange
        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "Cell")
        return calendar
    }()
    
    public let headTitle: UILabel = {
        let lb = UILabel()
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "ko_KR")
        dateformatter.dateFormat = "M월 d일"
        let now = dateformatter.string(from: Date())
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.textAlignment = .center
        lb.text = now
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        let image = UIImage(named: "gear")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addToDOList))
        view.backgroundColor = .white
        view.addSubview(calendar)
        calendar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: view.frame.height / 2)

        view.addSubview(headTitle)
        headTitle.anchor(top: calendar.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 0)
        
        self.tableView.register(CalendarCell.self, forCellReuseIdentifier: cellId)
        fetchAllPosts()
        view.addSubview(self.tableView)
        tableView.anchor(top: headTitle.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CalendarCell
        let calendar = calendars[indexPath.row]
        cell.calendar = calendar
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "Cell", for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "ko_KR")
        dateformatter.dateFormat = "M월 d일"
        let now = dateformatter.string(from: date)
        
        if self.calendarsAll.contains(now) {
            return 1
        }
        else {
            return 0
        }
        
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "ko_KR")
        dateformatter.dateFormat = "M월 d일"
        let changeTime = dateformatter.string(from: date)
        headTitle.text = changeTime
        handleRefresh()
    }
    
    @objc func handleRefresh() {
        fetchAllPosts()
    }
    
    fileprivate func fetchFollowingUserIds(_ user: String) {
        //uid에 현재 로그인한 유저의 uid를 저장
        
        let ref = Database.database().reference().child("following").child(user)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userIdsDictionary = snapshot.value as? [String: Any] else {return}
            userIdsDictionary.forEach { (key, value) in
                self.fetchCalendersWithUser(key)
            }
            
        }, withCancel: nil)
        
    }
    
    func fetchCalendersWithUser(_ uid : String) {
        //가져온 user정보의 uid를 가지고 posts테이블의 uid안에 있는 정보를 가져온다.
        let ref = Database.database().reference().child("calendars").child(uid)
        //observeSingleEvent : 테이블안에 등록되있는 튜플들을 하나씩 가져오는 함수
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            //테이블안에 있는 데이터를 초기화 시켜주는 함수
            self.tableView.refreshControl?.endRefreshing()
            //가져온 튜플을 딕셔너리 형태로 만들어주는 함수
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            //딕셔너리안에 있는 key와 value를 하나씩 실행하는 반복문
            dictionaries.forEach { (key, value) in
                // values를 캘린더 모델에 맞게 바꿔주는 함수
                let message = Calendar(dictionary: value as! [String : Any])
                // calendarsAll이란 배열에 메시지의 디데이라는 key안에 value를 저장
                self.calendarsAll.append(message.dday)
                //메시지의 디데이와 내가 클릭한 날짜와 같다면
                if message.dday == self.headTitle.text {
                    //calendars테이블에 메시지를 저장
                    self.calendars.append(message)
                }
               
            }
            //비동기 처리방식을 위한 함수
            DispatchQueue.main.async {
                //테이블뷰와 캘린더를 리로드해줌
                self.tableView.reloadData();
                self.calendar.reloadData()
            }
            
        }) { (err) in
            print("Failed to fetch posts:", err)
        }
          
    }
    
    
    
    func fetchAllPosts() {
        calendars.removeAll()
        self.tableView.reloadData()
        guard let uid = Auth.auth().currentUser?.uid else { return}
        fetchCalendersWithUser(uid)
        fetchFollowingUserIds(uid)
    }
    
    @objc func addToDOList() {
        let addListController = AddListController()
        let navController = UINavigationController(rootViewController: addListController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
    
    

}
