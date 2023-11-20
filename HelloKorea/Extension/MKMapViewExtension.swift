import MapKit

extension MKMapView {
    //기존에 있는에 메소드의 argument를 extend operator를 사용하여 상수를 입력해줄 수 있다.
    func setLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        
        let coordinateRegion = MKCoordinateRegion( center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
  }
}
