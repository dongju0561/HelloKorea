//
//  Artwork.swift
//  practice_pinOnMap
//
//  Created by Dongju Park on 2023/01/31.
//

import Foundation
import MapKit

//MKAnnotation은 NSObject를 사용하기 때문이다.

class Artwork: NSObject, MKAnnotation {
    let title: String?
    let locationName: String?
    let discipline: String?
    let coordinate: CLLocationCoordinate2D

    init(
    title: String?,
    locationName: String?,
    discipline: String?,
    coordinate: CLLocationCoordinate2D)
    {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate

        super.init() //
    }

    var subtitle: String? {
        return locationName
    }
}
