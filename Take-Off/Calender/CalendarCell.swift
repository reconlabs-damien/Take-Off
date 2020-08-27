//
//  CalendarCell.swift
//  Take-Off
//
//  Created by Jun on 2020/08/24.
//  Copyright © 2020 Jun. All rights reserved.
//

import UIKit

class CalendarCell: UITableViewCell {
    static let identifier = "CalendarControllerCell"
    
    
    let personImage: CustomImageView = {
        let personImage = CustomImageView()
        personImage.contentMode = .scaleAspectFill
        personImage.clipsToBounds = true
        return personImage
    }()
    
    let personName: UILabel = {
        let personName = UILabel()
        personName.text = "실험용"
        return personName
    }()
    
    let timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.text = "실험"
        timeLabel.font = UIFont.boldSystemFont(ofSize: 14)
        return timeLabel
    }()
    
    let detailLabel: UILabel = {
       let detailLabel = UILabel()
        detailLabel.text = "dyd"
        return detailLabel
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(personImage)
        contentView.addSubview(personName)
        contentView.addSubview(timeLabel)
        contentView.addSubview(detailLabel)
        
        personImage.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        personImage.layer.cornerRadius = 40 / 2
        personName.anchor(top: self.topAnchor, left: personImage.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        timeLabel.anchor(top: personImage.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        detailLabel.anchor(top: personImage.bottomAnchor, left: timeLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
