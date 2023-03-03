//
//  DataStructure.swift
//  practice_pinOnMap
//
//  Created by Dongju Park on 2023/02/23.
//

import UIKit
import CoreLocation

var data = [
    ContentsData(contentName: "이태원 클라쓰", image: #imageLiteral(resourceName: "itaewon"), locations: [
        Location(locationName: "이태원 클라쓰 육교", explaination: "이태원클라스 육교", latitude: 37.534934586721285, longitude: 126.98705368624344),
        Location(locationName: "단밤 1호점", explaination: "단밤 1호점!!", latitude: 37.53452700304139, longitude: 126.98819083115725),
        Location(locationName: "단밤 2호점", explaination: "장회장에게 1호점을 뺏기고 그 다음 오픈한 가게", latitude: 37.54740180539392, longitude: 126.98405841682904),
    ]),
    ContentsData(contentName: "일타 스캔들", image: #imageLiteral(resourceName: "ilta"), locations: [
        Location(locationName: "국가대표 반찬가게", explaination: "전도연 반찬가게 국가대표 반찬가게", latitude: 36.64640328251355, longitude: 127.47581734218825),
        Location(locationName: "학원가", explaination: "남해이와 이선재가 다니는 학원가", latitude: 37.52578251337396, longitude: 126.86873982482805),
        Location(locationName: "남해이와 이선재가 다닌 학교", explaination: "중앙대학교 사범대학 부속고등학교", latitude: 37.491355643258416, longitude: 127.05235163108524),
    ]),
    ContentsData(contentName: "나의 아저씨", image: #imageLiteral(resourceName: "my"), locations: [
        Location(locationName: "단밤 1호점", explaination: "박새로이가 처음 가게를 오픈한 위치", latitude: 37.5666805, longitude: 126.9784147),
        Location(locationName: "단밤 2호점", explaination: "장회장에게 1호점을 뺏기고 그 다음 오픈한 가게", latitude: 37.565758, longitude: 126.974801),
    ]),
    ContentsData(contentName: "기생충", image: #imageLiteral(resourceName: "para"), locations: [
        Location(locationName: "단밤 1호점", explaination: "박새로이가 처음 가게를 오픈한 위치", latitude: 37.5666805, longitude: 126.9784147),
        Location(locationName: "단밤 2호점", explaination: "장회장에게 1호점을 뺏기고 그 다음 오픈한 가게", latitude: 37.565758, longitude: 126.974801),
    ]),
    ContentsData(contentName: "솔로지옥2", image: #imageLiteral(resourceName: "solo"), locations: [
        Location(locationName: "단밤 1호점", explaination: "박새로이가 처음 가게를 오픈한 위치", latitude: 37.5666805, longitude: 126.9784147),
        Location(locationName: "단밤 2호점", explaination: "장회장에게 1호점을 뺏기고 그 다음 오픈한 가게", latitude: 37.565758, longitude: 126.974801),
    ]),
    ContentsData(contentName: "나의 아저씨", image: #imageLiteral(resourceName: "island"), locations: [
        Location(locationName: "단밤 1호점", explaination: "박새로이가 처음 가게를 오픈한 위치", latitude: 37.5666805, longitude: 126.9784147),
        Location(locationName: "단밤 2호점", explaination: "장회장에게 1호점을 뺏기고 그 다음 오픈한 가게", latitude: 37.565758, longitude: 126.974801),
    ])
]

struct Data {
    var contents: [ContentsData]
    
    init(contents: [ContentsData]) {
        self.contents = contents
    }
}

struct ContentsData {
    var contentName: String
    var image: UIImage
    var locations: [Location]
    
    init(contentName: String, image: UIImage, locations: [Location]) {
        self.contentName = contentName
        self.image = image
        self.locations = locations
    }
}

struct Location {
    var locationName: String
    var explaination: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    
    init(locationName: String, explaination: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.locationName = locationName
        self.explaination = explaination
        self.latitude = latitude
        self.longitude = longitude
    }
}
