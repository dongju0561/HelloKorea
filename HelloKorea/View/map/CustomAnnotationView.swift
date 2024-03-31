//
//  CustomAnnotationView.swift
//  HelloKorea
//
//  Created by Dongju Park on 3/25/24.
//

import MapKit
enum Facilities: String{
    case pray
    case halal
    
}
class CustomAnnotationView: MKAnnotationView {
    // MARK: - Component
    
    var calloutView: UIView?
    
    var titleLabel = UILabel().then{
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.textColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var address = UILabel().then {
        $0.text = "Address"
        $0.textColor = UIColor(named: Color.TabBarTintColor)
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var addressLabel = UILabel().then{
        $0.numberOfLines = 2
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .white
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
    
    // MARK: - Intialize
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        var originalImage = UIImage()
        if let annotation = annotation as? Location {
            let facilities = Facilities(rawValue: annotation.foodOrPray!)
            
            switch facilities{
            case .halal:
                originalImage = #imageLiteral(resourceName: "firebase_logo")
            case .pray:
                originalImage = #imageLiteral(resourceName: "git")
            default:
                originalImage = UIImage()
            }
            let resizedImage = resizeImage(image: originalImage, newWidth: 35)
            image = resizedImage
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - View Methodes
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            // Create and add the custom callout view
            calloutView = UIView(frame: CGRect(x: 0, y: -50, width: 350, height: 150))
            calloutView?.backgroundColor = UIColor(named: Color.NavigationBackgroundColor)
            calloutView?.layer.cornerRadius = 5
            calloutView?.layer.borderWidth = 2
            calloutView?.layer.borderColor = UIColor.lightGray.cgColor
            
            if let safeTitleLabel = titleLabel.text{
                self.titleLabel.text = safeTitleLabel
            }
            
            if let safeDetailLabel = addressLabel.text{
                self.addressLabel.text = safeDetailLabel
            }
            
            calloutView?.addSubview(addressLabel)
            
            addSubview(calloutView!)
            
            self.setupSubviews()
        } else {
            // Remove the custom callout view
            calloutView?.removeFromSuperview()
            calloutView = nil
        }
    }
    
    private func setupSubviews() {
        addSubview(calloutView!)
        calloutView?.addSubview(titleLabel)
        calloutView?.addSubview(address)
        calloutView?.addSubview(addressLabel)
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: calloutView!.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: calloutView!.leadingAnchor, constant: 10),
            titleLabel.widthAnchor.constraint(equalToConstant: 300),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            address.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            address.trailingAnchor.constraint(equalTo: calloutView!.trailingAnchor),
            address.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            address.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            addressLabel.leadingAnchor.constraint(equalTo: address.leadingAnchor),
            addressLabel.topAnchor.constraint(equalTo: address.bottomAnchor),
            addressLabel.widthAnchor.constraint(equalToConstant: 300),
            addressLabel.heightAnchor.constraint(equalToConstant: 30),
            
//            detailButton.bottomAnchor.constraint(equalTo: bottomAnchor),
//            detailButton.centerXAnchor.constraint(equalTo: centerXAnchor),
//            detailButton.leadingAnchor.constraint(equalTo: calloutView!.leadingAnchor),
//            detailButton.trailingAnchor.constraint(equalTo: calloutView!.trailingAnchor),
////            detailButton.widthAnchor.constraint(equalToConstant: 300),
//            detailButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    private func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func configure(explanation: String, address: String) {
        self.titleLabel.text = explanation
        self.addressLabel.text = address
    }
}
