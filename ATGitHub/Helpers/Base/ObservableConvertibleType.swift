//
//  ObservableConvertibleType.swift
//  ATGitHub
//
//  Created by Алексей Трушковский on 06.01.2022.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableConvertibleType {
    func asDriver(_ file: StaticString = #file,
                  _ function: StaticString = #function,
                  _ line: UInt = #line,
                  onError: ((Error) -> Void)? = nil) -> Driver<Element> {
        asObservable()
            .do(onError: { error in
                onError?(error)
            })
            .asDriver(onErrorRecover: { _ in .never() })
    }
    
    func asDriver(onError build: @escaping @autoclosure () -> Element) -> Driver<Element> {
        return Observable.create { observer in
            self.asObservable()
                .subscribe(onNext: observer.onNext,
                           onError: { error in
                            observer.onNext(build())
                },
                           onCompleted: observer.onCompleted)
            }
            .asDriver(onErrorRecover: { _ in .never() })
    }
}
