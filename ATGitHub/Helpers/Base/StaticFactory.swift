//
//  StaticFactory.swift
//  ATGitHub
//
//  Created by Алексей Трушковский on 06.01.2022.
//

import Foundation

protocol StaticFactory {
    associatedtype Factory
}

extension StaticFactory {
    static var factory: Factory.Type { return Factory.self }
}
