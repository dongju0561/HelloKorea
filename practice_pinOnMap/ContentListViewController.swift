//
//  ContentListViewController.swift
//  practice_pinOnMap
//
//  Created by Dongju Park on 2023/02/03.
//

import UIKit

class ContentListViewController: UIViewController {
    
    let imageList : [UIImage] = [#imageLiteral(resourceName: "solo"), #imageLiteral(resourceName: "para") , #imageLiteral(resourceName: "island") , #imageLiteral(resourceName: "solo")]
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    var data = [
        ContentsData(contentName: "이태원 클라쓰", image: #imageLiteral(resourceName: "itaewon"), locations: [
            Location(locationName: "단밤 1호점", explaination: "박새로이가 처음 가게를 오픈한 위치", latitude: 37.5666805, longitude: 126.9784147),
            Location(locationName: "단밤 2호점", explaination: "장회장에게 1호점을 뺏기고 그 다음 오픈한 가게", latitude: 37.565758, longitude: 126.974801),
        ]),
        ContentsData(contentName: "일타 스캔들", image: #imageLiteral(resourceName: "ilta"), locations: [
            Location(locationName: "단밤 1호점", explaination: "박새로이가 처음 가게를 오픈한 위치", latitude: 37.5666805, longitude: 126.9784147),
            Location(locationName: "단밤 2호점", explaination: "장회장에게 1호점을 뺏기고 그 다음 오픈한 가게", latitude: 37.565758, longitude: 126.974801),
        ]),
        ContentsData(contentName: "나의 아저씨", image: #imageLiteral(resourceName: "my"), locations: [
            Location(locationName: "단밤 1호점", explaination: "박새로이가 처음 가게를 오픈한 위치", latitude: 37.5666805, longitude: 126.9784147),
            Location(locationName: "단밤 2호점", explaination: "장회장에게 1호점을 뺏기고 그 다음 오픈한 가게", latitude: 37.565758, longitude: 126.974801),
        ]),
        ContentsData(contentName: "나의 아저씨", image: #imageLiteral(resourceName: "para"), locations: [
            Location(locationName: "단밤 1호점", explaination: "박새로이가 처음 가게를 오픈한 위치", latitude: 37.5666805, longitude: 126.9784147),
            Location(locationName: "단밤 2호점", explaination: "장회장에게 1호점을 뺏기고 그 다음 오픈한 가게", latitude: 37.565758, longitude: 126.974801),
        ]),
        ContentsData(contentName: "나의 아저씨", image: #imageLiteral(resourceName: "solo"), locations: [
            Location(locationName: "단밤 1호점", explaination: "박새로이가 처음 가게를 오픈한 위치", latitude: 37.5666805, longitude: 126.9784147),
            Location(locationName: "단밤 2호점", explaination: "장회장에게 1호점을 뺏기고 그 다음 오픈한 가게", latitude: 37.565758, longitude: 126.974801),
        ]),
        ContentsData(contentName: "나의 아저씨", image: #imageLiteral(resourceName: "island"), locations: [
            Location(locationName: "단밤 1호점", explaination: "박새로이가 처음 가게를 오픈한 위치", latitude: 37.5666805, longitude: 126.9784147),
            Location(locationName: "단밤 2호점", explaination: "장회장에게 1호점을 뺏기고 그 다음 오픈한 가게", latitude: 37.565758, longitude: 126.974801),
        ])
    ]
    
    fileprivate var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CSCollectionViewCell.self, forCellWithReuseIdentifier: "cell") // collectionView에 재사용할 cell 등록(재사용할 cell의 클래스)
        cv.backgroundColor = .gray
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // Do any additional setup after loading the view.
        
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
    
    //
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    //cell별 특성 정의
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CSCollectionViewCell
        // UICollectionViewCell의 subclass인 CSCollectionViewCellfh 타입캐스팅
        cell.CSBg.image = data[indexPath.row].image
        
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
}
