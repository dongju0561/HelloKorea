//
//  CustomAnnotationView.swift
//  HelloKorea
//
//  Created by Dongju Park on 3/25/24.
//

import MapKit

class CustomAnnotationView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        var originalImage = UIImage()
        if let annotation = annotation as? Location {
            switch annotation.foodOrPray{
            case "food":
                originalImage = #imageLiteral(resourceName: "halal")
            case "pray":
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
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
