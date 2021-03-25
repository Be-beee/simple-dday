//
//  Storage.swift
//  SimpleDday
//
//  Created by 서보경 on 2021/03/25.
//

import UIKit

struct Storage {
    static let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    @discardableResult
    static func save<T: Encodable>(_ obj: T, at path: String) -> Bool {
        let directoryURL = documentURL.appendingPathComponent(path, isDirectory: false)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(obj)
            if FileManager.default.fileExists(atPath: directoryURL.path) {
                try FileManager.default.removeItem(at: directoryURL)
            }
            FileManager.default.createFile(atPath: directoryURL.path, contents: data, attributes: nil)
            return true
        } catch let error {
            print(error.localizedDescription)
            return false
        }
    }
    
    static func load<T: Decodable>(at path: String, _ type: T.Type) -> T? {
        let directoryURL = documentURL.appendingPathComponent(path, isDirectory: false)
        guard FileManager.default.fileExists(atPath: directoryURL.path) else { return nil }
        guard let data = FileManager.default.contents(atPath: directoryURL.path) else { return nil }
        
        let decoder = JSONDecoder()
        
        do {
            let model = try decoder.decode(type, from: data)
            return model
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
}
