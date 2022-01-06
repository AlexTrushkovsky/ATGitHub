//
//  CellConfigProtocol.swift
//  ATGitHub
//
//  Created by Алексей Трушковский on 06.01.2022.
//


import UIKit

protocol CellConfiguratorProtocol {
    static var cellClass: AnyClass { get }
    static var cellNib: UINib { get }
    static var identifier: String { get }
}
