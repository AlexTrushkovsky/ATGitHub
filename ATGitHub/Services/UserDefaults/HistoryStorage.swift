//
//  HistoryStorage.swift
//  ATGitHub
//
//  Created by Алексей Трушковский on 03.01.2022.
//

import Foundation

protocol HistoryStorage: AnyObject {
    func saveData<Data>(_ data: Data) throws where Data: Encodable
    func getData<Data>(castTo type: Data.Type) throws -> Data where Data: Decodable
}

extension UserDefaultsStorage: HistoryStorage {
    func saveData<Data>(_ data: Data) throws where Data: Encodable {
        try saveData(data, key: "history")
    }
    
    func getData<Data>(castTo type: Data.Type) throws -> Data where Data: Decodable {
        try getData(key: "history", castTo: type)
    }
}
