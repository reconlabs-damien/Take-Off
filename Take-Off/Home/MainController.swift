//
//  MainController.swift
//  Take-Off
//
//  Created by Jun on 2020/06/18.
//  Copyright © 2020 Jun. All rights reserved.
//

import UIKit
import FSPagerView
import Firebase

class MainController: UIViewController, FSPagerViewDelegate, FSPagerViewDataSource {
    
    
    var imageNames: Array<Any> = []
    fileprivate let adNames = ["광1.png", "광2.png", "광3.png"]
    
    func uploadNewPost() {
        let ref = Storage.storage().reference().child("posts/")
        ref.getData(maxSize: 1 * 1024 * 1024) { (data, err) in
            if let err = err {
                print(err)
                return
            }
            let image = UIImage(data: data!)
            self.imageNames.append(image as Any)
            if self.imageNames.count == 5 {
                return
            }
        }
    }
    
    
    private lazy var hotPostView: FSPagerView = {
        let pagerView = FSPagerView()
        pagerView.delegate = self
        pagerView.dataSource = self
        //자동스크롤
        pagerView.automaticSlidingInterval = 3
        //무한 스크롤 설정
        pagerView.isInfinite = true
        //뷰의 스타일
        pagerView.transformer = FSPagerViewTransformer(type: .ferrisWheel)
        //셀 등록
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        return pagerView
    }()
    
    private lazy var adView: FSPagerView = {
        let pagerView = FSPagerView()
        pagerView.delegate = self
        pagerView.dataSource = self
        //자동스크롤
        pagerView.automaticSlidingInterval = 5
        //무한 스크롤 설정
        pagerView.isInfinite = true
        //뷰의 스타일
        pagerView.transformer = FSPagerViewTransformer(type: .crossFading)
        //셀 등록
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        return pagerView
    }()
    
    private lazy var pagerControl: FSPageControl = {
        let pagerControl = FSPageControl()
        pagerControl.numberOfPages = self.imageNames.count
        pagerControl.contentHorizontalAlignment = .center
        pagerControl.itemSpacing = 16
        pagerControl.interitemSpacing = 16
       return pagerControl
    }()
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        if pagerView == hotPostView { return imageNames.count }
        else { return adNames.count }
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        if pagerView == hotPostView {
            cell.imageView?.image = UIImage(named: self.imageNames[index] as! String)
            cell.imageView?.contentMode = .scaleAspectFill
        }
        else {
            cell.imageView?.image = UIImage(named: self.adNames[index])
            cell.imageView?.contentMode = .scaleAspectFit
        }
        
        return cell
    }
    
    
    @objc func handleHome() {
        let homeController = HomeController(collectionViewLayout: UICollectionViewFlowLayout())
        let navController = UINavigationController(rootViewController: homeController)
        self.present(navController, animated:  true, completion: nil)    }
    
    let backgroundView: UIView = {
        let view = UIImageView(image: UIImage(named: "background"))
        return view
    }()

    override func viewDidLoad() {
        uploadNewPost()
        setupNavigationItems()
        self.view.backgroundColor = .white
        view.addSubview(backgroundView)
        backgroundView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        let searchBarButton = UIButton(type: .system)
        searchBarButton.setImage(UIImage(named: "searchBar")?.withRenderingMode(.alwaysOriginal), for: .normal)
        searchBarButton.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
                self.view.addSubview(searchBarButton)
        searchBarButton.translatesAutoresizingMaskIntoConstraints = false
        searchBarButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        searchBarButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 5).isActive = true
        searchBarButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5).isActive = true
        
        let megazineLabel = UILabel()
        megazineLabel.text = "Today's Hottest🔥"
        megazineLabel.textColor = .black
        megazineLabel.numberOfLines = 0
        megazineLabel.font = UIFont.boldSystemFont(ofSize: 25)
        view.addSubview(megazineLabel)
        megazineLabel.translatesAutoresizingMaskIntoConstraints = false
        megazineLabel.topAnchor.constraint(equalTo: searchBarButton.bottomAnchor, constant: 10).isActive = true
        megazineLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true

        let moreButton = UIButton(type: .system)
        moreButton.setTitle("more+", for: .normal)
        moreButton.tintColor = .black
        moreButton.addTarget(self, action: #selector(handleHome), for: .touchUpInside)
        self.view.addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.topAnchor.constraint(equalTo: searchBarButton.bottomAnchor, constant: 14).isActive = true
        moreButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
        
        self.view.addSubview(hotPostView)
        hotPostView.anchor(top: megazineLabel.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: self.view.frame.width, height: self.view.frame.height / 2)
        
        self.view.addSubview(adView)
        adView.anchor(top: hotPostView.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 0, height: 0)
    }
    
    @objc func handleSearch() {
        let userSearchController = UserSearchController(collectionViewLayout: UICollectionViewFlowLayout())
        let navController = UINavigationController(rootViewController: userSearchController)
        self.present(navController, animated:  true, completion: nil)
    }
    
    func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "home_logo"))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera3")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
    }
    
    @objc func handleCamera() {
        let cameraController = CameraController()
        present(cameraController, animated: true, completion: nil)
    }
    
    
}
