import UIKit
import RxSwift
import RxCocoa
import FirebaseStorage
import Firebase
import FirebaseCore
import FirebaseFirestore
import Then

class ContentListViewController: UIViewController {
    
    private let loadingView: LoadingView = {
      let view = LoadingView()
      view.translatesAutoresizingMaskIntoConstraints = false
      return view
    }()
    fileprivate var labelHot = UILabel().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "What's hot"
        $0.textAlignment = .left
        $0.textColor = .white
        
        let attributedString = NSMutableAttributedString(string: $0.text!)
        let boldFont = UIFont.boldSystemFont(ofSize: 23)
        attributedString.addAttribute(.font, value: boldFont, range: NSRange(location: 0, length: $0.text!.count))
        $0.attributedText = attributedString
    }
    fileprivate var labelfFire = UILabel().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "🔥"
        $0.textAlignment = .left
    }
    fileprivate var collectionViewForTip : UICollectionView = { // collectionView는 layout없이는 초기화할 수 없다.
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // 스크롤 방향 설정
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout) // collectionView 객체를 생성하기 위해 layout 변수를 인수로 사용
        cv.contentInset = UIEdgeInsets(top: 0, left: 23, bottom: 0, right: 23)
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        cv.register(CSCollectionViewCell.self, forCellWithReuseIdentifier: "cell") // collectionView에 재사용할 cell 등록(재사용할 cell의 클래스)
        cv.backgroundColor = .clear
        cv.tag = 0
        return cv
    }()
    fileprivate var labelJFY = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Just for you"
        $0.textAlignment = .left
        $0.textColor = .white
        
        let attributedString = NSMutableAttributedString(string: $0.text!)
        let boldFont = UIFont.boldSystemFont(ofSize: 20)
        attributedString.addAttribute(.font, value: boldFont, range: NSRange(location: 0, length: $0.text!.count))
        $0.attributedText = attributedString
    }
    fileprivate var collectionViewForYou : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 0, left: 23, bottom: 0, right: 23)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CSCollectionViewCell.self, forCellWithReuseIdentifier: "cell") // collectionView에 재사용할 cell 등록(재사용할 cell의 클래스)
        cv.backgroundColor = .clear
        cv.tag = 1
        return cv
    }()
    fileprivate var labelRomance = UILabel().then{
        $0.text = "Romance"
        $0.textAlignment = .left
        $0.textColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedString = NSMutableAttributedString(string: $0.text!)
        let boldFont = UIFont.boldSystemFont(ofSize: 20)
        attributedString.addAttribute(.font, value: boldFont, range: NSRange(location: 0, length: $0.text!.count))
        $0.attributedText = attributedString
    }
    fileprivate var collectionViewForRomance : UICollectionView = {
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
    fileprivate var labelThriller = UILabel().then{
        $0.text = "Thriller"
        $0.textAlignment = .left
        $0.textColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedString = NSMutableAttributedString(string: $0.text!)
        let boldFont = UIFont.boldSystemFont(ofSize: 20)
        attributedString.addAttribute(.font, value: boldFont, range: NSRange(location: 0, length: $0.text!.count))
        $0.attributedText = attributedString
    }
    fileprivate var collectionViewForThriller : UICollectionView = {
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
    var imageUrls: [[String]] = Array(repeating: [], count: 4)
    var fetchDatas: [[ContentsModelTest]] = Array(repeating: [], count: 4)
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //로딩화면 출력
        self.loadingView.isLoading = true
        //firebase로부터 데이터 패치
        fetchImageURLs()
        initSubView()
        delay(3.0, closure: {
            self.loadingView.isLoading = false
        })
    }
    func delay(_ delay: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
    private func initSubView(){
        let screenWidth = UIScreen.main.bounds.width
        
        self.collectionViewForTip.delegate = self
        self.collectionViewForTip.dataSource = self
        self.collectionViewForYou.delegate = self
        self.collectionViewForYou.dataSource = self
        self.collectionViewForRomance.delegate = self
        self.collectionViewForRomance.dataSource = self
        self.collectionViewForThriller.delegate = self
        self.collectionViewForThriller.dataSource = self

        view.addSubview(scrollView)
        view.addSubview(loadingView)
        scrollView.addSubview(labelHot)
        scrollView.addSubview(labelfFire)
        scrollView.addSubview(collectionViewForTip)
        scrollView.addSubview(labelJFY)
        scrollView.addSubview(collectionViewForYou)
        scrollView.addSubview(labelRomance)
        scrollView.addSubview(collectionViewForRomance)
        scrollView.addSubview(labelThriller)
        scrollView.addSubview(collectionViewForThriller)
        
        NSLayoutConstraint.activate([
            
            loadingView.leftAnchor.constraint(equalTo: view.leftAnchor),
            loadingView.rightAnchor.constraint(equalTo: view.rightAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            
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
            
            collectionViewForTip.topAnchor.constraint(equalTo: labelHot.bottomAnchor, constant: 9),
            collectionViewForTip.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            collectionViewForTip.widthAnchor.constraint(equalToConstant: screenWidth),
            collectionViewForTip.heightAnchor.constraint(equalToConstant: 206),
            
            labelJFY.topAnchor.constraint(equalTo: collectionViewForTip.bottomAnchor, constant: 28),
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
    //fireStore에서 특정 카테고리에 있는 드라마의 이미지 url을 fetch하는 메소드
    private func fetchImageURLs() {
        let collectionViews: [UICollectionView] = [collectionViewForTip,collectionViewForYou,collectionViewForRomance,collectionViewForThriller]
        let collections: [String] = ["tipsImages","YouImages","RomanceImages","ThrillerImages"]
        for idx in 0..<collections.count{
            db.collection(collections[idx]).getDocuments { [weak self] (snapshot, error) in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching documents: \(error)")
                } else {
                    if let documents = snapshot?.documents {
                        let imageURL = "imageURL"
                        for document in documents {
                            if let imageUrl = document.data()[imageURL] as? String {
                                self.imageUrls[idx].append(imageUrl)
                            }
                            guard let contentName = document.data()["contentName"] as? String else {return}
                            guard let contentNameK = document.data()["contentNameK"] as? String else {return}
                            guard let year = document.data()["year"] as? String else {return}
                            guard let cast = document.data()["cast"] as? String else {return}
                            guard let locations = document.data()["locations"] as? Array<Dictionary<String, String>> else {return}
                            guard let imageUrl = document.data()[imageURL] as? String else{return}
                            var locationsNew = [Location]()
                            for idx in 0..<locations.count{
                                let locationName = locations[idx]["locationName"]!
                                let address = locations[idx]["address"]!
                                let latitude = locations[idx]["latitude"]!
                                let longitude = locations[idx]["longitude"]!
                                let explaination = locations[idx]["explaination"]!
                                let location = Location(locationName: locationName, explaination: explaination, latitude: Double(latitude)!, longitude: Double(longitude)!, address: address)
                                locationsNew.append(location)
                            }
                            let contentModel = ContentsModelTest(contentName: contentName, contentNameK: contentNameK, year: year, cast: cast, imageURL: imageUrl, locations: locationsNew)
                            fetchDatas[idx].append(contentModel)
                        }
                        collectionViews[idx].reloadData()
                    }
                }
            }
        }
    }
    //전달 받은 이미지 url로 요청하여 이미지를 다운로드를 진행, 다운로드한 이미지를 구독자들에게 emit
    private func downLoadImage(imagePath: String) -> Observable<UIImage> {
        //Observable을 생성한 이유: 이미지를 받아오는 시점을 관찰하기 위해서
        return Observable.create { observer in
            //이미지 url으로 이미지를 다운받는 코드
            //image 다운로드를 위한 이미지 url 객체 생성
            let storageRef = self.storage.reference(withPath: imagePath)
            storageRef.downloadURL { url, error in
                if let error = error {
                    observer.onError(error)
                } else {
                    guard let safeURL = url else {
                        return
                    }
                    //session은 네트워크 통신 관리자
                    let session = URLSession.shared
                    let request = URLRequest(url: safeURL)
                    
                    let task = session.dataTask(with: request) { data, response, error in
                        if let safeData = data, let image = UIImage(data: safeData) {
                            observer.onNext(image)
                            observer.onCompleted()
                        } else if let error = error {
                            observer.onError(error)
                        }
                    }
                    task.resume()
                }
            }
            //이미지 url으로 이미지를 다운받는 코드 끝
            return Disposables.create()
        }
    }
    private func fetchImageAndBind(to cell: CSCollectionViewCell, IdxAt collectionIdx: Int, at indexPath: IndexPath) {
        let imagePath = imageUrls[collectionIdx][indexPath.item]

        downLoadImage(imagePath: imagePath)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [self] image in
                cell.CSBg.image = image
                fetchDatas[collectionIdx][indexPath.item].image = image
            }, onError: { error in
                print("Error downloading image: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}

extension ContentListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // cell의 갯수 결정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let tag = collectionView.tag
        if tag == 0 {
            return imageUrls[tag].count
        }
        else if(collectionView.tag == 1){
            return imageUrls[tag].count
        }
        else if(collectionView.tag == 2){
            return imageUrls[tag].count
        }
        else{
            return imageUrls[tag].count
        }
    }
    //cell별 특성 정의
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CSCollectionViewCell
        // UICollectionViewCell의 subclass인 CSCollectionViewCellfh 타입캐스팅
        let tag = collectionView.tag
        let contentName = fetchDatas[tag][indexPath.item].contentName
        let buttonTag = indexPath.row
        if tag == 0 {
            fetchImageAndBind(to: cell, IdxAt: tag, at: indexPath)
            cell.CSLabel.textAlignment = .left
            cell.CSLabel.font = cell.CSLabel.font.withSize(13)
            cell.CSLabel.text = contentName
            cell.CSButton.tag = buttonTag
            cell.CSButton.addTarget(self, action: #selector(hotButtonAction), for: .touchUpInside) //addTarget은 해당 버튼가 눌렸을때 동작할 함수를 맵핑해주는 메소트
        }
        else if(tag == 1){
            fetchImageAndBind(to: cell, IdxAt: tag, at: indexPath)
            cell.CSLabel.text = contentName
            cell.CSButton.tag = buttonTag
            cell.CSButton.addTarget(self, action: #selector(JFYButtonAction), for: .touchUpInside) //addTarget은 해당 버튼가 눌렸을때 동작할 함수를 맵핑해주는 메소트
        }
        else if(tag == 2){
            fetchImageAndBind(to: cell, IdxAt: tag, at: indexPath)
            cell.CSLabel.text = contentName
            cell.CSButton.tag = buttonTag
            cell.CSButton.addTarget(self, action: #selector(RomanceButtonAction), for: .touchUpInside) //addTarget은 해당 버튼가 눌렸을때 동작할 함수를 맵핑해주는 메소트
        }
        else{
            fetchImageAndBind(to: cell, IdxAt: tag, at: indexPath)
            cell.CSLabel.text = contentName
            cell.CSButton.tag = buttonTag
            cell.CSButton.addTarget(self, action: #selector(trillerButtonAction), for: .touchUpInside) //addTarget은 해당 버튼가 눌렸을때 동작할 함수를 맵핑해주는 메소트
        }
        return cell
    }
    //collectionView cell 크기 설정 함수
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        
        if collectionView.tag == 0 {
            return CGSize(width: width/1.9, height: height)
        }
        else{
            return CGSize(width: width/3.5, height: height)
        }
    }
    @objc func hotButtonAction(_ sender: UIButton!){
        let tipCollection = 0
        let DetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        // 버튼마다 가지고 있는 tag번호를 사용하여 data 배열에서 데이터를 조회한다.
        DetailVC.contentsModelTest =  fetchDatas[tipCollection][sender.tag]
        navigationController?.pushViewController(DetailVC, animated: true)
    }
    @objc func JFYButtonAction(_ sender: UIButton!){
        let youCollection = 1
        let DetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        // 버튼마다 가지고 있는 tag번호를 사용하여 data 배열에서 데이터를 조회한다.
        DetailVC.contentsModelTest =  fetchDatas[youCollection][sender.tag]
        navigationController?.pushViewController(DetailVC, animated: true)
    }
    @objc func RomanceButtonAction(_ sender: UIButton!){
        let RomanceCollection = 2
        let DetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        DetailVC.contentsModelTest =  fetchDatas[RomanceCollection][sender.tag]
        navigationController?.pushViewController(DetailVC, animated: true)
    }
    @objc func trillerButtonAction(_ sender: UIButton!){
        let trillerCollection = 3
        let DetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        DetailVC.contentsModelTest =  fetchDatas[trillerCollection][sender.tag]
        navigationController?.pushViewController(DetailVC, animated: true)
    }
}
