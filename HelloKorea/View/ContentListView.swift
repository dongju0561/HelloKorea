//
//  ContentView.swift
//  HelloKorea
//
//  Created by Dongju Park on 3/29/24.
//

import UIKit

class ContentListView: UIView{
    
    // MARK: - Component
    
    let loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var labelHot = UILabel().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "What's hot"
        $0.textAlignment = .left
        $0.textColor = .white
        
        let attributedString = NSMutableAttributedString(string: $0.text!)
        let boldFont = UIFont.boldSystemFont(ofSize: 23)
        attributedString.addAttribute(.font, value: boldFont, range: NSRange(location: 0, length: $0.text!.count))
        $0.attributedText = attributedString
    }
    
    var labelfFire = UILabel().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "🔥"
        $0.textAlignment = .left
    }
    
    var collectionViewForTip : UICollectionView = { // collectionView는 layout없이는 초기화할 수 없다.
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // 스크롤 방향 설정
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout) // collectionView 객체를 생성하기 위해 layout 변수를 인수로 사용
        cv.contentInset = UIEdgeInsets(top: 0, left: 23, bottom: 0, right: 23)
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        cv.register(CSCollectionViewCell.self, forCellWithReuseIdentifier: "cell") // collectionView에 재사용할 cell 등록(재사용할 cell의 클래스)
        cv.backgroundColor = .clear
        cv.tag = 0
        return cv
    }()
    
    var labelJFY = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Just for you"
        $0.textAlignment = .left
        $0.textColor = .white
        
        let attributedString = NSMutableAttributedString(string: $0.text!)
        let boldFont = UIFont.boldSystemFont(ofSize: 20)
        attributedString.addAttribute(.font, value: boldFont, range: NSRange(location: 0, length: $0.text!.count))
        $0.attributedText = attributedString
    }
    
    var collectionViewForYou : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 0, left: 23, bottom: 0, right: 23)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CSCollectionViewCell.self, forCellWithReuseIdentifier: "cell") // collectionView에 재사용할 cell 등록(재사용할 cell의 클래스)
        cv.backgroundColor = .clear
        cv.tag = 1
        return cv
    }()
    
    var labelRomance = UILabel().then{
        $0.text = "Romance"
        $0.textAlignment = .left
        $0.textColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedString = NSMutableAttributedString(string: $0.text!)
        let boldFont = UIFont.boldSystemFont(ofSize: 20)
        attributedString.addAttribute(.font, value: boldFont, range: NSRange(location: 0, length: $0.text!.count))
        $0.attributedText = attributedString
    }
    
    var collectionViewForRomance : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 0, left: 23, bottom: 0, right: 23)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CSCollectionViewCell.self, forCellWithReuseIdentifier: "cell") // collectionView에 재사용할 cell 등록(재사용할 cell의 클래스)
        cv.backgroundColor = .clear
        cv.tag = 2
        return cv
    }()
    
    var labelThriller = UILabel().then{
        $0.text = "Thriller"
        $0.textAlignment = .left
        $0.textColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedString = NSMutableAttributedString(string: $0.text!)
        let boldFont = UIFont.boldSystemFont(ofSize: 20)
        attributedString.addAttribute(.font, value: boldFont, range: NSRange(location: 0, length: $0.text!.count))
        $0.attributedText = attributedString
    }
    
    var collectionViewForThriller : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 0, left: 23, bottom: 0, right: 23)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CSCollectionViewCell.self, forCellWithReuseIdentifier: "cell") // collectionView에 재사용할 cell 등록(재사용할 cell의 클래스)
        cv.backgroundColor = .clear
        cv.tag = 3
        return cv
    }()
    
    var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 400))
        let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        scrollView.contentInset = sectionInsets
        scrollView.setGradient(color1: .black, color2: UIColor(rgb: 0x295EA6))
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 110) //
        return scrollView
    }()
    
    init() {
        super.init(frame: .zero)
        initSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubView(){
        let screenWidth = UIScreen.main.bounds.width
        
        self.addSubview(scrollView)
        self.addSubview(loadingView)
        scrollView.addSubview(labelHot)
        scrollView.addSubview(labelfFire)
        scrollView.addSubview(collectionViewForTip)
        scrollView.addSubview(labelJFY)
        scrollView.addSubview(collectionViewForYou)
        scrollView.addSubview(labelRomance)
        scrollView.addSubview(collectionViewForRomance)
        scrollView.addSubview(labelThriller)
        scrollView.addSubview(collectionViewForThriller)
        
        NSLayoutConstraint.activate([
            
            loadingView.leftAnchor.constraint(equalTo: self.leftAnchor),
            loadingView.rightAnchor.constraint(equalTo: self.rightAnchor),
            loadingView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            loadingView.topAnchor.constraint(equalTo: self.topAnchor),
            
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            labelHot.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 23),
            labelHot.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 21),
            labelHot.widthAnchor.constraint(equalToConstant: 130),
            labelHot.heightAnchor.constraint(equalToConstant: 22),
            
            labelfFire.topAnchor.constraint(equalTo: labelHot.topAnchor),
            labelfFire.leadingAnchor.constraint(equalTo: labelHot.trailingAnchor),
            
            collectionViewForTip.topAnchor.constraint(equalTo: labelHot.bottomAnchor, constant: 9),
            collectionViewForTip.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            collectionViewForTip.widthAnchor.constraint(equalToConstant: screenWidth),
            collectionViewForTip.heightAnchor.constraint(equalToConstant: 206),
            
            labelJFY.topAnchor.constraint(equalTo: collectionViewForTip.bottomAnchor, constant: 28),
            labelJFY.leadingAnchor.constraint(equalTo: labelHot.leadingAnchor),
            labelJFY.widthAnchor.constraint(equalToConstant: 117),
            labelJFY.heightAnchor.constraint(equalToConstant: 22),
            
            collectionViewForYou.topAnchor.constraint(equalTo: labelJFY.bottomAnchor, constant: 8),
            collectionViewForYou.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            collectionViewForYou.widthAnchor.constraint(equalToConstant: screenWidth),
            collectionViewForYou.heightAnchor.constraint(equalToConstant: 190),
            
            labelRomance.topAnchor.constraint(equalTo: collectionViewForYou.bottomAnchor, constant: 28),
            labelRomance.leadingAnchor.constraint(equalTo: labelHot.leadingAnchor),
            labelRomance.widthAnchor.constraint(equalToConstant: 117),
            labelRomance.heightAnchor.constraint(equalToConstant: 22),
            
            collectionViewForRomance.topAnchor.constraint(equalTo: labelRomance.bottomAnchor, constant: 8),
            collectionViewForRomance.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            collectionViewForRomance.widthAnchor.constraint(equalToConstant: screenWidth),
            collectionViewForRomance.heightAnchor.constraint(equalToConstant: 190),
            
            labelThriller.topAnchor.constraint(equalTo: collectionViewForRomance.bottomAnchor, constant: 28),
            labelThriller.leadingAnchor.constraint(equalTo: labelHot.leadingAnchor),
            labelThriller.widthAnchor.constraint(equalToConstant: 117),
            labelThriller.heightAnchor.constraint(equalToConstant: 22),
            
            collectionViewForThriller.topAnchor.constraint(equalTo: labelThriller.bottomAnchor, constant: 8),
            collectionViewForThriller.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            collectionViewForThriller.widthAnchor.constraint(equalToConstant: screenWidth),
            collectionViewForThriller.heightAnchor.constraint(equalToConstant: 190),
        ])
        scrollView.contentSize = CGSize(width: screenWidth, height: 960)
    }
}
