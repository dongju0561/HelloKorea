//
//  MapView.swift
//  HelloKorea
//
//  Created by Dongju Park on 3/29/24.
//

import UIKit
import MapKit

class MapView: UIView{
    //:MARK: - Component
    
    var pickerView = UIPickerView().then{
        $0.backgroundColor = .gray
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var mapView = MKMapView().then{
        $0.mapType = MKMapType.standard
        $0.isZoomEnabled = true
        $0.isScrollEnabled = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func initSubView() {
        self.addSubview(pickerView)
        self.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: self.topAnchor),
            mapView.leftAnchor.constraint(equalTo: self.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: self.rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: pickerView.topAnchor),
            
            pickerView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            pickerView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            pickerView.leftAnchor.constraint(equalTo: self.leftAnchor),
            pickerView.rightAnchor.constraint(equalTo: self.rightAnchor),
            pickerView.heightAnchor.constraint(equalToConstant: 100),
            pickerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width),
        ])
    }
}
