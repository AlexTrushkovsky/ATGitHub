//
//  UserDefaultsStorage.swift
//  ATGitHub
//
//  Created by Алексей Трушковский on 03.01.2022.
//

import Foundation

typealias Storages = APIStorage & HistoryStorage

class UserDefaultsStorage {
    
    let defaults: UserDefaults
    
    enum UserDefaultsError: String, LocalizedError {
        case encodeError = "Encode error"
        case noData = "No data found"
        case decodeError = "Decode error"
        
        var errorDescription: String? {
            rawValue
        }
    }
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    func save<Value>(value: Value?, key: DefaultsKey) {
        if let value = value {
            defaults.setValue(value, forKey: key.rawStringValue)
        }
    }
    
    func get<Value>(key: DefaultsKey) -> Value? {
        guard let value = defaults.value(forKey: key.rawStringValue) as? Value else { return nil }
        return value
    }
    
    func saveData<Data>(_ data: Data, key: String?) throws where Data: Encodable {
        guard let key = key else { throw UserDefaultsError.noData }
        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(data)
            UserDefaults.standard.set(encodedData, forKey: key)
        } catch {
            throw UserDefaultsError.encodeError
        }
    }
    
    func getData<Data>(key: String?, castTo type: Data.Type) throws -> Data where Data: Decodable {
        guard let key = key else { throw UserDefaultsError.noData }
        guard let data = UserDefaults.standard.data(forKey: key) else { throw UserDefaultsError.noData }
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(type, from: data)
            return decodedData
        } catch {
            throw UserDefaultsError.decodeError
        }
    }
}

protocol DefaultsKey {
    var rawStringValue: String { get }
}

extension String: DefaultsKey {
    var rawStringValue: String { self }
}

extension RawRepresentable where RawValue == String {
    var rawStringValue: String { rawValue }
}
