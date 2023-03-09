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
    
    var contentsData: ContentsData?
    //layout for view
    
    //pickerView property
    private var pickerView: UIPickerView = {
       
        var pickerView = UIPickerView()
        pickerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 100)
        pickerView.backgroundColor = .gray
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    //mapView property
    private var mapView : MKMapView = {
        var map = MKMapView()
        
        map.mapType = MKMapType.standard
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.translatesAutoresizingMaskIntoConstraints = false
        
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let location = contentsData?.locations
        
        view.addSubview(pickerView)
        view.addSubview(mapView)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        mapView.delegate = self
        
        NSLayoutConstraint.activate([
            
            pickerView.topAnchor.constraint(equalTo: view.topAnchor),
            pickerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            pickerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            mapView.topAnchor.constraint(equalTo: pickerView.bottomAnchor),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        makePin(location!)
        initSetLocation(location!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    func makePin(_ data : [Location]) {
        for index in 0..<data.count{
            let artwork = Artwork(
                title: data[index].locationName,
                locationName: data[index].explaination,
                discipline: "Sculpture",
                coordinate: CLLocationCoordinate2D(latitude: data[index].latitude, longitude: data[index].longitude))
            
            mapView.addAnnotation(artwork)
        }
    }
    
    //초기 지도 위치
    func initSetLocation(_ data : [Location]) {
        // Define the initial location
        let initialLocation = CLLocation(latitude: data[0].latitude, longitude: data[0].longitude)

        // Set the map view to display the region
        mapView.setLocation(initialLocation)
    }
    
}


extension MapViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        guard let annotation = annotation as? Artwork else {
          return nil
        }
        
        let identifier = "artwork"
        var view: MKMarkerAnnotationView
    
        if let dequeuedView = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier) as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
          
            let  detailButton = UIButton(type: .detailDisclosure)
            detailButton.addTarget(self, action: #selector(pressDetail), for: .touchUpInside)
            view = MKMarkerAnnotationView(annotation: annotation,reuseIdentifier: identifier)
            view.canShowCallout = true // display extra information
            view.calloutOffset = CGPoint(x: 0, y: 0) // the position of information balloon
            view.rightCalloutAccessoryView = detailButton
            view.markerTintColor = .purple
        }
        
        return view
    }
    
    @objc func pressDetail(_ sender: UIButton!){
        print("hello")
        mapView.annotations(in: MKMapRect(x: 10.10, y: 10.10, width: 100, height: 100))
    }
}

extension MapViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return contentsData?.locations.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return contentsData?.locations[row].locationName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //moving to the  place
        let latitude = contentsData?.locations[row].latitude ?? 0
        let longitude = contentsData?.locations[row].longitude ?? 0
        
        // Create a new coordinate for the center of the map
        let newRegion = CLLocation(latitude: latitude, longitude: longitude)

        // Move the map to the new region, with animation
        mapView.setLocation(newRegion)
    }
}


private extension MKMapView {
    //기존에 있는에 메소드의 argument를 extend operator를 사용하여 상수를 입력해줄 수 있다.
    func setLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        
        let coordinateRegion = MKCoordinateRegion( center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
  }
}

