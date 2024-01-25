//
//  LoginViewModel.swift
//  HelloKorea
//
//  Created by Dongju Park on 1/23/24.
//

import RxSwift
import RxCocoa

class LoginViewModel{
    let emailObserver = BehaviorRelay<String>(value: "")
    let passwordObserver = BehaviorRelay<String>(value: "")
    
    //isValid는 emailObserver과 passwordObserver의 특정 조건에 만족하는지 확인하기 위한 연산 프로퍼티
    var isValid: Observable<Bool>{
        //.combineLatest() 메소드는 여러 개의 옵저버블을 결합, 각 옵저버블이 이벤트를 발생할때 마다 이벤트를 생성
        return Observable.combineLatest(emailObserver,passwordObserver)
                    .map { email, password in
                        //email이 공백이 아니고 '@'와 '.'를 포함하고 password의 문자의 갯수가 0보다 크다면 true를 반환함
                        return !email.isEmpty && email.contains("@") && email.contains(".") && password.count > 0
                    }
    }
}

