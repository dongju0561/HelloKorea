//
//  ContentListViewController.swift
//  practice_pinOnMap
//
//  Created by Dongju Park on 2023/02/03.
//

import UIKit

class ContentListViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var list = ["1", "2", "3", "4" ,"5", "6", "7", "8", "9", "10"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView!.register(CSCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        
        // Do any additional setup after loading the view.
    }
    

}

extension ContentListViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CSCollectionViewCell
        
        cell.backgroundColor = .lightGray
        cell.lbl?.text = list[indexPath.row]
        cell.lbl?.backgroundColor = .yellow
        
        return cell
    }
    
    
}
