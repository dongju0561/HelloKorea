import UIKit
import RxSwift
import RxCocoa
import FirebaseStorage
import Firebase
import FirebaseCore
import FirebaseFirestore
import CoreLocation
import Then

class ContentListViewController: UIViewController {
    // MARK: - Property
    
    let db = Firestore.firestore()
    
    let storage = Storage.storage()
    
    let disposeBag = DisposeBag()
    
    var imageUrls: [[String]] = Array(repeating: [], count: 4)
    
    var fetchDatas: [[ContentsModelTest]] = Array(repeating: [], count: 4)
    
    var images = [UIImage]()
    
    private lazy var contentView = ContentListView()    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //로딩화면 출력
        contentView.initSubView()
        setup()
        contentView.loadingView.isLoading = true
        //firebase로부터 데이터 패치
        fetchDocumentDatas()
        delay(3.0, closure: {
            self.contentView.loadingView.isLoading = false
        })
    }
    
    // MARK: - View Methods
    
    override func loadView() {
        view = contentView
    }
    
    private func delay(_ delay: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
    
    private func setup(){
        
        contentView.collectionViewForTip.delegate = self
        contentView.collectionViewForTip.dataSource = self
        contentView.collectionViewForYou.delegate = self
        contentView.collectionViewForYou.dataSource = self
        contentView.collectionViewForRomance.delegate = self
        contentView.collectionViewForRomance.dataSource = self
        contentView.collectionViewForThriller.delegate = self
        contentView.collectionViewForThriller.dataSource = self

    }
    
    //fireStore에서 특정 카테고리에 있는 드라마의 이미지 url을 fetch하는 메소드
    private func fetchDocumentDatas() {
        let collectionViews: [UICollectionView] = [
            contentView.collectionViewForTip,
            contentView.collectionViewForYou,
            contentView.collectionViewForRomance,
            contentView.collectionViewForThriller
        ]
        
        let collections: [String] = [
            "tipsImages",
            "YouImages",
            "RomanceImages",
            "ThrillerImages"
        ]
        
        for idx in 0..<collections.count{
            db.collection(collections[idx]).getDocuments { [weak contentView] (snapshot, error) in
                guard let contentView = contentView else { return }
                if let error = error {
                    print("Error fetching documents: \(error)")
                } else {
                    if let documents = snapshot?.documents {
                        let imageURL = "imageURL"
                        for document in documents {
                            //data fetch
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
                                let location = Location(
                                    locationName: locationName,
                                    explaination: explaination,
                                    coordinate: CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!),
                                    address: address
                                )
                                locationsNew.append(location)
                            }
                            let contentModel = ContentsModelTest(contentName: contentName, contentNameK: contentNameK, year: year, cast: cast, imageURL: imageUrl, locations: locationsNew)
                            self.fetchDatas[idx].append(contentModel)
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
    
    func fetchImageAndBind(to cell: CSCollectionViewCell, IdxAt collectionIdx: Int, at indexPath: IndexPath) {
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

    // MARK: - UICollectionView

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
