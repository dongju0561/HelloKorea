//
//  ContentListViewController.swift
//  practice_pinOnMap
//
//  Created by Dongju Park on 2023/02/03.
//

import UIKit

class ContentListViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    let imageList : [UIImage] = [#imageLiteral(resourceName: "solo"), #imageLiteral(resourceName: "para") , #imageLiteral(resourceName: "solo") , #imageLiteral(resourceName: "solo")]
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.register(CSCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        //collectionView에 재사용할 cell 등록(재사용할 cell의 클래스, )
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }

}

extension ContentListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collectionViewWidth = collectionView.frame.width
        let collectionViewHeight = collectionView.frame.height
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CSCollectionViewCell
        // UICollectionViewCell의 subclass인 CSCollectionViewCellfh 타입캐스팅
        cell.backgroundColor = .gray
        cell.image?.image = imageList[indexPath.row]
        
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
