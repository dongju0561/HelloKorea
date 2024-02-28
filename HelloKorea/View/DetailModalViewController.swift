import UIKit
import MapKit
import Toast_Swift
import SafariServices

//modal => 주소 복사, 장소 검색
class DetailModalViewController: UIViewController{
    var contentName: String?
    var annotation: Artwork?
    let data = ["주소 복사","관련 지역 검색"]
    
    fileprivate var dramaTitle: UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 20, weight: .bold)
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.backgroundColor = .blue
        return lbl
    }()
    // 테이블 뷰 생성
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 테이블 뷰의 데이터 소스와 델리게이트를 현재 클래스로 설정
        setUpTableView()
        initSubview()
        if let safeContentName = contentName{
            dramaTitle.text = safeContentName
        }
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.detents = [ .custom(resolver: { context in
                200
            })]
        }
    }
    func setUpTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        // 테이블 뷰에 셀 등록
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    func initSubview(){
        view.addSubview(dramaTitle)
        // 테이블 뷰를 뷰에 추가
        view.addSubview(tableView)
        
        // 테이블 뷰의 레이아웃을 설정
        NSLayoutConstraint.activate([
            dramaTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dramaTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dramaTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: dramaTitle.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension DetailModalViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let safeAnnotation = annotation else{
            return
        }
        //"주소 복사"버튼을 클릭했을때
        if(indexPath.row == 0){
            //저장된 주소를 클립보드에 복사
            if let safeAddress = safeAnnotation.address{
                UIPasteboard.general.string = safeAddress
                self.view.makeToast("주소가 복사 되었습니다")
                print(safeAddress + " 복사 되었습니다.")
            }
        }
        //"관련 지역 검색"버튼을 클릭했을때
        else if(indexPath.row == 1){
            guard let safeLocationName = safeAnnotation.title else{
                return
            }
            let searchText = safeLocationName
            let url = URL(string: "https://www.google.com/search?q=\(String(describing: searchText))")!
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true)
        }
        else{}
    }
}

