//
//  APIRequest.swift
//  HiberLink
//
//  Created by Nathan FALLET on 19/04/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import Foundation

class APIRequest {
    
    // Object properties
    var method: String
    var path: String
    var queryItems: [URLQueryItem]
    var body: String?
    
    init(_ method: String, path: String) {
        // Get request parameters
        self.method = method
        self.path = path
        self.queryItems = [URLQueryItem]()
    }
    
    // Add url parameter (String)
    func with(name: String, value: String) -> APIRequest {
        queryItems.append(URLQueryItem(name: name, value: value))
        return self
    }
    
    // Add url parameter (int)
    func with(name: String, value: Int) -> APIRequest {
        return with(name: name, value: "\(value)")
    }
    
    // Add url parameter (int64)
    func with(name: String, value: Int64) -> APIRequest {
        return with(name: name, value: "\(value)")
    }
    
    // Set request body
    func with(body: String) -> APIRequest {
        self.body = body
        return self
    }
    
    // Construct URL
    func getURL() -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "hiber.link"
        components.path = path
        
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        return components.url
    }
    
    // Execute the request
    func execute(completionHandler: @escaping (_ data: String?, _ status: APIResponseStatus) -> ()) {
        // Check url validity
        if let url = getURL() {
            // Create the request based on give parameters
            var request = URLRequest(url: url)
            request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
            request.httpMethod = method
            request.addValue("curl", forHTTPHeaderField: "User-Agent")
            
            // Set body
            if let body = body {
                request.httpBody = body.data(using: .utf8)
            }
            
            // Launch the request to server
            URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                // Check if there is an error
                if let error = error {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        completionHandler(nil, .offline)
                    }
                    return
                }
                
                // Get data and response
                if let data = data, let string = String(data: data, encoding: .utf8), let response = response as? HTTPURLResponse {
                    DispatchQueue.main.async {
                        completionHandler(string, self.status(forCode: response.statusCode))
                    }
                } else {
                    // We consider we don't have a valid response
                    DispatchQueue.main.async {
                        completionHandler(nil, .offline)
                    }
                }
            }.resume()
        } else {
            // URL is not valid
            DispatchQueue.main.async {
                completionHandler(nil, .invalidRequest)
            }
        }
    }
    
    // Get status for code
    func status(forCode code: Int) -> APIResponseStatus {
        switch code {
        case 200:
            return .ok
        case 201:
            return .created
        case 400:
            return .invalidRequest
        case 401:
            return .unauthorized
        case 404:
            return .notFound
        default:
            return .offline
        }
    }
    
}
