//
//  ContentListViewController.swift
//  practice_pinOnMap
//
//  Created by Dongju Park on 2023/02/03.
//

import UIKit

class ContentListViewController: UIViewController {
    
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    fileprivate var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CSCollectionViewCell.self, forCellWithReuseIdentifier: "cell") // collectionView에 재사용할 cell 등록(재사용할 cell의 클래스)
        cv.backgroundColor = .black
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ContentListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // cell의 갯수 결정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    //cell별 특성 정의
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CSCollectionViewCell
        // UICollectionViewCell의 subclass인 CSCollectionViewCellfh 타입캐스팅
        cell.CSBg.image = data[indexPath.row].image
        cell.CSLabel.text = data[indexPath.row].contentName
        cell.CSButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        //addTarget은 해당 버튼가 눌렸을때 동작할 함수를 맵핑해주는 메소트
        cell.CSButton.tag = indexPath.row
        
        return cell
    }
    
    //collectionView cell 크기 설정 함수
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        let itemsPerRow: CGFloat = 2
        let widthPadding = sectionInsets.left * (itemsPerRow + 1)
        let itemsPerColumn: CGFloat = 3
        let heightPadding = sectionInsets.top * (itemsPerColumn + 1)
        let cellWidth = (width - widthPadding) / itemsPerRow
        let cellHeight = (height - heightPadding) / itemsPerColumn
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    @objc func buttonAction(sender: UIButton!){
        let MapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        MapVC.contentsData = data[sender.tag] // 버튼마다 가지고 있는 tag번호를 사용하여 data 배열에서 데이터를 조회한다.
        self.navigationController?.pushViewController(MapVC, animated: true)
    }
}
