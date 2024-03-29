//
//  DetailView.swift
//  HelloKorea
//
//  Created by Dongju Park on 3/29/24.
//

import UIKit

class DetailView: UIView{
    var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 200))
        scrollView.setGradient(color1: .black, color2: UIColor(rgb: 0x295EA6))
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 110)
        return scrollView
    }()
    
    var lblMap : UILabel = {
        var lbl = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Filming Locations"
        return lbl
    }()
    
    var imagePoster = UIImageView().then{
    $0.backgroundColor = .white
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 20
}
    
    var imageMap = UIImageView().then{
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.image = #imageLiteral(resourceName: "map 1")
        $0.contentMode = .scaleAspectFit
    }
    
    var buttonMap = UIButton().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 20

        $0.backgroundColor = .clear
    }
    
    var labelName = UILabel().then{
        $0.textColor = .white
        $0.textAlignment = .left
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
    }
    
    var labelLocation = UILabel().then{
        $0.text = "Filming Locations"
        $0.textColor = .white
        $0.textAlignment = .left
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedString = NSMutableAttributedString(string: $0.text!)
        let boldFont = UIFont.boldSystemFont(ofSize: 20)
        attributedString.addAttribute(.font, value: boldFont, range: NSRange(location: 0, length: $0.text!.count))
        $0.attributedText = attributedString
    }
    
    var labelYear = UILabel().then{
        $0.textColor = .white
        $0.textAlignment = .left
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var labelCast = UILabel().then{
        $0.textColor = .white
        $0.textAlignment = .left
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.adjustsFontSizeToFitWidth = true
        $0.numberOfLines = 3
        $0.lineBreakMode = .byWordWrapping // 단어 단위로 줄바꿈
    }
    
    func initSubView(){
        self.addSubview(scrollView)
        scrollView.addSubview(imagePoster)
        scrollView.addSubview(imageMap)
        scrollView.addSubview(buttonMap)
        scrollView.addSubview(labelName)
        scrollView.addSubview(labelYear)
        scrollView.addSubview(labelCast)
        scrollView.addSubview(labelLocation)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            imagePoster.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 23),
            imagePoster.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 21),
            imagePoster.widthAnchor.constraint(equalToConstant: 134),
            imagePoster.heightAnchor.constraint(equalToConstant: 193),
            
            imageMap.topAnchor.constraint(equalTo: imagePoster.bottomAnchor, constant: 71),
            imageMap.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageMap.widthAnchor.constraint(equalToConstant: 352),
            imageMap.heightAnchor.constraint(equalToConstant: 186),
            
            labelLocation.bottomAnchor.constraint(equalTo: imageMap.topAnchor, constant: -10),
            labelLocation.leadingAnchor.constraint(equalTo: imageMap.leadingAnchor),
            
            buttonMap.topAnchor.constraint(equalTo: imagePoster.bottomAnchor, constant: 71),
            buttonMap.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            buttonMap.widthAnchor.constraint(equalToConstant: 352),
            buttonMap.heightAnchor.constraint(equalToConstant: 186),
            
            labelName.topAnchor.constraint(equalTo: imagePoster.topAnchor, constant: 10),
            labelName.leadingAnchor.constraint(equalTo: imagePoster.trailingAnchor, constant: 28),
            labelName.trailingAnchor.constraint(equalTo: buttonMap.trailingAnchor),
            
            labelYear.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 25),
            labelYear.leadingAnchor.constraint(equalTo: imagePoster.trailingAnchor, constant: 28),
            
            labelCast.topAnchor.constraint(equalTo: labelYear.bottomAnchor, constant: 20),
            labelCast.leadingAnchor.constraint(equalTo: imagePoster.trailingAnchor, constant: 28),
            labelCast.trailingAnchor.constraint(equalTo: buttonMap.trailingAnchor)
            
        ])
    }
}
