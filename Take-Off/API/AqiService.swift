//
//  AqiService.swift
//  Take-Off
//
//  Created by Jun on 2020/10/19.
//  Copyright © 2020 Jun. All rights reserved.
//

import Foundation

class AqiService {
    static let shared = AqiService()
    
    static let aqiKey = "yPNAApocMDtWisXB65oBXC41r48AKcNH3sTVc09ZzZGjs%2BDaWGZK3a%2BMKDC5CdnXfCG6UJ7pR%2F3y5f0mFOdzOQ%3D%3D"
    static let aqiAddress1 = "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty?stationName="
    static let aqiAddress2 = "&dataTerm=month&pageNo=1&numOfRows=10&ServiceKey=g5wuVXrLzJMBI9kR2gmdXm6ltsn0zYEicoOG7g2xNHZnGZVp9v7znsIO45M2l7R6rlE5wiD%2FjtIZupMYvyN2Pg%3D%3D&ver=1.3&_returnType=json"
    
    static let weatherAddress1 = "api.openweathermap.org/data/2.5/weather?lat="
    static let weatherAddress2 = "&appid=853c909f0f8639d63344ec1b9f73c12a"
    
    
    // MARK : 한글 인코딩
    func makeStringKoreanEncoded(_ string: String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? string
    }
    
    // MARK : 한글 인코딩된 url 주소 변환
    func makeAqiAddress(region: String) -> String {
        let encodedRegion = makeStringKoreanEncoded(region)
        let encodedURL = AqiService.aqiAddress1 + encodedRegion + AqiService.aqiAddress2
        return encodedURL
    }
    
    // MARK : 날씨 url 주소 반환
    func makeWeatherAddrress(lat: String, lon: String) -> String {
        let weatherURL = AqiService.weatherAddress1 + lat + "&lon=" + lon + AqiService.weatherAddress2
        return weatherURL
    }
    
}
