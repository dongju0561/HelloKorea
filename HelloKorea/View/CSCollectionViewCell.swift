import UIKit
import Then
class CSCollectionViewCell : UICollectionViewCell{
    var CSBg = UIImageView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 25
    }
    var CSButton = UIButton().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 25
    }
    var CSLabel = UILabel().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.adjustsFontSizeToFitWidth = true
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping // 단어 단위로 줄바꿈
        $0.textColor = .white
        $0.textAlignment = .center
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .black.withAlphaComponent(0.8)
        $0.font = $0.font.withSize(13)
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        initSubview()
    }
    
    func initSubview(){
        contentView.addSubview(CSBg)
        contentView.addSubview(CSButton)
        contentView.addSubview(CSLabel)
        
        NSLayoutConstraint.activate([
            CSBg.topAnchor.constraint(equalTo: contentView.topAnchor),
            CSBg.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            CSBg.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            CSBg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            CSButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            CSButton.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            CSButton.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            CSButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            CSLabel.heightAnchor.constraint(equalToConstant: 50),
            CSLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            CSLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            CSLabel.leadingAnchor.constraint(equalTo: CSBg.leadingAnchor),
            CSLabel.trailingAnchor.constraint(equalTo: CSBg.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
