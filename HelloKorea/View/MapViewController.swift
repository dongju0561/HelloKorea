import UIKit
import MapKit
import CoreLocation
import Then

class MapViewController: UIViewController {
    var contentsModelTest: ContentsModelTest?
    private var artworks = [Artwork]()
    private var tagNumOfAnnotation = 0
    private var pickerView = UIPickerView().then{
        $0.backgroundColor = .gray
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private var mapView = MKMapView().then{
        $0.mapType = MKMapType.standard
        $0.isZoomEnabled = true
        $0.isScrollEnabled = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
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
                    coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude),
                    address: location.address
                )
            )
        }
        initSubView()
        bindViewModel()
    }
    
    func bindViewModel() {
        guard let locations = contentsModelTest?.locations else{
            return
        }
        makePin(locations)
        initSetLocation(locations)
    }
    
    func initSubView() {
        view.addSubview(pickerView)
        view.addSubview(mapView)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        mapView.delegate = self
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: pickerView.topAnchor),
            
            pickerView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            pickerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pickerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            pickerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            pickerView.heightAnchor.constraint(equalToConstant: 100),
            pickerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width),
        ])
    }
    
    //지도에 등록된 위치에 핀들을 꽂아주는 함수
    func makePin(_ data : [Location]) {
        for index in 0..<data.count{
            let artwork = Artwork(
                title: data[index].locationName,
                locationName: data[index].explaination,
                discipline: "Sculpture",
                coordinate: CLLocationCoordinate2D(latitude: data[index].latitude, longitude: data[index].longitude), 
                address: data[index].address
            )
            mapView.addAnnotation(artwork)
        }
    }
    
    //초기 지도 위치 설정 함수
    func initSetLocation(_ data : [Location]) {
        let initialLocation = CLLocation(latitude: data[0].latitude, longitude: data[0].longitude)
        mapView.setLocation(initialLocation)
    }
}

extension MapViewController: MKMapViewDelegate{
    //지도의 표시 영역이 변경되기 직전에 호출
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        if let selectedAnnotations = mapView.selectedAnnotations as? [MKPointAnnotation], let selectedAnnotation = selectedAnnotations.first {
            mapView.deselectAnnotation(selectedAnnotation, animated: true)
        }
    }
    
    //annotation 정의하는 메소드
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        guard let annotation = annotation as? Artwork else {
            return nil
        }
        annotation.tag
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
            let  detailButton = UIButton(type: .detailDisclosure)
            detailButton.addTarget(self, action: #selector(showDetail), for: .touchUpInside)
            
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.tag = tagNumOfAnnotation
            tagNumOfAnnotation += 1
            view.canShowCallout = true // callout를 보여줌
            view.calloutOffset = CGPoint(x: 0, y: 0) // callout의 위치
            view.leftCalloutAccessoryView = detailButton
            view.markerTintColor = .purple
            configureDetailView(annotationView: view)
            
            if let safeLocationName = artworks[view.tag].locationName, let safeAddress = artworks[view.tag].address {
                let customCalloutView = CustomCalloutView()
                let views = ["customCalloutView": customCalloutView]
                customCalloutView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[customCalloutView(300)]", options: [], metrics: nil, views: views))
                customCalloutView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[customCalloutView(200)]", options: [], metrics: nil, views: views))
                customCalloutView.configure(explanation: safeLocationName, address: safeAddress)
                view.detailCalloutAccessoryView = customCalloutView
            }
        }
        return view
    }
    
    //추가 기능 제공을 위한 modal present하는 함수
    @objc func showDetail(_ sender: UIButton){
        if mapView.selectedAnnotations.first is Artwork {
            
            let modal = DetailModalViewController()
            modal.contentName = contentsModelTest?.contentName
            modal.annotation = (mapView.selectedAnnotations.first as! Artwork)
            self.present(modal,animated: true)
        }
    }
}

// MARK: - UITableViewDataSource 메서드
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
        let latitude = safeContent.locations[row].latitude
        let longitude = safeContent.locations[row].longitude
        
        // Create a new coordinate for the center of the map
        let newRegion = CLLocation(latitude: latitude, longitude: longitude)

        // Move the map to the new region, with animation
        mapView.setLocation(newRegion)
    }
    
}



