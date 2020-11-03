//
//  UserProfileHeader.swift
//  Take-Off
//
//  Created by Jun on 2020/06/09.
//  Copyright © 2020 Jun. All rights reserved.
//

import UIKit
import Firebase

protocol UserProfileHeaderDelegate {
    func didChangeToListView()
    func didChangeToGridView()
}

class UserProfileHeader: UICollectionViewCell {
    
    var followerCount = 3
    var followingCount = 2
    var postsCount = 4
    var delegate: UserProfileHeaderDelegate?
    var user: User? {
        didSet {
            let attributedText2 = NSMutableAttributedString(string: String(postsCount) + "\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText2.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
            postsLabel.attributedText = attributedText2
            
            let attributedText1 = NSMutableAttributedString(string: String(followingCount) + "\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText1.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
            followingLabel.attributedText = attributedText1
            
            let attributedText = NSMutableAttributedString(string: String(followerCount) + "\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
            followersLabel.attributedText = attributedText
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: profileImageUrl)
            //setupProfileImage()
            usernameLabel.text = user?.username
            
            setupEditFollowButton()
        }
    }
    
    fileprivate func setupEditFollowButton() {
        
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        if currentLoggedInUserId == userId {
            //rgb(red: 250, green: 224, blue: 212)
            
        } else {
            
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                    
                } else {
                    self.setupFollowStyle()
                }
                
            }, withCancel: {(err) in
                print("Failed to check if following:", err)
            })
        }
    }
    
    @objc func handleEditProfileOrFollow() {
        
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        if editProfileFollowButton.titleLabel?.text == "Unfollow" {
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).removeValue { (err, ref) in
                if let err = err {
                    print("Failed to unfollow user:", err)
                    return
                }
                print("Successfully unfollowed user:", self.user?.username ?? "")
                self.setupFollowStyle()
                
            }
        } else {
        
        let ref = Database.database().reference().child("following").child(currentLoggedInUserId)
        let value = [userId : 1]
        ref.updateChildValues(value) {(err, ref) in
            if let err = err {
                print("Failed to follow user: ", err)
                return
            }
            print("Successfully followed user:", self.user?.username ?? "" )
            self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
            self.editProfileFollowButton.backgroundColor = .white
            self.editProfileFollowButton.setTitleColor(.black, for: .normal)
            }
        }
    }
    
    fileprivate func setupFollowStyle() {
        self.editProfileFollowButton.setTitle("Follow", for: .normal)
        self.editProfileFollowButton.backgroundColor = UIColor.rgb(red: 255, green: 85, blue: 54)
        self.editProfileFollowButton.setTitleColor(.white, for: .normal)
        self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    }
    
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        return iv
    }()
    
    lazy var gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "grid"), for: .normal)
        button.tintColor = .mainOrange()
        button.addTarget(self, action: #selector(handleChangeToGridView), for: .touchUpInside)
        return button
    }()
    
    @objc func handleChangeToGridView() {
        gridButton.tintColor = .mainOrange()
        listButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didChangeToGridView()
    }
    
    
    
    lazy var listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.addTarget(self, action: #selector(handleChangeToListView), for: .touchUpInside)
        return button
    }()
    
    @objc func handleChangeToListView() {
        listButton.tintColor = .mainOrange()
        gridButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didChangeToListView()
    }
    
    
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let postsLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
       
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
        return button
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
        
        setupBottomToolBar()
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: gridButton.topAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
        setupUserStatsView()
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: postsLabel.bottomAnchor, left: postsLabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 34)
    }
    
    
    //팔로워수, 팔로잉수, 게시물수를 설정하는 함수
    func setupCounter() {
        // 현재 사용자 uid를 상수로 지정
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        //posts 테이블에 uid가 같은 튜플만 가져옴
        Database.database().reference().child("posts").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            //snapshot의 value값을 userIdsDictionary 자료형으로 변환
            guard let userIdsDictionary = snapshot.value as? [String : Any] else { return }
            //postsCount를 userIdsDictionary의 키의 개수로 변경
            self.postsCount = userIdsDictionary.keys.count
        }, withCancel: nil)
        
        //같은 형식으로 following테이블을 가져옴
        Database.database().reference().child("following").observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userIdsDictionary = snapshot.value as? [String : Any] else { return }
            for key in userIdsDictionary.keys {
                //key가 uid와 같음면 following 수를 가져온다.
                if key == uid {
                    // 그 테이블로 들어가서 value의 개수를 가져온다.
                    Database.database().reference().child("following").child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                        guard let followingDictionary = snapshot.value as? [String : Any] else { return }
                        self.followingCount = followingDictionary.keys.count
                    }, withCancel: nil)
                }
                //아니면 follower의 수를 가져온다.
                else {
                    Database.database().reference().child("following").child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                         guard let followerDictionary = snapshot.value as? [String : Any] else { return }
                        for fkey in followerDictionary.keys {
                            if fkey == uid {
                                self.followerCount += 1
                            }
                        }
                    }, withCancel: nil)
                }
            }
            
        }, withCancel: nil)
            
        
    }
    
    fileprivate func setupUserStatsView() {
        setupCounter()
        let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)
    }
    
    fileprivate func setupBottomToolBar() {
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor.lightGray
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor.lightGray
        
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        stackView.anchor(top: nil, left: leftAnchor, bottom: self.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

