//
//  DisposeVC.swift
//  ATGitHub
//
//  Created by Алексей Трушковский on 06.01.2022.
//

import UIKit
import RxSwift

protocol DisposeContainer {
    var bag: DisposeBag { get }
}

class DisposeViewController: UIViewController, DisposeContainer {
    let bag = DisposeBag()
}
