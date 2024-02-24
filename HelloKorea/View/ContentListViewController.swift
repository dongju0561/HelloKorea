import UIKit
import RxSwift
import RxCocoa
import FirebaseStorage
import Firebase
import FirebaseCore
import FirebaseFirestore

class ContentListViewController: UIViewController {
    
    fileprivate var labelHot : UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "What's hot"
        lbl.textAlignment = .left
        lbl.textColor = .white
        
        let attributedString = NSMutableAttributedString(string: lbl.text!)
        let boldFont = UIFont.boldSystemFont(ofSize: 23)
        attributedString.addAttribute(.font, value: boldFont, range: NSRange(location: 0, length: lbl.text!.count))
        lbl.attributedText = attributedString
        
        return lbl
    }()
    fileprivate var labelfFire : UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "🔥"
        lbl.textAlignment = .left
        
        return lbl
    }()
    fileprivate var collectionViewForHot : UICollectionView = { // collectionView는 layout없이는 초기화할 수 없다.
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // 스크롤 방향 설정
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout) // collectionView 객체를 생성하기 위해 layout 변수를 인수로 사용
        cv.contentInset = UIEdgeInsets(top: 0, left: 23, bottom: 0, right: 23)
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        cv.register(CSCollectionViewCell.self, forCellWithReuseIdentifier: "cell") // collectionView에 재사용할 cell 등록(재사용할 cell의 클래스)
        cv.backgroundColor = .clear
        cv.tag = 1
        return cv
    }()
    fileprivate var labelJFY : UILabel = {
        var lbl = UILabel()
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Just for you"
        lbl.textAlignment = .left
        lbl.textColor = .white
        
        let attributedString = NSMutableAttributedString(string: lbl.text!)
        let boldFont = UIFont.boldSystemFont(ofSize: 20)
        attributedString.addAttribute(.font, value: boldFont, range: NSRange(location: 0, length: lbl.text!.count))
        lbl.attributedText = attributedString
        
        return lbl
    }()
    fileprivate var collectionViewForYou : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 0, left: 23, bottom: 0, right: 23)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CSCollectionViewCell.self, forCellWithReuseIdentifier: "cell") // collectionView에 재사용할 cell 등록(재사용할 cell의 클래스)
        cv.backgroundColor = .clear
        cv.tag = 2
        return cv
    }()
    fileprivate var labelRomance : UILabel = {
        var lbl = UILabel()
        
        lbl.text = "Romance"
        lbl.textAlignment = .left
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedString = NSMutableAttributedString(string: lbl.text!)
        let boldFont = UIFont.boldSystemFont(ofSize: 20)
        attributedString.addAttribute(.font, value: boldFont, range: NSRange(location: 0, length: lbl.text!.count))
        lbl.attributedText = attributedString
        
        return lbl
    }()
    fileprivate var collectionViewForRomance : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 0, left: 23, bottom: 0, right: 23)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CSCollectionViewCell.self, forCellWithReuseIdentifier: "cell") // collectionView에 재사용할 cell 등록(재사용할 cell의 클래스)
        cv.backgroundColor = .clear
        cv.tag = 3
        return cv
    }()
    fileprivate var labelThriller : UILabel = {
        var lbl = UILabel()
        
        lbl.text = "Thriller"
        lbl.textAlignment = .left
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedString = NSMutableAttributedString(string: lbl.text!)
        let boldFont = UIFont.boldSystemFont(ofSize: 20)
        attributedString.addAttribute(.font, value: boldFont, range: NSRange(location: 0, length: lbl.text!.count))
        lbl.attributedText = attributedString
        
        return lbl
    }()
    fileprivate var collectionViewForThriller : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 0, left: 23, bottom: 0, right: 23)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CSCollectionViewCell.self, forCellWithReuseIdentifier: "cell") // collectionView에 재사용할 cell 등록(재사용할 cell의 클래스)
        cv.backgroundColor = .clear
        cv.tag = 4
        
        return cv
    }()
    fileprivate var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 400))
        let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        scrollView.contentInset = sectionInsets
        scrollView.setGradient(color1: .black, color2: UIColor(rgb: 0x295EA6))
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 110) //
        return scrollView
    }()
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseApp.configure()

        
        initSubView()
    }
    private func initSubView(){
        let screenWidth = UIScreen.main.bounds.width
        
        self.collectionViewForHot.delegate = self
        self.collectionViewForHot.dataSource = self
        self.collectionViewForYou.delegate = self
        self.collectionViewForYou.dataSource = self
        self.collectionViewForRomance.delegate = self
        self.collectionViewForRomance.dataSource = self
        self.collectionViewForThriller.delegate = self
        self.collectionViewForThriller.dataSource = self

        view.addSubview(scrollView)
        scrollView.addSubview(labelHot)
        scrollView.addSubview(labelfFire)
        scrollView.addSubview(collectionViewForHot)
        scrollView.addSubview(labelJFY)
        scrollView.addSubview(collectionViewForYou)
        scrollView.addSubview(labelRomance)
        scrollView.addSubview(collectionViewForRomance)
        scrollView.addSubview(labelThriller)
        scrollView.addSubview(collectionViewForThriller)
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            labelHot.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 23),
            labelHot.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 21),
            labelHot.widthAnchor.constraint(equalToConstant: 130),
            labelHot.heightAnchor.constraint(equalToConstant: 22),
            
            labelfFire.topAnchor.constraint(equalTo: labelHot.topAnchor),
            labelfFire.leadingAnchor.constraint(equalTo: labelHot.trailingAnchor),
            
            collectionViewForHot.topAnchor.constraint(equalTo: labelHot.bottomAnchor, constant: 9),
            collectionViewForHot.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            collectionViewForHot.widthAnchor.constraint(equalToConstant: screenWidth),
            collectionViewForHot.heightAnchor.constraint(equalToConstant: 206),
            
            labelJFY.topAnchor.constraint(equalTo: collectionViewForHot.bottomAnchor, constant: 28),
            labelJFY.leadingAnchor.constraint(equalTo: labelHot.leadingAnchor),
            labelJFY.widthAnchor.constraint(equalToConstant: 117),
            labelJFY.heightAnchor.constraint(equalToConstant: 22),

            collectionViewForYou.topAnchor.constraint(equalTo: labelJFY.bottomAnchor, constant: 8),
            collectionViewForYou.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            collectionViewForYou.widthAnchor.constraint(equalToConstant: screenWidth),
            collectionViewForYou.heightAnchor.constraint(equalToConstant: 190),
            
            labelRomance.topAnchor.constraint(equalTo: collectionViewForYou.bottomAnchor, constant: 28),
            labelRomance.leadingAnchor.constraint(equalTo: labelHot.leadingAnchor),
            labelRomance.widthAnchor.constraint(equalToConstant: 117),
            labelRomance.heightAnchor.constraint(equalToConstant: 22),

            collectionViewForRomance.topAnchor.constraint(equalTo: labelRomance.bottomAnchor, constant: 8),
            collectionViewForRomance.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            collectionViewForRomance.widthAnchor.constraint(equalToConstant: screenWidth),
            collectionViewForRomance.heightAnchor.constraint(equalToConstant: 190),
            
            labelThriller.topAnchor.constraint(equalTo: collectionViewForRomance.bottomAnchor, constant: 28),
            labelThriller.leadingAnchor.constraint(equalTo: labelHot.leadingAnchor),
            labelThriller.widthAnchor.constraint(equalToConstant: 117),
            labelThriller.heightAnchor.constraint(equalToConstant: 22),

            collectionViewForThriller.topAnchor.constraint(equalTo: labelThriller.bottomAnchor, constant: 8),
            collectionViewForThriller.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            collectionViewForThriller.widthAnchor.constraint(equalToConstant: screenWidth),
            collectionViewForThriller.heightAnchor.constraint(equalToConstant: 190),
        ])
        scrollView.contentSize = CGSize(width: screenWidth, height: 960)
    }
    
    private func downLoadImage(imagePath: String){
        
        let storageRef = storage.reference(withPath: imagePath)
        storageRef.downloadURL { [self] (url, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                // 다운로드 URL이 성공적으로 가져와졌을 때
                if let imageUrl = url {
                    guard let safeURL = url else {
                        return
                    }
                    let session = URLSession.shared
                    let request = URLRequest(url: safeURL)
                    print("print this: \(safeURL)")
                    let dataObservable = session.rx.data(request: request)
                    
                    dataObservable.subscribe (onNext: { data in
                        
                        DispatchQueue.main.async {
                            let image = UIImage(data: data)
                            self.imageView.image = image
                        }
                        
                    }, onError: { error in
                        // 에러 처리
                        print("Error: \(error.localizedDescription)")
                    }).disposed(by: disposeBag)
                    print("Download URL: \(imageUrl.absoluteString)")
                }
            }
        }
    }
}

extension ContentListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // cell의 갯수 결정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return hotData.count
        }
        else if(collectionView.tag == 2){
            return JFYData.count
        }
        else if(collectionView.tag == 3){
            return romanceData.count
        }
        else{
            return thrillerData.count
        }
    }
    //cell별 특성 정의
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CSCollectionViewCell
        // UICollectionViewCell의 subclass인 CSCollectionViewCellfh 타입캐스팅
        
        if collectionView.tag == 1 {
            cell.CSLabel.textAlignment = .left
            cell.CSLabel.font = cell.CSLabel.font.withSize(13)
            cell.CSBg.image = hotData[indexPath.row].image
            cell.CSLabel.text = hotData[indexPath.row].contentName
            cell.CSButton.addTarget(self, action: #selector(hotButtonAction), for: .touchUpInside) //addTarget은 해당 버튼가 눌렸을때 동작할 함수를 맵핑해주는 메소트
            cell.CSButton.tag = indexPath.row
        }
        else if(collectionView.tag == 2){
            cell.CSBg.image = JFYData[indexPath.row].image
            cell.CSLabel.text = JFYData[indexPath.row].contentName
                cell.CSButton.addTarget(self, action: #selector(JFYButtonAction), for: .touchUpInside) //addTarget은 해당 버튼가 눌렸을때 동작할 함수를 맵핑해주는 메소트
            cell.CSButton.tag = indexPath.row
        }
        else if(collectionView.tag == 3){
            cell.CSBg.image = romanceData[indexPath.row].image
            cell.CSLabel.text = romanceData[indexPath.row].contentName
            cell.CSButton.addTarget(self, action: #selector(RomanceButtonAction), for: .touchUpInside) //addTarget은 해당 버튼가 눌렸을때 동작할 함수를 맵핑해주는 메소트
            cell.CSButton.tag = indexPath.row
        }
        else{
            cell.CSBg.image = thrillerData[indexPath.row].image
            cell.CSLabel.text = thrillerData[indexPath.row].contentName
            cell.CSButton.addTarget(self, action: #selector(trillerButtonAction), for: .touchUpInside) //addTarget은 해당 버튼가 눌렸을때 동작할 함수를 맵핑해주는 메소트
            cell.CSButton.tag = indexPath.row
        }
        
        return cell
    }
    //collectionView cell 크기 설정 함수
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        
        if collectionView.tag == 1 {
            
            return CGSize(width: width/1.9, height: height)
        }
        else{
            return CGSize(width: width/3.5, height: height)
        }
    }
    @objc func hotButtonAction(_ sender: UIButton!){
        let DetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        // 버튼마다 가지고 있는 tag번호를 사용하여 data 배열에서 데이터를 조회한다.
        DetailVC.contentsModel =  hotData[sender.tag]
        
        navigationController?.pushViewController(DetailVC, animated: true)
    }
    @objc func JFYButtonAction(_ sender: UIButton!){
        let DetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        // 버튼마다 가지고 있는 tag번호를 사용하여 data 배열에서 데이터를 조회한다.
        DetailVC.contentsModel =  JFYData[sender.tag]
        navigationController?.pushViewController(DetailVC, animated: true)
    }
    @objc func RomanceButtonAction(_ sender: UIButton!){
        let DetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        DetailVC.contentsModel =  romanceData[sender.tag]
        navigationController?.pushViewController(DetailVC, animated: true)
    }
    @objc func trillerButtonAction(_ sender: UIButton!){
        let DetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        DetailVC.contentsModel =  thrillerData[sender.tag]
        navigationController?.pushViewController(DetailVC, animated: true)
    }
}
