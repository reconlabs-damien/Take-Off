//
//  HomeController.swift
//  Take-Off
//
//  Created by Jun on 2020/06/09.
//  Copyright © 2020 Jun. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePostCellDelegate {
    // cellID 저장 (오타방지)
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateFeedNotificationName, object: nil)
        // 컬렉션뷰 배경색 흰색으로 바꿈(기본값: 검정)
        collectionView?.backgroundColor = .white
        // 컬렉션뷰의 표의 정보 등록
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        // UIRefreshControll을 refreshcontroll 변수에 선언
        let refreshControl = UIRefreshControl()
        // 새로고침을 실행하면 handleRefresh라는 메서드를 실행
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        //컬렉션뷰의 refreshControl을 refreshControl로 선언
        collectionView?.refreshControl = refreshControl
        setupNavigationItems()
        fetchAllPosts()
    }
    
    @objc func handleUpdateFeed() {
        handleRefresh()
    }
    
    // MARK: 새로고침을 할떄 포스트 업로드
    @objc func handleRefresh() {
        //포스트를 다 지우고 새롭게 포스트를 업로드
        posts.removeAll()
        fetchAllPosts()
    }
    
    // MARK: 처음 화면표시할때 게시물 업로드
    fileprivate func fetchAllPosts() {
        fetchPosts()
        fetchFollowingUserIds()
    }
    
    // MARK: follow를 한 유저정보 업로드
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
                    
                    self.fetchPostsWithUser(user: user)
                }
            }
        }) { (err) in
            print("Failed to fetch following user ids:", err)
        }
    }
    
    
    var posts = [Post]()
    // MARK: user 정보 확인
    fileprivate func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPostsWithUser(user: user)
        }
        
    }
    
    fileprivate func fetchPostsWithUser(user: User) {
        //가져온 user정보의 uid를 가지고 posts테이블의 uid안에 있는 정보를 가져온다.
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            //새로고침을 끝남을 알려주는 함수
            self.collectionView?.refreshControl?.endRefreshing()
            // posts/user.uid 안에 있는 정보를 distionaries에 저장
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            // 반복문 실행
            dictionaries.forEach({ (key, value) in
                // key = uid,  value = caption, creationDate...
                //dictionaries의 정보들을 하나씩 dictionary에 저장
                guard let dictionary = value as? [String: Any] else { return }
                
                //post모델에 삽입
                var post = Post(user: user, dictionary: dictionary)
                post.id = key
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    //print(snapshot)
                    //좋아요 상태 여부를 true false로 구분
                    if let value = snapshot.value as? Int, value == 1 {
                        post.hasLiked = true
                    } else {
                        post.hasLiked = false
                    }
                    //posts에 post를 하나씩 업로드
                    self.posts.append(post)
                    //받은 post를 날짜별로 정렬
                    self.posts.sort(by: { (p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    //collectionview를 리로드
                    self.collectionView?.reloadData()
                    
                }, withCancel: { (err) in
                    print("Failed to fetch like info for post:", err)
                })
            })
            
        }) { (err) in
            print("Failed to fetch posts:", err)
        }
    }
    // MARK: 네비게이션 아이템을 설정해주는 메서드
    func setupNavigationItems() {
        //타이틀 지정
        navigationItem.title = "Megazine"
        //왼쪽 버튼 설정
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "cancel_shadow"), style: .plain, target: self, action: #selector(handleCancel))
        //왼쪽 버튼 컬러지정
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    // MARK: dismiss
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 40 + 8 + 8 //username userprofileimageview
        height += view.frame.width
        height += 50
        height += 60
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //cell 정보를 HomePostCell에 상속
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        
        cell.post = posts[indexPath.item]
        cell.delegate = self
        
        return cell
    }
    
    // MARK: MessageController로 이동하는 메서드
    func didTapComment(post: Post) {
        print("Message coming from HomeController")
        
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.post = post
        navigationController?.pushViewController(commentsController, animated: true)
        
    }
    
    // MARK: 좋아요 함수
    func didLkike(for cell: HomePostCell) {
           guard let indexPath = collectionView?.indexPath(for: cell) else { return }
           var post = self.posts[indexPath.item]
           guard let postId = post.id else { return }
           guard let uid = Auth.auth().currentUser?.uid else { return }
           
           let values = [uid : post.hasLiked == true ? 0 : 1]
           
           Database.database().reference().child("likes").child(postId).updateChildValues(values) { (err, _) in
               if let err = err {
                   print("Failed to like post: ", err)
                   return
               }
               print("Successfully")
               
               post.hasLiked = !post.hasLiked
               
               self.posts[indexPath.item] = post
               self.collectionView?.reloadItems(at: [indexPath])
           }
       }
    
}

