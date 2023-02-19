import UIKit

class CSCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView?
    
}


//let bg: UIImageView = {
//        let iv = UIImageView()
//        iv.translatesAutoresizingMaskIntoConstraints = false // constraint를 수동으로 설정
//        iv.clipsToBounds = true
//        iv.contentMode = .scaleAspectFill // 비율조정을 위한 프로퍼티
//        iv.layer.cornerRadius = 50
////        iv.image = #imageLiteral(resourceName: "solo") //#imageLiteral()
//        //이미지일 경우 size가 정해준 값과 다르게 나오게 된다.
//
//        return iv
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        contentView.addSubview(bg)
//        bg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        bg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//        bg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//        bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//    }

//
//    required init?(coder aDecoder : NSCoder) {
//        super.init(coder: aDecoder)
//    }
