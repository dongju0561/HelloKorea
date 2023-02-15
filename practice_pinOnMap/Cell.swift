//
//  Cell.swift
//  practice_pinOnMap
//
//  Created by Dongju Park on 2023/02/03.
//

import Foundation
import UIKit

class CSCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet var lbl: UILabel?
    
    let bg: UIImageView = {
        let iv = UIImageView()
        
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleToFill // 비율조정을 위한 프로퍼티
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "solo") //#imageLiteral()
        iv.layer.cornerRadius = 12
        return iv
    }()

    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: .zero)
        contentView.addSubview(bg)
        NSLayoutConstraint.activate([
            bg.topAnchor.constraint(equalTo: contentView.topAnchor),
            bg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bg.widthAnchor.constraint(equalTo: bg.widthAnchor),
            bg.heightAnchor.constraint(equalTo: bg.heightAnchor)
        ])
        print("work")
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder)
    }
}
