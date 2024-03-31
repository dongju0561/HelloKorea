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
            self.db.collection("halalRestuarants").getDocuments { snapshot, error in
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
                            let datas = (ID: document.documentID,address: address,number: number,type: type,foodOrPray: foodOrPray)
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
        var annotationView: MKMarkerAnnotationView
        
        let identifier = MKMapViewDefaultAnnotationViewReuseIdentifier
        if let dequeuedView = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            annotationView = dequeuedView
            if annotation.foodOrPray == "halal"{
                annotationView.markerTintColor = .gray
                annotationView.glyphTintColor = .green
                annotationView.glyphImage = #imageLiteral(resourceName: "Logo-halal-icon-PNG")
            }
            else if annotation.foodOrPray == "pray"{
                annotationView.markerTintColor = .gray
                annotationView.glyphImage = #imageLiteral(resourceName: "transparent-pray-icon-ramadan-icon-prayer-icon-5ff25795928462.4759036716097176536002")
            }
            
        }else{
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = true // callout를 보여줌
            annotationView.calloutOffset = CGPoint(x: 0, y: 0) // callout의 위치
            if annotation.foodOrPray == "halal"{
                annotationView.markerTintColor = .gray
                annotationView.glyphTintColor = .green
                annotationView.glyphImage = #imageLiteral(resourceName: "Logo-halal-icon-PNG")
            }
            else if annotation.foodOrPray == "pray"{
                annotationView.markerTintColor = .gray
                annotationView.glyphImage = #imageLiteral(resourceName: "transparent-pray-icon-ramadan-icon-prayer-icon-5ff25795928462.4759036716097176536002")
            }
            
            let detailCustomCalloutView = DetailCustomCalloutView()
            let views = ["customCalloutView": detailCustomCalloutView]
            detailCustomCalloutView.addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "H:[customCalloutView(300)]", options: [], metrics: nil, views: views)
            )
            detailCustomCalloutView.addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "V:[customCalloutView(200)]", options: [], metrics: nil, views: views)
            )
            detailCustomCalloutView.detailButton.addTarget(self, action: #selector(showDetail), for: .touchUpInside)
            detailCustomCalloutView.configure(explanation: annotation.locationName, address: annotation.address)
            annotationView.detailCalloutAccessoryView = detailCustomCalloutView
        }
        
        return annotationView
    }
    //추가 기능 제공을 위한 modal present하는 함수
    @objc func showDetail(_ sender: UIButton){
        if facilitiesView.mapView.selectedAnnotations.first is Location {
//            
//            let modal = DetailModalViewController()
//            modal.contentName = contentsModelTest?.contentName
//            modal.annotation = (mapView.mapView.selectedAnnotations.first as! Artwork)
//            self.present(modal,animated: true)
        }
    }
}


