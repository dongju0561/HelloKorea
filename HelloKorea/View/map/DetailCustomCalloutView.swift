//
//  CustomCalloutView.swift
//  HelloKorea
//
//  Created by Dongju Park on 3/12/24.
//

import UIKit
import MapKit
import Then

class DetailCustomCalloutView: UIView {
    // MARK: - Component
    
    private let explanation = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = UIColor(named: Color.TabBarBarTinitColor)
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        $0.text = "explanation"
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let explanationLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.lineBreakMode = .byTruncatingTail
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let address = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = UIColor(named: Color.TabBarBarTinitColor)
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        $0.text = "addres"
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let addressLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let detailButton = UIButton().then{
        $0.setTitle("Show Detail", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        $0.backgroundColor = UIColor(named: Color.TabBarTintColor)
        $0.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 0)
        $0.layer.borderWidth = 3
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    // MARK: - View Methodes
    
    func configure(explanation: String, address: String) {
        explanationLabel.text = explanation
        addressLabel.text = address
    }
    
    private func setupSubviews() {
        addSubview(explanation)
        addSubview(explanationLabel)
        addSubview(address)
        addSubview(addressLabel)
        addSubview(detailButton)
        
        NSLayoutConstraint.activate([
            explanation.topAnchor.constraint(equalTo: topAnchor),
            explanation.leadingAnchor.constraint(equalTo: leadingAnchor),
            explanation.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            explanationLabel.topAnchor.constraint(equalTo: explanation.bottomAnchor),
            explanationLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            explanationLabel.widthAnchor.constraint(equalToConstant: 300),
            explanationLabel.heightAnchor.constraint(equalToConstant: 30),
            
            address.leadingAnchor.constraint(equalTo: leadingAnchor),
            address.topAnchor.constraint(equalTo: explanationLabel.bottomAnchor),
            address.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            addressLabel.topAnchor.constraint(equalTo: address.bottomAnchor),
            addressLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            addressLabel.widthAnchor.constraint(equalToConstant: 300),
            addressLabel.heightAnchor.constraint(equalToConstant: 30),
            
            detailButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            detailButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            detailButton.widthAnchor.constraint(equalToConstant: 300),
            detailButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
}
