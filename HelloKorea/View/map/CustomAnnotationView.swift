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
    var calloutView: UIView?
    var titleLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 250, height: 20))
    var detailLabel = UILabel(frame: CGRect(x: 10, y: 40, width: 250, height: 40))
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            // Create and add the custom callout view
            calloutView = UIView(frame: CGRect(x: 0, y: -50, width: 250, height: 100))
            calloutView?.backgroundColor = .white
            calloutView?.layer.cornerRadius = 5
            calloutView?.layer.borderWidth = 1
            calloutView?.layer.borderColor = UIColor.lightGray.cgColor
            
            if let safeTitleLabel = titleLabel.text{
                self.titleLabel.text = safeTitleLabel
            }
            titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
            calloutView?.addSubview(titleLabel)
            
            if let safeDetailLabel = detailLabel.text{
                self.detailLabel.text = safeDetailLabel
            }
            detailLabel.numberOfLines = 2
            detailLabel.font = UIFont.systemFont(ofSize: 14)
            calloutView?.addSubview(detailLabel)
            
            addSubview(calloutView!)
        } else {
            // Remove the custom callout view
            calloutView?.removeFromSuperview()
            calloutView = nil
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        var originalImage = UIImage()
        if let annotation = annotation as? Location {
            let facilities = Facilities(rawValue: annotation.foodOrPray!)
            
            switch facilities{
            case .halal:
                originalImage = #imageLiteral(resourceName: "halal")
            case .pray:
                originalImage = #imageLiteral(resourceName: "Image")
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
        self.detailLabel.text = address
    }
}
