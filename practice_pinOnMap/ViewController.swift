//
//  ViewController.swift
//  practice_pinOnMap
//
//  Created by Dongju Park on 2023/01/31.
//

//첫번째 goal 내가 원하는 위치에 핀 꽂기

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    var Aobject = A(age: 30)
    
    @IBOutlet weak var mapKit: MKMapView!
    private var initialLocation = CLLocation(latitude: 37.5666805, longitude: 126.9784147)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //초기 지도 위치
        mapKit.centerToLocation(initialLocation)
        
        let artwork = Artwork(
          title: "King David Kalakaua",
          locationName: "Waikiki Gateway Park",
          discipline: "Sculpture",
          coordinate: CLLocationCoordinate2D(latitude: 37.5666805, longitude: 126.9784147))
        
        let artwork1 = Artwork(
          title: "King David Kalakauartyuiop[",
          locationName: "Waikiki Gateway Park",
          discipline: "Sculpture",
          coordinate: CLLocationCoordinate2D(latitude: 37.565758, longitude: 126.974801))
        
        mapKit.addAnnotation(artwork)
        mapKit.addAnnotation(artwork1)
        
    }

}


private extension MKMapView {
  func centerToLocation(
    //기존에 있는에 메소드의 argument를 extend operator를 사용하여 상수를 입력해줄 수 있다.
    _ location: CLLocation, regionRadius: CLLocationDistance = 3000) {
    let coordinateRegion = MKCoordinateRegion( center: location.coordinate,
                                               latitudinalMeters: regionRadius,
                                               longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}

