//
//  SharePhotoController.swift
//  Take-Off
//
//  Created by Jun on 2020/06/09.
//  Copyright © 2020 Jun. All rights reserved.
//

import UIKit
import Firebase
class SharePhotoController: UIViewController {
    
    var selectedImage: UIImage? {
        didSet {
            self.imageView.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        
        setupImageAndTextViews()
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    
    fileprivate func setupImageAndTextViews() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        containerView.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 84, height: 0)
        
        containerView.addSubview(textView)
        textView.anchor(top: containerView.topAnchor, left: imageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    
    @objc func handleShare() {
        //textView안에 택스트를 caption 상수로 정의
        guard let caption = textView.text, !caption.isEmpty else {return}
        //게시물을 올릴 이미지 상수 정의
        guard let image = selectedImage else { return }
        //이미지 데이터의 크기를 변환하여 처리해주는 함수
        guard let uploadData = image.jpegData(compressionQuality: 0.5) else {return}
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let filename = NSUUID().uuidString
        //Firebase Storage안에 있는 posts폴더를 지정
        let storageRef = Storage.storage().reference().child("posts").child(filename)
        
        //putData : storage함수에 데이터를 집어넣어주는 함수
        storageRef.putData(uploadData, metadata: nil) { (metadata, err) in
            //exception 처리
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload post image: ", err)
                return
            }
            
            storageRef.downloadURL(completion: {(downloadURL, err) in
                
                if let err = err {
                    print("Failed to fetch downloadURL:", err)
                    return
                }
                //이미지 파일을 스트링 파일로 변환후 데이터베이스에 삽입
                guard let imageUrl = downloadURL?.absoluteString else { return }
                print("Successfully uploaded post image:", imageUrl)
                
                //ImageUrl을 DB에 넣어주는 Extension함수
                self.saveToDatabaseWithImageUrl(imageUrl: imageUrl)
            })
        }
        
    }
    static let updateFeedNotificationName = NSNotification.Name(rawValue: "Update Feed")
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
        guard let postImage = selectedImage else { return }
        guard let caption = textView.text else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userPostRef = Database.database().reference().child("posts").child(uid)
        let ref = userPostRef.childByAutoId()
        
        let values = ["imageUrl": imageUrl, "caption": caption, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "creationDate": Date().timeIntervalSince1970] as [String : Any]
        
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to save post to DB", err)
                return
            }
            
            print("Successfully saved post to DB")
            self.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

