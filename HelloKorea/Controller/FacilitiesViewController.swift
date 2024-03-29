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

typealias Datas = (ID: String,address: String,number: String,type: String,foodOrPray: String)

class FacilitiesViewController: UIViewController {
    // MARK: - Property
    
    let db = Firestore.firestore()
    
    let disposeBag = DisposeBag()
    
    var newLocations = [Location]()
    
    let facilitiesView = FacilitiesView()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facilitiesView.mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        fetchDocumentDatasTest()
            .subscribe(
                onNext: { datas in
                    let location = Location(
                        locationName: datas.ID,
                        coordinate: CLLocationCoordinate2D(),
                        address: datas.address,
                        number: datas.number,
                        type: datas.type,
                        foodOrPray: datas.foodOrPray
                    )
                    self.newLocations.append(location)
                },
                onCompleted:  {
                    self.enterCoordinate()
                    self.facilitiesView.loadingView.isLoading = false
                }
            )
            .disposed(by: disposeBag)
        facilitiesView.initSubView()
        setup()
    }
    
    //: MARK: - View Methodes
    
    override func loadView() {
        view = facilitiesView
    }
    
    func setup() {
        self.facilitiesView.mapView.delegate = self
    }
    
    func fetchDocumentDatas(){
        self.facilitiesView.loadingView.isLoading = true
        self.db.collection("halalRestuarants").getDocuments { [weak self] snapshot, error in
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
                        let location = Location(
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
            let currentLocation = newLocations[idx]
            
            let address = currentLocation.address
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
        self.facilitiesView.mapView.addAnnotation(location)
    }
    
    func fetchDocumentDatasTest() -> Observable<Datas>{
        return Observable.create { observer in
            self.facilitiesView.loadingView.isLoading = true
            self.db.collection("halalRestuarants").getDocuments { [weak self] snapshot, error in
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
                            var datas = (ID: document.documentID,address: address,number: number,type: type,foodOrPray: foodOrPray)
                            observer.onNext(datas)
                        }
                        observer.onCompleted()
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    func delay(_ delay: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
    
}

    // MARK: - MapKit 

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
