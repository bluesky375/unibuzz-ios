//
//  NetworkLayer.swift
//  Grubs-up
//
//  Created by Ahmed Durrani on 25/05/2019.
//  Copyright © 2019 CyberHost. All rights reserved.
//

import Foundation

struct NetworkLayer {
    struct NetworkLayerError: LocalizedError {
        let message: String
        
        var errorDescription: String? {
            return message
        }
        
        var localizedDescription: String {
            return message
        }
    }
    
    static func fetch<D: Response>(_ endpoint: Endpoint, with: D.Type, handler: ((Result<D, NetworkLayerError>) -> ())? = nil) {
        var components = URLComponents(string: endpoint.fullUrl)
        var queryItems: [URLQueryItem] = []
        
//        queryItems.append(URLQueryItem(name: "client_id", value: "2"))
//        queryItems.append(URLQueryItem(name: "client_secret", value: "pmGqX1ki5HnvamG3g9nPC91QVBCeP6v2uzcjdjhS"))
//        queryItems.append(URLQueryItem(name: "grant_type", value: "password"))
//        queryItems.append(URLQueryItem(name: "scope", value: " "))
//        for item in endpoint.query {
//            queryItems.append(URLQueryItem(name: item.key, value: item.value))
//        }
        components?.queryItems = queryItems
        guard let url = components?.url else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json" , forHTTPHeaderField: "Accept")

        if let session: Session = Persistence(with: .user).load(), let token = session.access_token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        }
        switch endpoint.contentType {
        case .form:
            request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            var data = [String]()
            for (key, value) in endpoint.body {
                data.append("\(key)=\(value)")
            }
            let body = data.compactMap(({ String($0) })).joined(separator: "&")
            request.httpBody = body.data(using: .ascii)
        case .json:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
//        case .multipart:
//            let boundary = generateBoundary()
//            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//            var parameters = endpoint.body
//            let body = createDataBody(withParameters: parameters, media: endpoint.multipart, boundary: boundary)
//            request.httpBody = body
        }
        
        func handle(_ result: Result<D,NetworkLayerError>, _ delay: TimeInterval = 0) {
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + delay, execute: {
                handler?(result)
            })
        }
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                handle(.failure(.init(message: "Your Network appears to be offline")), 1)
            }
            
            guard let data = data else {
                handle(.failure(.init(message: "Something went wrong")))
                return
            }
            
            let dataString = String(data: data, encoding: .utf8)
            print(dataString)
            
            guard let object = try? JSONDecoder().decode(with, from: data) else {
                handle(.failure(.init(message: "Could not parse data")))
                return
            }
            
            object.process()
            handle(.success(object))
        }
        
        dataTask.resume()
    }
    
    
    static func fetchPost<D: Response>(_ endpoint: Endpoint, url : String ,  with: D.Type, handler: ((Result<D, NetworkLayerError>) -> ())? = nil) {
        var components = URLComponents(string: url)
        var queryItems: [URLQueryItem] = []
//        components?.queryItems = queryItems
        guard let url = components?.url else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json" , forHTTPHeaderField: "Accept")
        
        if let session: Session = Persistence(with: .user).load(), let token = session.access_token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
        }
        switch endpoint.contentType {
        case .form:
            request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            var data = [String]()
            for (key, value) in endpoint.body {
                data.append("\(key)=\(value)")
            }
            let body = data.compactMap(({ String($0) })).joined(separator: "&")
            request.httpBody = body.data(using: .ascii)
        case .json:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            //        case .multipart:
            //            let boundary = generateBoundary()
            //            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            //            var parameters = endpoint.body
            //            let body = createDataBody(withParameters: parameters, media: endpoint.multipart, boundary: boundary)
            //            request.httpBody = body
        }
        
        func handle(_ result: Result<D,NetworkLayerError>, _ delay: TimeInterval = 0) {
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + delay, execute: {
                handler?(result)
            })
        }
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                handle(.failure(.init(message: "Your Network appears to be offline")), 1)
            }
            
            guard let data = data else {
                handle(.failure(.init(message: "Something went wrong")))
                return
            }
            
            let dataString = String(data: data, encoding: .utf8)
//            print(dataString)
            
            guard let object = try? JSONDecoder().decode(with, from: data) else {
                handle(.failure(.init(message: "Could not parse data")))
                return
            }
            
            object.process()
            handle(.success(object))
        }
        
        dataTask.resume()
    }
    
    static func generateBoundary() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
//    static func createDataBody(withParameters params: [String: String]?, media: [HTTPMultipart]?, boundary: String) -> Data {
//        let lineBreak = "\r\n"
//        var body = Data()
//        if let parameters = params {
//            for (key, value) in parameters {
//                body.append("--\(boundary + lineBreak)")
//                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
//                body.append("\(value + lineBreak)")
//            }
//        }
//        
//        if let media = media {
//            for photo in media {
//                body.append("--\(boundary + lineBreak)")
//                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
//                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
//                body.append(photo.data)
//                body.append(lineBreak)
//            }
//        }
//        
//        body.append("--\(boundary)--\(lineBreak)")
//        
//        return body
//    }
}
