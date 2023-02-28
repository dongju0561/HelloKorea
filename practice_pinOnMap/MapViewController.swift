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

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapKit: MKMapView!
    
    var contentsData: ContentsData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let location = contentsData?.locations
        let initialLocation = CLLocation(latitude: (location?[0].latitude)!, longitude: (location?[0].longitude)!)
        //초기 지도 위치
        mapKit.centerToLocation(initialLocation)
        
        for a in 0..<(contentsData?.locations.count)!{
            let artwork = Artwork(
              title: "King David Kalakaua",
              locationName: "Waikiki Gateway Park",
              discipline: "Sculpture",
              coordinate: CLLocationCoordinate2D(latitude: (location?[a].latitude)!, longitude: (location?[a].longitude)!))
            
            mapKit.addAnnotation(artwork)
            
            print((location?[a].explaination)!)
        }
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

