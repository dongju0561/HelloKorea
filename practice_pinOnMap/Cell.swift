import UIKit

class CSCollectionViewCell : UICollectionViewCell {
    
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
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside) //addTarget은 해당 버튼가 눌렸을때 동작할 함수를 맵핑해주는 메소트
        button.layer.cornerRadius = 50
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero) // ??
        
        contentView.addSubview(CSBg)
        contentView.addSubview(CSButton)
        
        NSLayoutConstraint.activate([
            CSBg.topAnchor.constraint(equalTo: contentView.topAnchor),
            CSBg.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            CSBg.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            CSBg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            CSButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            CSButton.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            CSButton.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            CSButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonAction(sender: UIButton!){
        print("work")
    }
}
