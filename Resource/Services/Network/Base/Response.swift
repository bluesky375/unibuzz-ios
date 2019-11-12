//
//  Response.swift
//  Grubs-up
//
//  Created by Ahmed Durrani on 25/05/2019.
//  Copyright © 2019 CyberHost. All rights reserved.
//

import Foundation

protocol Response: Codable {
    var status: Bool? { get set  }
    var message: String? { get set }
    func process()
}

extension Response {
    func process() {}
        
}

