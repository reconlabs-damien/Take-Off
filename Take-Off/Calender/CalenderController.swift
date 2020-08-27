//
//  CalenderController.swift
//  Take-Off
//
//  Created by Jun on 2020/06/19.
//  Copyright © 2020 Jun. All rights reserved.
//

import UIKit
import FSCalendar
class CalenderController: UIViewController {
    
    
    var personData: [PersonData] = []
    private let personNames = ["아이유", "정우성"]
    
    private func makeData() {
        for i in 0...1 {
            personData.append(PersonData.init(
                personImage: UIImage(named: "태1.jpeg")!, personName: personNames[i], personAge: 20
            ))
        }
    }
    
    private lazy var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.dataSource = self
        calendar.delegate = self
        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "Cell")
        return calendar
    }()
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CalendarCell.self, forCellReuseIdentifier: CalendarCell.identifier)
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeData()
        let image = UIImage(named: "gear")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addToDOList))
        view.backgroundColor = .white
        
        view.addSubview(calendar)
        calendar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: view.frame.height / 2)
        
        view.addSubview(tableView)
        tableView.anchor(top: calendar.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        tableView.dataSource = self
        tableView.rowHeight = 100
    }
}






extension CalenderController: FSCalendarDelegate, FSCalendarDataSource, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CalendarCell.identifier, for: indexPath) as! CalendarCell
        return cell
    }
    
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        return "sample text"
//    }
//    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
//        return "subtitle"
//    }
    
    
    
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "Cell", for: date, at: position)
        
        return cell
    }
    
    @objc func addToDOList() {
        
    }
}
