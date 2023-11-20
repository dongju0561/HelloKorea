import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    var contentViewModel: ContentsModel?
    
    private var pickerView: UIPickerView = {
       
        var pickerView = UIPickerView()
        pickerView.backgroundColor = .gray
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
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
        initSubView()
        bindViewModel()
    }
    func bindViewModel() {
        let location = contentViewModel?.locations
        makePin(location!)
        initSetLocation(location!)
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
            mapView.bottomAnchor.constraint(equalTo: mapView.topAnchor),
            
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
                address: data[index].address)
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
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
            if let selectedAnnotations = mapView.selectedAnnotations as? [MKPointAnnotation], let selectedAnnotation = selectedAnnotations.first {
                mapView.deselectAnnotation(selectedAnnotation, animated: true)
            }
        }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        guard let annotation = annotation as? Artwork else {
          return nil
        }
        
        //
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
            detailButton.addTarget(self, action: #selector(copyAddress), for: .touchUpInside)

            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true // callout를 보여줌
            view.calloutOffset = CGPoint(x: 0, y: 0) // callout의 위치
            view.leftCalloutAccessoryView = detailButton
            view.markerTintColor = .purple
        }
        
        return view
    }
    @objc func copyAddress(_ sender: UIButton){
        if mapView.selectedAnnotations.first is Artwork {
            
            let modal = DetailModalViewController()
            modal.contentName = contentViewModel?.contentName
            modal.annotation = mapView.selectedAnnotations.first as! Artwork
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
        guard let safeContent = contentViewModel else {
            return 0
        }
        return safeContent.locations.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let safeContent = contentViewModel else {
            return ""
        }
        return safeContent.locations[row].locationName
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let safeContent = contentViewModel else {
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



