import UIKit

protocol transitionDelegate {
func transition(MapVC: MapViewController)
}

class CSCollectionViewCell : UICollectionViewCell{
    
    var delegate : transitionDelegate?
    
    var CSBg: UIImageView = {
        let bg = UIImageView()
        
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.contentMode = .scaleAspectFit
        bg.clipsToBounds = true
        bg.layer.cornerRadius = 50
        
        return bg
    }()
    
    var CSButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 50
        return button
    }()
    
    var CSLabel : UILabel = {
       let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .white
        label.text = "hello"
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero) // ??
        
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
            
//            CSLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
//            CSLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
//            CSLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
//            CSLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
