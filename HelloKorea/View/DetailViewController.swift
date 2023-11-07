//
//  DetailViewController.swift
//  HelloKorea
//
//  Created by Dongju Park on 11/7/23.
//

import UIKit

class DetailViewController: UIViewController {
    
    var contentsModel: ContentsModel?
    
    fileprivate var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 200))
        scrollView.setGradient(color1: .black, color2: UIColor(rgb: 0x295EA6))
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 110) //
        
        return scrollView
    }()
    fileprivate var lblMap : UILabel = {
        var lbl = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Filming Locations"
        return lbl
    }()
    fileprivate var imagePoster : UIImageView = {
        var image = UIImageView()
        image.backgroundColor = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        
        return image
    }()
    fileprivate var imageMap : UIImageView = {
        var image = UIImageView()
        image.backgroundColor = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        image.image = #imageLiteral(resourceName: "map 1")
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    fileprivate var buttonMap : UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
//        button.addTarget(self, action: #selector(moveToMap), for: .touchUpInside)
        button.backgroundColor = .clear
        
        return button
    }()
    fileprivate var labelName : UILabel = {
        var lbl = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        
        return lbl
    }()
    fileprivate var labelLocation : UILabel = {
        var lbl = UILabel()
        lbl.text = "Filming Locations"
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedString = NSMutableAttributedString(string: lbl.text!)
        let boldFont = UIFont.boldSystemFont(ofSize: 20)
        attributedString.addAttribute(.font, value: boldFont, range: NSRange(location: 0, length: lbl.text!.count))
        lbl.attributedText = attributedString
        
        return lbl
    }()
    fileprivate var labelYear : UILabel = {
        var lbl = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    fileprivate var labelCast : UILabel = {
        var lbl = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.adjustsFontSizeToFitWidth = true
        lbl.numberOfLines = 3
        lbl.lineBreakMode = .byWordWrapping // 단어 단위로 줄바꿈
        
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubView()
        fetchData()
    }
    func fetchData(){
        guard let safeContents = contentsModel else {
            return
        }
        imagePoster.image = safeContents.image
        labelName.text = safeContents.contentName
        labelYear.text = safeContents.year
        labelCast.text = safeContents.cast
    }
    func initSubView(){
        view.addSubview(scrollView)
        scrollView.addSubview(imagePoster)
        scrollView.addSubview(imageMap)
        scrollView.addSubview(buttonMap)
        scrollView.addSubview(labelName)
        scrollView.addSubview(labelYear)
        scrollView.addSubview(labelCast)
        scrollView.addSubview(labelLocation)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
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
    
//    @objc func moveToMap(sender: UIButton!) {
//        if let mapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as? MapViewController {
//            mapVC.contentViewModel = viewModel
//            navigationController?.pushViewController(mapVC, animated: true)
//        }
//    }
}
