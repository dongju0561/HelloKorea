//
//  LoginViewController.swift
//  HelloKorea
//
//  Created by Dongju Park on 1/23/24.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseStorage
import Firebase

//images/swiftui.png

class LoginViewController: UIViewController {
    let storage = Storage.storage()
    
    let userEmail = "pd@gmail.com"
    let userPassword = "qwer1234"
    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    
    private let titleLabel: UILabel = {
        var lbl = UILabel()
        lbl.text = "HelloKorea"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor(named: Color.NavigationTintColor)!
        lbl.font = .systemFont(ofSize: 24)
        return lbl
    }()
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false // Auto Layout 사용을 위해 false로 설정합니다.
        imageView.contentMode = .scaleAspectFit // 이미지의 비율을 유지하면서 이미지뷰에 맞게 조정합니다.
        return imageView
    }()
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.text = "pd@gmail.com"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.text = "qwer1234"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        downLoadImage(imagePath: "images/swiftui.png")
    }
    private func downLoadImage(imagePath: String){
        
        let storageRef = storage.reference(withPath: imagePath)
        storageRef.downloadURL { [self] (url, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                // 다운로드 URL이 성공적으로 가져와졌을 때
                if let imageUrl = url {
                    // URL을 통해 이미지를 다운로드하거나 사용할 수 있습니다.
                    // 예를 들어, Alamofire 등의 라이브러리를 사용하여 이미지를 가져올 수 있습니다.
                    // 이 예시에서는 단순히 URL을 출력하는 것으로 대체합니다.
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
    
    private func setupUI() {
        view.layer.insertSublayer(setGradient(), at: 0)
        
        view.addSubview(titleLabel)
        view.addSubview(imageView)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            usernameTextField.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 50),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    private func setupActions() {
        //이메일 텍스트필드와 emailObserver를 데이터 바인딩을 하는 코드
        usernameTextField.rx.text
            .orEmpty
        //UI 컴포넌트와 emailObserver와 바인딩
        //bind 메소드를 호출하면 구독을 하고 behavior relay에 요소들을 전송한다.
            .bind(to: viewModel.emailObserver)
            .disposed(by: disposeBag)
        
        //패스워드 텍스트필드와 passwordObserver를 데이터 바인딩을 하는 코드
        passwordTextField.rx.text
            .orEmpty
            .bind(to: viewModel.passwordObserver)
            .disposed(by: disposeBag)
        
        //isValid 변수값에 따라 loginButton을 활성화하는 코드
        viewModel.isValid
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        //isValid 변수값에 따라 투명도를 조절하는 코드
        viewModel.isValid
            .map{ $0 ? 1 : 0.3}
            .bind(to: loginButton.rx.alpha)
            .disposed(by: disposeBag)
        
        //로그인 버튼을 누르면 사전에 저장된 이메일과 비밀번호가 일치한다면 다음 view로 주사하고 그렇지 않은 경우 아이디와 비밀번호가 일치하지 않는다는 메시지를 가진 alert을 출력
        loginButton.rx.tap.subscribe ({
            [weak self] _ in
            //정확한 아이디 & 비밀번호가 맞는 경우
            if(self?.userEmail == self?.viewModel.emailObserver.value && self?.userPassword == self?.viewModel.passwordObserver.value) {
                
                let LoginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContentListViewController") as! TabBarViewController
                self?.navigationController?.pushViewController(LoginVC, animated: true)
                self?.navigationController?.setNavigationBarHidden(true, animated: true)
            }
            
            //정확한 아이디 & 비밀번호가 아닐 경우
            else {
                let alert = UIAlertController(title: "로그인 실패", message: "아이디와 비밀번호를 다시 확인하세요", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default)
                alert.addAction(ok)
                self?.present(alert, animated: true, completion: nil)
            }
        }).disposed(by: disposeBag)
    }
    private func setGradient() -> CAGradientLayer{
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.cgColor, UIColor(red: 41/255, green: 94/255, blue: 166/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = view.bounds
        
        return gradientLayer
    }
}
