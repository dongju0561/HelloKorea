//
//  CustomCalloutView.swift
//  HelloKorea
//
//  Created by Dongju Park on 3/12/24.
//

import UIKit
import MapKit
import Then

class CustomCalloutView: UIView {
    private let background = UIView().then{
        $0.backgroundColor = .gray
    }
    
    private let explanation = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .blue
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.text = "explanation"
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let explanationLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let address = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .blue
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.text = "addres"
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let addressLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    // 초기화 메서드
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    func configure(explanation: String, address: String) {
        explanationLabel.text = explanation
        addressLabel.text = address
    }
    private func setupSubviews() {
        addSubview(explanation)
        addSubview(explanationLabel)
        addSubview(address)
        addSubview(addressLabel)
        
        NSLayoutConstraint.activate([
            explanation.topAnchor.constraint(equalTo: topAnchor),
            explanation.leadingAnchor.constraint(equalTo: leadingAnchor),
            explanation.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            explanationLabel.topAnchor.constraint(equalTo: explanation.bottomAnchor),
            explanationLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            explanationLabel.widthAnchor.constraint(equalToConstant: 300),
            explanationLabel.heightAnchor.constraint(equalToConstant: 100),
            
            address.topAnchor.constraint(equalTo: explanationLabel.bottomAnchor),
            address.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            addressLabel.topAnchor.constraint(equalTo: address.bottomAnchor),
            addressLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            addressLabel.widthAnchor.constraint(equalToConstant: 300),
            addressLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
