//
//  DetailViewController.swift
//  HelloKorea
//
//  Created by Dongju Park on 11/7/23.
//

import UIKit
import Then

class DetailViewController: UIViewController {
    
    // MARK: - Property
    
    var contentsModel: ContentsModel?
    
    var contentsModelTest: ContentsModelTest?
    
    var detailView = DetailView()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.initSubView()
        setup()
        fetchData()
    }
    
    //: MARK: - View Methodes
    
    override func loadView() {
        view = detailView
    }
    
    func fetchData(){
        guard let safeContents = contentsModelTest else {
            return
        }
        detailView.imagePoster.image = safeContents.image
        detailView.labelName.text = safeContents.contentName
        detailView.labelYear.text = safeContents.year
        detailView.labelCast.text = safeContents.cast
    }
    
    func setup(){
        detailView.buttonMap.addTarget(self, action: #selector(moveToMap), for: .touchUpInside)
    }
    
    @objc func moveToMap(sender: UIButton!) {
        if let mapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as? MapViewController {
            mapVC.contentsModelTest = contentsModelTest
            navigationController?.pushViewController(mapVC, animated: true)
        }
    }
    
}
