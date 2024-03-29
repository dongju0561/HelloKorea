//
//  FacilitiesView.swift
//  HelloKorea
//
//  Created by Dongju Park on 3/29/24.
//

import UIKit
import MapKit

class FacilitiesView: UIView{
    //:MARK: - Component
    
     let loadingView: LoadingView = {
        let view = LoadingView()
         view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
     var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 200))
        scrollView.setGradient(color1: .black, color2: UIColor(rgb: 0x295EA6))
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 110)
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
     var mapView = MKMapView().then{
        $0.mapType = MKMapType.standard
        $0.isZoomEnabled = true
        $0.isScrollEnabled = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func initSubView() {
        self.addSubview(mapView)
        self.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            loadingView.leftAnchor.constraint(equalTo: self.leftAnchor),
            loadingView.rightAnchor.constraint(equalTo: self.rightAnchor),
            loadingView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            loadingView.topAnchor.constraint(equalTo: self.topAnchor),
            mapView.topAnchor.constraint(equalTo: self.topAnchor),
            mapView.leftAnchor.constraint(equalTo: self.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: self.rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
