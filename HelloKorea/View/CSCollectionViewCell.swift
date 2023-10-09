import UIKit

class CSCollectionViewCell : UICollectionViewCell{
    
    var CSBg: UIImageView = {
        let bg = UIImageView()
        
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.contentMode = .scaleAspectFill
        bg.clipsToBounds = true
        bg.layer.cornerRadius = 25
        return bg
    }()
    var CSButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25
        return button
    }()
    var CSLabel : UILabel = {
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.backgroundColor = .clear
        lbl.adjustsFontSizeToFitWidth = true
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping // 단어 단위로 줄바꿈
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.clipsToBounds = true
        lbl.layer.cornerRadius = 20
        lbl.backgroundColor = .black.withAlphaComponent(0.8)
        lbl.font = lbl.font.withSize(13)
        
        return lbl
    }()

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
