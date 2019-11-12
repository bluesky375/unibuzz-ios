//
//  Endpoint.swift
//  Grubs-up
//
//  Created by Ahmed Durrani on 25/05/2019.
//  Copyright © 2019 CyberHost. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get, post, put, update, delete
}

enum HTTPContentType {
    case form, json
}

typealias HTTPParameters = [String: String]

struct HTTPMultipart {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
}

protocol Endpoint {
    var baseUrl: String { get }
    var fullUrl: String { get }
    var path: String { get }
    var query: HTTPParameters { get }
    var body: HTTPParameters { get }
    var multipart: [HTTPMultipart] { get }
    var method: HTTPMethod { get }
    var contentType: HTTPContentType { get }
}

extension Endpoint {
    var baseUrl: String {
        return BASE_URL
    }
    
    var fullUrl: String {
        return baseUrl + path
    }
    
    var query: HTTPParameters {
        return HTTPParameters()
    }
    
    var body: HTTPParameters {
        return HTTPParameters()
    }
    
    var multipart: [HTTPMultipart] {
        return []
    }
}
