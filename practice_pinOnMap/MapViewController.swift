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
        
        mapKit.delegate = self
        
        let location = contentsData?.locations
        let initialLocation = CLLocation(latitude: (location?[0].latitude)!, longitude: (location?[0].longitude)!)
        //초기 지도 위치
        mapKit.centerToLocation(initialLocation)
        mapKit.annotations(in: MKMapRect(x: 10.10, y: 10.10, width: 100, height: 100))
        for index in 0..<(contentsData?.locations.count)!{
            let artwork = Artwork(
                title: location?[index].locationName,
                locationName: location?[index].explaination,
                discipline: "Sculpture",
                coordinate: CLLocationCoordinate2D(latitude: (location?[index].latitude)!, longitude: (location?[index].longitude)!))
            
            mapKit.addAnnotation(artwork)
        }
    }
}

extension MapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.image = UIImage(named: "marker_gray")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation)
    -> MKAnnotationView?{
        // 2
        guard let annotation = annotation as? Artwork else {
          return nil
        }
        // 3
        let identifier = "artwork"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(
          withIdentifier: identifier) as? MKMarkerAnnotationView {
          dequeuedView.annotation = annotation
          view = dequeuedView
        } else {
          // 5
          view = MKMarkerAnnotationView(
            annotation: annotation,
            reuseIdentifier: identifier)
          view.canShowCallout = true
          view.calloutOffset = CGPoint(x: -5, y: 5)
          view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
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

