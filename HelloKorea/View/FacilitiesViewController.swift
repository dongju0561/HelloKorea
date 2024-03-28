//
//  FacilitiesViewController.swift
//  HelloKorea
//
//  Created by Dongju Park on 3/7/24.
//

import UIKit
import MapKit
import CoreLocation
import DrawerView
import FirebaseFirestore
import RxSwift

class FacilitiesViewController: UIViewController {
    let db = Firestore.firestore()
    let disposeBag = DisposeBag()
    var newLocations = [Location]()
    fileprivate let loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    fileprivate var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 200))
        scrollView.setGradient(color1: .black, color2: UIColor(rgb: 0x295EA6))
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 110)
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    fileprivate var mapView = MKMapView().then{
        $0.mapType = MKMapType.standard
        $0.isZoomEnabled = true
        $0.isScrollEnabled = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        self.loadingView.isLoading = true
        fetchDocumentDatas()
        delay(3.0, closure: {
            self.enterCoordinate()
            self.loadingView.isLoading = false
        })
        
        initSubView()
    }
    
    func delay(_ delay: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
    
    func initSubView() {
        mapView.delegate = self
        
        view.addSubview(mapView)
        view.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            loadingView.leftAnchor.constraint(equalTo: view.leftAnchor),
            loadingView.rightAnchor.constraint(equalTo: view.rightAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func fetchDocumentDatas(){
        db.collection("halalRestuarants").getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching documents: \(error)")
            } else {
                if let documents = snapshot?.documents {
                    for document in documents {
                        //data fetch
                        guard let address = document.data()["address"] as? String else {return}
                        guard let number = document.data()["number"] as? String else {return}
                        guard let type = document.data()["type"] as? String else {return}
                        guard let foodOrPray = document.data()["foodOrPray"] as? String else {return}
                        var location = Location(
                            locationName: document.documentID,
                            coordinate: CLLocationCoordinate2D(),
                            address: address,
                            number: number,
                            type: type,
                            foodOrPray: foodOrPray
                        )
                        newLocations.append(location)
                    }
                }
            }
        }
    }
    
    //입력 받은 주소로 위도 경도 변환하는 기능
    private func convertAddressToCoordinates(address: String) -> Observable<CLLocationCoordinate2D> {
        return Observable.create { observer in
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address) { (placemarks, error) in
                if let error = error {
                    print("Geocoding error: \(error.localizedDescription)")
                    return
                }
                if let placemark = placemarks?.first {
                    let location = placemark.location
                    if let coordinate = location?.coordinate {
                        observer.onNext(coordinate)
                        observer.onCompleted()
                    } else if let error = error {
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    private func enterCoordinate(){
        for idx in 0..<newLocations.count {
            var currentLocation = newLocations[idx]
            
            var address = currentLocation.address
            convertAddressToCoordinates(address: address)
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: {
                    coordinate in
                    currentLocation.coordinate = coordinate
                    self.makePin(at: currentLocation)
                })
                .disposed(by: disposeBag)
        }
    }
    private func makePin(at location : Location) {
        mapView.addAnnotation(location)
    }
}
extension FacilitiesViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        if let selectedAnnotations = mapView.selectedAnnotations as? [MKPointAnnotation], let selectedAnnotation = selectedAnnotations.first {
            mapView.deselectAnnotation(selectedAnnotation, animated: true)
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        guard let annotation = annotation as? Location else {
            return nil
        }
        let identifier = MKMapViewDefaultAnnotationViewReuseIdentifier
        let annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView.configure(explanation: annotation.locationName, address: annotation.address)
        return annotationView
    }
}
