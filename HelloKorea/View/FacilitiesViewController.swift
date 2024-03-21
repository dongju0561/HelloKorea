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

class FacilitiesViewController: UIViewController {
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
//        let drawerView = DrawerView()
//        drawerView.attachTo(view: self.view)
//        
//        // Set up the drawer here
//        drawerView.snapPositions = [.collapsed, .partiallyOpen]
        initSubView()
    }
    func initSubView() {
        mapView.delegate = self
        
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
extension FacilitiesViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
            if let selectedAnnotations = mapView.selectedAnnotations as? [MKPointAnnotation], let selectedAnnotation = selectedAnnotations.first {
                mapView.deselectAnnotation(selectedAnnotation, animated: true)
            }
        }
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
            view.canShowCallout = true // callout를 보여줌
            view.calloutOffset = CGPoint(x: 0, y: 0) // callout의 위치
            view.markerTintColor = .purple
        }
        return view
    }
}
