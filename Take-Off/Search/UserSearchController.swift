//
//  UserSearchController.swift
//  Take-Off
//
//  Created by Jun on 2020/06/09.
//  Copyright © 2020 Jun. All rights reserved.
//

import UIKit
import Firebase

class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter username"
        sb.barTintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        sb.delegate = self
        return sb
    }()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = self.users.filter { (user) -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            }
        }
        
        self.collectionView.reloadData()
    }
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        
        navigationController?.navigationBar.addSubview(searchBar)
        
        let navBar = navigationController?.navigationBar
        
        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        collectionView.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
        fetchUsers()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        let user = filteredUsers[indexPath.item]
        
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileController.userId = user.uid
        navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    
    var filteredUsers = [User]()
    var users = [User]()
    fileprivate func fetchUsers() {
        //users 테이블에 있는 데이터를 가져옴
        let ref = Database.database().reference().child("users")
        //obserbeSingleEvent : users 테이블에 있는 데이터를 하나씩 꺼내오는 함수
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // 가져온 데이터의 value를 딕셔너리 형태로 변환
            guard let dictionaries = snapshot.value as? [String: Any] else {return}
            
            //key와 value로 나뉘어진 반복문
            dictionaries.forEach { (key, value) in
                //key가 현재 사용자의 uid가 아니라면 리턴
                if key == Auth.auth().currentUser?.uid {
                    return
                }
                // value로 userDictionary로 변환
                guard let userDictionary = value as? [String: Any] else { return }
                
                //가져온 데이터를 User 모델로 변환
                let user = User(uid: key, dictionary: userDictionary)
                //users 배열에 추가
                self.users.append(user)
            }
            
            //데이터를 이름순으로 정렬
            self.users.sort { (u1, u2) -> Bool in
                return u1.username.compare(u2.username) == .orderedAscending
            }
            
            self.filteredUsers = self.users
            //collectionView 테이블 초기화
            self.collectionView.reloadData()
            
        }) { (err) in
            print("Failed to fetch users for seach: ", err)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
        
        cell.user = filteredUsers[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
    
}

