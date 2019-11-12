//
//  Persistence.swift
//  Grubs-up
//
//  Created by Ahmed Durrani on 24/05/2019.
//  Copyright © 2019 CyberHost. All rights reserved.
//

import Foundation

struct Persistence {
    enum FilePath {
        case user, custom(path: String)
        
        func value() -> String {
            switch self {
            case .user:
                return "/user.data"
            case .custom(let path):
                return path
            }
        }
    }
    
    private let path: FilePath
    
    init(with path: FilePath) {
        self.path = path
    }
    
    private func documentsFolder() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0] as String
        return documentDirectory
    }
    
    func save<O: Codable>(_ object: O, success: ((_ success:Bool)-> Void)? = nil) {
        let url = URL(fileURLWithPath: documentsFolder().appending(path.value()))
        print(url)
        guard let data = try? JSONEncoder().encode(object.self) else { return }
        let encryptedData = data.base64EncodedData()
        do {
            try encryptedData.write(to: url)
            success?(true)
        } catch {
            success?(false)
            print(error)
        }
    }
    
    func load<O: Codable>() -> O? {
        let url = URL(fileURLWithPath: documentsFolder().appending(path.value()))
        guard let data = try? Data(contentsOf: url) else { return nil }
        guard let decryptedData = Data(base64Encoded: data) else { return nil }
        do {
            return try JSONDecoder().decode(O.self, from: decryptedData)
        } catch {
            print(error)
        }
        return nil
    }
    
    func delete() {
        let url = URL(fileURLWithPath: documentsFolder().appending(path.value()))
        try? FileManager.default.removeItem(at: url)
    }
}
