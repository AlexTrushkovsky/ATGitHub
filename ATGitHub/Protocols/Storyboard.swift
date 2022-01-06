//
//  Storyboard.swift
//  ATGitHub
//
//  Created by Алексей Трушковский on 06.01.2022.
//

import UIKit

protocol Storyboarded {
    static func instantiate(storyboardName name: String) -> Self
}

extension Storyboarded where Self: UIViewController {

    static func instantiate(storyboardName name: String = "Main") -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
