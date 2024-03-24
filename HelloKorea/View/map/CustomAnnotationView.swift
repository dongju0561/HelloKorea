//
//  CustomAnnotationView.swift
//  HelloKorea
//
//  Created by Dongju Park on 3/25/24.
//

import MapKit

class CustomAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation?{
        didSet{
            let originalImage = #imageLiteral(resourceName: "halal")
            let resizedImage = resizeImage(image: originalImage, newWidth: 35)
            image = resizedImage
        }
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
