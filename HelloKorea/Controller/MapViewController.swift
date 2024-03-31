import UIKit
import MapKit
import CoreLocation
import Then

class MapViewController: UIViewController {
    
    // MARK: - Property
    
    var contentsModelTest: ContentsModelTest?
    
    var artworks = [Artwork]()
    
    var tagNumOfAnnotation = 0
    
    var mapView = MapView()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let locations = contentsModelTest?.locations else{
            return
        }
        for location in locations {
            artworks.append(
                Artwork(
                    title: location.locationName,
                    locationName: location.explaination,
                    discipline: "Sculpture",
                    coordinate: location.coordinate,
                    address: location.address
                )
            )
        }
        setup()
        mapView.initSubView()
        setupPin()
    }
    
    //: MARK: - View Methodes
    
    override func loadView() {
        view = mapView
    }
    
    func setupPin() {
        guard let locations = contentsModelTest?.locations else{
            return
        }
        makePin(locations)
        initSetLocation(locations)
    }
    
    func setup() {
        
        mapView.pickerView.delegate = self
        mapView.pickerView.dataSource = self
        mapView.mapView.delegate = self
        
    }
    
    //지도에 등록된 위치에 핀들을 꽂아주는 함수
    func makePin(_ datas : [Location]) {
        for index in 0..<datas.count{
            let artwork = Artwork(
                title: datas[index].locationName,
                locationName: datas[index].explaination,
                discipline: "Sculpture",
                coordinate: datas[index].coordinate,
                address: datas[index].address
            )
            mapView.mapView.addAnnotation(artwork)
        }
    }
    
    //초기 지도 위치 설정 함수
    func initSetLocation(_ data : [Location]) {
        let initialLocation = CLLocation(
            latitude: data[0].coordinate.latitude,
            longitude: data[0].coordinate.longitude
        )
        mapView.mapView.setLocation(initialLocation)
    }
    
}

// MARK: - MapKitViewDelegate

extension MapViewController: MKMapViewDelegate{
    //지도의 표시 영역이 변경되기 직전에 호출
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        if let selectedAnnotations = mapView.selectedAnnotations as? [MKPointAnnotation], 
            let selectedAnnotation = selectedAnnotations.first {
            mapView.deselectAnnotation(selectedAnnotation, animated: true)
        }
    }
    
    //annotation 정의하는 메소드
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        guard let annotation = annotation as? Artwork else {
            return nil
        }
        let identifier = "artwork"
        var view: MKMarkerAnnotationView
        //만약 재사용 가능한 annotation view가 있다면
        if let dequeuedView = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier) as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } 
        //만약 재사용 가능한 annotation view가 없다면
        else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.tag = tagNumOfAnnotation
            tagNumOfAnnotation += 1
            view.canShowCallout = true // callout를 보여줌
            view.calloutOffset = CGPoint(x: 0, y: 0) // callout의 위치
            view.markerTintColor = .purple
            
            
            if let safeLocationName = artworks[view.tag].locationName, let safeAddress = artworks[view.tag].address {
                let DetailCustomCalloutView = DetailCustomCalloutView()
                let views = ["customCalloutView": DetailCustomCalloutView]
                DetailCustomCalloutView.addConstraints(NSLayoutConstraint.constraints(
                    withVisualFormat: "H:[customCalloutView(300)]", options: [], metrics: nil, views: views)
                )
                DetailCustomCalloutView.addConstraints(NSLayoutConstraint.constraints(
                    withVisualFormat: "V:[customCalloutView(200)]", options: [], metrics: nil, views: views)
                )
                DetailCustomCalloutView.configure(explanation: safeLocationName, address: safeAddress)
                DetailCustomCalloutView.detailButton.addTarget(self, action: #selector(showDetail), for: .touchUpInside)
                view.detailCalloutAccessoryView = DetailCustomCalloutView
            }
        }
        return view
    }
    
    //추가 기능 제공을 위한 modal present하는 함수
    @objc func showDetail(_ sender: UIButton){
        if mapView.mapView.selectedAnnotations.first is Artwork {
            
            let modal = DetailModalViewController()
            modal.contentName = contentsModelTest?.contentName
            modal.annotation = (mapView.mapView.selectedAnnotations.first as! Artwork)
            self.present(modal,animated: true)
        }
    }
    
}

// MARK: - UIPickerViewDelegate UITableViewDataSource

extension MapViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let safeContent = contentsModelTest else {
            return 0
        }
        return safeContent.locations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let safeContent = contentsModelTest else {
            return ""
        }
        return safeContent.locations[row].locationName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let safeContent = contentsModelTest else {
            return
        }
        
        //moving to the  place
        let coordinate = safeContent.locations[row].coordinate
        
        // Create a new coordinate for the center of the map
        let newRegion = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        // Move the map to the new region, with animation
        mapView.mapView.setLocation(newRegion)
    }
    
}
