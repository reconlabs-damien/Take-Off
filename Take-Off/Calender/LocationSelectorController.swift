//
//  LocationSelectorController.swift
//  Take-Off
//
//  Created by Jun on 2020/10/09.
//  Copyright © 2020 Jun. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationSelectorController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var addListController: AddListController?
    
    private let mapkit: MKMapView = {
       let mk = MKMapView()
        mk.mapType = MKMapType.standard
        mk.showsUserLocation = true
        mk.setUserTrackingMode(.follow, animated: true)
        return mk
    }()
    
    private let searchTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "조회를 원하는 구 이름을 입력하세요"
        tf.tintColor = .black
        tf.layer.borderColor = UIColor.black.cgColor
        tf.backgroundColor = .white
        return tf
    }()
    
    private let searchButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "search_selected"), for: .normal)
        bt.addTarget(self, action: #selector(clickSearchButton), for: .touchUpInside)
        return bt
    }()
    
    @objc func clickSearchButton() {
        self.addressLabel.text = self.searchTextField.text
        
        switch addressLabel.text {
        case "도봉구":
            self.setMapView(coordinate: self.dobongLoc, addr: "도봉구")
        case "은평구":
            self.setMapView(coordinate: self.eunpyeongLoc, addr: "은평구")
        case "동대문구":
            self.setMapView(coordinate: self.dongdaemoonLoc, addr: "동대문구")
        case "동작구":
            self.setMapView(coordinate: self.dongjakLoc, addr: "동작구")
        case "금천구":
            self.setMapView(coordinate: self.geumcheonLoc, addr: "금천구")
        case "구로구":
            self.setMapView(coordinate: self.guroLoc, addr: "구로구")
        case "종로구":
            self.setMapView(coordinate: self.jongnoLoc, addr: "종로구")
        case "강북구":
           self.setMapView(coordinate: self.gangbukLoc, addr: "강북구")
        case "중랑구":
            self.setMapView(coordinate: self.jungnangLoc, addr: "중랑구")
        case "강남구":
            self.setMapView(coordinate: self.gangnamLoc, addr: "강남구")
        case "강서구":
            self.setMapView(coordinate: self.gangseoLoc, addr: "강서구")
        case "중구":
            self.setMapView(coordinate: self.jungLoc, addr: "중구")
        case "강동구":
            self.setMapView(coordinate: self.gangdongLoc, addr: "강동구")
        case "광진구":
            self.setMapView(coordinate: self.gwangjinLoc, addr: "광진구")
        case "마포구":
            self.setMapView(coordinate: self.mapoLoc, addr: "마포구")
        case "서초구":
            self.setMapView(coordinate: self.seochoLoc, addr: "서초구")
        case "성북구":
            self.setMapView(coordinate: self.seongbukLoc, addr: "성북구")
        case "노원구":
            self.setMapView(coordinate: self.nowonLoc, addr: "노원구")
        case "송파구":
            self.setMapView(coordinate: self.songpaLoc, addr: "송파구")
        case "서대문구":
            self.setMapView(coordinate: self.seoudaemoonLoc, addr: "서대문구")
        case "양천구":
            self.setMapView(coordinate: self.yangcheonLoc, addr: "양천구")
        case "영등포구":
            self.setMapView(coordinate: self.yeongdeungpoLoc, addr: "영등포구")
        case "관악구":
            self.setMapView(coordinate: self.gwanakLoc, addr: "관악구")
        case "성동구":
            self.setMapView(coordinate: self.seongdongLoc, addr: "성동구")
        case "용산구":
            self.setMapView(coordinate: self.yongsanLoc, addr: "용산구")
        default:
            let alert = UIAlertController(title: "잘못된 주소입니다.", message: "정확한 주소를 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        self.searchTextField.text = ""
    }
    
    private let addressLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .white
        lb.textColor = .black
        lb.tintColor = .black
        return lb
    }()
    
    private let addressDetailLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .white
        lb.textColor = .black
        lb.tintColor = .black
        lb.font = UIFont.systemFont(ofSize: 20)
        return lb
    }()
    
    private let aqiStatusLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .white
        lb.textColor = .black
        lb.tintColor = .black
        lb.font = UIFont.systemFont(ofSize: 20)
        return lb
    }()
    
    private let timeLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .white
        lb.textColor = .black
        lb.tintColor = .black
        lb.font = UIFont.systemFont(ofSize: 20)
        return lb
    }()
    
    private let resetLocation: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "location-pin"), for: .normal)
        bt.addTarget(self, action: #selector(handleResetLocation), for: .touchUpInside)
        return bt
    }()
    
    
    let dobongLoc = CLLocationCoordinate2D(latitude: 37.6658609, longitude: 127.0317674) // 도봉구
    let eunpyeongLoc = CLLocationCoordinate2D(latitude: 37.6176125, longitude: 126.9227004) // 은평구
    let dongdaemoonLoc = CLLocationCoordinate2D(latitude: 37.5838012, longitude: 127.0507003) // 동대문구
    let dongjakLoc = CLLocationCoordinate2D(latitude: 37.4965037, longitude: 126.9443073) // 동작구
    let geumcheonLoc = CLLocationCoordinate2D(latitude: 37.4600969, longitude: 126.9001546) // 금천구
    let guroLoc = CLLocationCoordinate2D(latitude: 37.4954856, longitude: 126.858121) // 구로구
    let jongnoLoc = CLLocationCoordinate2D(latitude: 37.5990998, longitude: 126.9861493) // 종로구
    let gangbukLoc = CLLocationCoordinate2D(latitude: 37.6469954, longitude: 127.0147158) // 강북구
    let jungnangLoc = CLLocationCoordinate2D(latitude: 37.5953795, longitude: 127.0939669) // 중랑구
    let gangnamLoc = CLLocationCoordinate2D(latitude: 37.4959854, longitude: 127.0664091) // 강남구
    let gangseoLoc = CLLocationCoordinate2D(latitude: 37.5657617, longitude: 126.8226561) // 강서구
    let jungLoc = CLLocationCoordinate2D(latitude: 37.5579452, longitude: 126.9941904) // 중구
    let gangdongLoc = CLLocationCoordinate2D(latitude: 37.5492077, longitude: 127.1464824) // 강동구
    let gwangjinLoc = CLLocationCoordinate2D(latitude: 37.5481445, longitude: 127.0857528) // 광진구
    let mapoLoc = CLLocationCoordinate2D(latitude: 37.5622906, longitude: 126.9087803) // 마포구
    let seochoLoc = CLLocationCoordinate2D(latitude: 37.4769528, longitude: 127.0378103) // 서초구
    let seongbukLoc = CLLocationCoordinate2D(latitude: 37.606991, longitude: 127.0232185) // 성북구
    let nowonLoc = CLLocationCoordinate2D(latitude: 37.655264, longitude: 127.0771201) // 노원구
    let songpaLoc = CLLocationCoordinate2D(latitude: 37.5048534, longitude: 127.1144822) // 송파구
    let seoudaemoonLoc = CLLocationCoordinate2D(latitude: 37.5820369, longitude: 126.9356665) // 서대문구
    let yangcheonLoc = CLLocationCoordinate2D(latitude: 37.5270616, longitude: 126.8561534) // 양천구
    let yeongdeungpoLoc = CLLocationCoordinate2D(latitude: 37.520641, longitude: 126.9139242) // 영등포구
    let gwanakLoc = CLLocationCoordinate2D(latitude: 37.4653993, longitude: 126.9438071) // 관악구
    let seongdongLoc = CLLocationCoordinate2D(latitude: 37.5506753, longitude: 127.0409622) // 성동구
    let yongsanLoc = CLLocationCoordinate2D(latitude: 37.5311008, longitude: 126.9810742) // 용산구
    
    var aqiDataSet = [AqiResponseString]()
    
    @objc func handleResetLocation() {
        self.mapkit.showsUserLocation = true
        self.mapkit.setUserTrackingMode(.follow, animated: true)
    }
    
    
    var locationManager: CLLocationManager = CLLocationManager()
    weak var currentLocation: CLLocation!
    weak var searchLocation : CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(searchTextField)
        view.addSubview(searchButton)
        view.addSubview(mapkit)
        view.addSubview(resetLocation)
        view.addSubview(addressLabel)
        view.addSubview(addressDetailLabel)
        view.addSubview(aqiStatusLabel)
        view.addSubview(timeLabel)
        
        searchTextField.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        searchButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: searchTextField.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        mapkit.anchor(top: searchTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: view.frame.height / 3 * 2)
        
        resetLocation.anchor(top: mapkit.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: -20, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 20, height: 20)
        addressDetailLabel.anchor(top: mapkit.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 0)
        aqiStatusLabel.anchor(top: addressDetailLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 0)
        timeLabel.anchor(top: aqiStatusLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 0)
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        setupNavigationItems()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted {
                let alert = UIAlertController(title: "오류 발생", message: "위치서비스 기능이 꺼져있음", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
            }
        } else {
            let alert = UIAlertController(title: "오류 발생", message: "위치서비스 제공 불가", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            self.firstSetting()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager = manager
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse :
            firstSetting()
            break
        case .authorizedAlways :
            firstSetting()
            break
        case .restricted :
            break
        case .denied :
            break
        default:
            break
        }
    }
    
    func firstSetting(){
        self.currentLocation = locationManager.location
        self.findAddr(lat: self.currentLocation.coordinate.latitude, long: self.currentLocation.coordinate.longitude)
    }
    
    func findAddr(lat: CLLocationDegrees, long: CLLocationDegrees) {
        let findLocation = CLLocation(latitude: lat, longitude: long)
        let geoCoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        geoCoder.reverseGeocodeLocation(findLocation, preferredLocale: locale) { (placemarks, err) in
            if let address: [CLPlacemark] = placemarks {
                var myAdd: String = ""
                if let area: String = address.last?.locality {
                    myAdd += area
                    self.addressLabel.text = area
                    self.connectAqiAPI(region: area)
                }
                
                if let name: String = address.last?.name {
                    myAdd += " "
                    myAdd += name
                }
                self.addressDetailLabel.text = myAdd
            }
            
        }
        
    }
    
    func setupNavigationItems() {
        //왼쪽 버튼 설정
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "cancel_shadow"), style: .plain, target: self, action: #selector(handleCancel))
        //왼쪽 버튼 컬러지정
        navigationItem.leftBarButtonItem?.tintColor = .orange
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "send2"), style: .plain, target: self, action: #selector(handleConfirm))
    }
    
    @objc func handleConfirm() {
        let locationCV = AddListController()
        locationCV.locationTextField.text = addressDetailLabel.text
        let navController = UINavigationController(rootViewController: locationCV)
        
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
        
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setMapView(coordinate: CLLocationCoordinate2D, addr: String) {
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta:0.01, longitudeDelta:0.01))
        self.mapkit.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = addr
        self.mapkit.addAnnotation(annotation)
        
        self.findAddr(lat: coordinate.latitude, long: coordinate.longitude)
    }
    
    func connectAqiAPI(region: String){
        let aqiURLString = AqiService.shared.makeAqiAddress(region: region)
        let aqiURL = URL(string: aqiURLString)!
        
        do {
            let responseString = try String(contentsOf: aqiURL)
            guard let data = responseString.data(using: .utf8) else { return }
            let decoder = JSONDecoder()
            if let object = try? decoder.decode(AqiResponseString.self, from: data) {
                self.aqiDataSet = [object]
                let aqi10Str = self.getPm10String(pm10: self.aqiDataSet[0].list![0].pm10Value!)
                self.aqiStatusLabel.text = "현재 대기 상태는 " + aqi10Str + "입니다."
                self.timeLabel.text = self.aqiDataSet[0].list![0].dataTime! + " 기준"
            }
        } catch let e as NSError {
            print(e.localizedDescription)
        }
    }
    
    func getPm10String(pm10: String) -> String {
        guard let pm10Int = Int(pm10) else { return "정보 없음" }
        var pm10Str: String = ""
        
        switch pm10Int {
        case let x where x <= 30 :
            pm10Str = "좋음"
        case let x where x <= 80 :
            pm10Str = "보통"
        case let x where x <= 150 :
            pm10Str = "나쁨"
        default:
            pm10Str = "매우 나쁨"
        }
        return pm10Str
    }
    
    
}

