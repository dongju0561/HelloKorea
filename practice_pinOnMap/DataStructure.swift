//
//  DataStructure.swift
//  practice_pinOnMap
//
//  Created by Dongju Park on 2023/02/23.
//

import UIKit

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
    var latitude: Float
    var longitude: Float
    
    init(locationName: String, explaination: String, latitude: Float, longitude: Float) {
        self.locationName = locationName
        self.explaination = explaination
        self.latitude = latitude
        self.longitude = longitude
    }
}
