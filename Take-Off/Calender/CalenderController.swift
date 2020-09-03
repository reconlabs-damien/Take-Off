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

class CalenderController: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDelegate, FSCalendarDataSource {
    
    var calendars = [Calendar]()
    let cellId = "cellId"
    
    private lazy var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.dataSource = self
        calendar.delegate = self
        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "Cell")
        return calendar
    }()
    
    var tableView: UITableView = {
        let tv = UITableView()
        tv.register(CalendarCell.self, forCellReuseIdentifier: "cellId")
        return tv
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
        let image = UIImage(named: "gear")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addToDOList))
        view.backgroundColor = .white
        
        view.addSubview(calendar)
        calendar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: view.frame.height / 2)
        
        view.addSubview(headTitle)
        headTitle.anchor(top: calendar.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 0)
        
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.anchor(top: headTitle.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        fetchAllPosts()
        print(calendars)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CalendarCell
        cell.calendar = calendars[indexPath.item]
        print(calendar)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "Cell", for: date, at: position)
        
        return cell
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
        calendars.removeAll()
        fetchAllPosts()
    }
    
    fileprivate func fetchFollowingUserIds() {
        //uid에 현재 로그인한 유저의 uid를 저장
        guard let uid = Auth.auth().currentUser?.uid else { return }
        //데이터 베이스에 있는 following테이블에 안에 있는 uid에 들어있는 정보를 하나씩 호출
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            //snapshot == uid에 들어있는 정보
            //userIdsDictionary에 snapshot에 저장된 uid를 차례대로 저장
            guard let userIdsDictionary = snapshot.value as? [String: Any] else {return}
            
            //forEach == 반복문
            userIdsDictionary.forEach { (key, value) in
                //fetchUerWithUid = userIdsDictionary에 저장된 uid의 user정보를 가져와준다.
                Database.fetchUserWithUID(uid: key) { (user) in
                    
                    self.fetchCalendersWithUser(user: user)
                }
            }
            self.tableView.reloadData()
        }) { (err) in
            print("Failed to fetch following user ids:", err)
        }
    }
    
    fileprivate func fetchCalendersWithUser(user: User) {
        //가져온 user정보의 uid를 가지고 posts테이블의 uid안에 있는 정보를 가져온다.
        let ref = Database.database().reference().child("calendars").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            self.tableView.refreshControl?.endRefreshing()
            // posts/user.uid 안에 있는 정보를 distionaries에 저장
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            // 반복문 실행
            dictionaries.forEach({ (key, value) in
                // key = uid,  value = caption, creationDate...
                //dictionaries의 정보들을 하나씩 dictionary에 저장
                guard let dictionary = value as? [String: Any] else { return }
                
                //post모델에 삽입
                let post = Calendar(user: user, dictionary: dictionary)
                
                if post.dday == self.headTitle.text {
                self.calendars.append(post)
                print(self.calendars)
                }
            })
        }) { (err) in
            print("Failed to fetch posts:", err)
        }
          
    }
    
    fileprivate func fetchPosts() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchCalendersWithUser(user: user)
        }
        self.tableView.reloadData()
        
    }
    
    fileprivate func fetchAllPosts() {
        fetchPosts()
        fetchFollowingUserIds()
    }
    
    
    @objc func addToDOList() {
        let addListController = AddListController()
        let navController = UINavigationController(rootViewController: addListController)
        present(navController, animated: true, completion: nil)
    }

}
