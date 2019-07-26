//
//  NetworkManager.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/5/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import UIKit

class NetworkManager {
    
    typealias NetworkCompletion<T> = (T?, Int?, NetworkError?) -> Void
    
    let dataLoader: NetworkDataLoader
    init(dataLoader: NetworkDataLoader) {
        self.dataLoader = dataLoader
    }
    static let shared = NetworkManager(dataLoader: URLSession.shared)
    
    enum Method: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    enum NetworkError: Error {
        case constructingURLFailed
        case noDataReturned
        case decodingData(error: Error)
        case encodingBody(error: Error)
        case badURL
        case dataTaskError(nsError: NSError)
        
        init?(dataTaskError: Error?) {
            if let error = dataTaskError {
                self = .dataTaskError(nsError: error as NSError)
            } else {
                return nil
            }
        }
    }
    
    func constructURL(baseURLString: String, appendingPaths: [String] = [], queries: [String: String] = [:]) -> URL? {
        guard var url = URL(string: baseURLString) else { return nil }
        for path in appendingPaths {
            url.appendPathComponent(path)
        }
        var queryArray: [URLQueryItem] = []
        for query in queries {
            queryArray.append(URLQueryItem(name: query.key, value: query.value))
        }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryArray.isEmpty ? nil : queryArray
        return urlComponents?.url
    }
    
    func dataTask<D: Decodable>(request: URLRequest, completion: @escaping NetworkCompletion<D>) {
        dataLoader.loadData(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                let responseCode = (response as? HTTPURLResponse)?.statusCode
                let networkError = NetworkError(dataTaskError: error)
                guard let data = data else {
                    completion(nil, responseCode, networkError)
                    return
                }
                let decodedData: D
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    decodedData = try decoder.decode(D.self, from: data)
                } catch let decodeError {
                    completion(nil, responseCode, .decodingData(error: decodeError))
                    return
                }
                completion(decodedData, responseCode, networkError)
            }
        }
    }
    
    /// Generic method that makes a network request and decodes data into specified type (from JSON)
    func makeRequest<D: Decodable>(method: NetworkManager.Method = .get, baseURLString: String, appendingPaths: [String] = [], queries: [String: String] = [:], headers: [String: String] = [:], encodedData: Data? = nil, completion: @escaping NetworkCompletion<D>) {
        guard let url = constructURL(baseURLString: baseURLString, appendingPaths: appendingPaths, queries: queries) else {
            completion(nil, nil, .constructingURLFailed)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        request.httpBody = encodedData
        dataTask(request: request, completion: completion)
    }
    
    /// Form encodes body from dictionary and makes network request
    func makeRequest<D: Decodable>(method: NetworkManager.Method = .get, baseURLString: String, appendingPaths: [String] = [], queries: [String: String] = [:], headers: [String: String] = [:], bodyForFormEncoding: [String: String], completion: @escaping NetworkCompletion<D>) {
        var newHeaders = headers
        newHeaders["Content-Type"] = "application/x-www-form-urlencoded"
        let body = formEncode(bodyForFormEncoding)
        makeRequest(method: method, baseURLString: baseURLString, appendingPaths: appendingPaths, queries: queries, headers: newHeaders, encodedData: body, completion: completion)
    }
    
    func makeRequest<E: Encodable, D: Decodable>(method: NetworkManager.Method = .get, baseURLString: String, appendingPaths: [String] = [], queries: [String: String] = [:], headers: [String: String] = [:], body: E, completion: @escaping NetworkCompletion<D>) {
        let bodyData: Data
        do {
            bodyData = try JSONEncoder().encode(body)
        } catch {
            completion(nil, nil, .encodingBody(error: error))
            return
        }
        makeRequest(method: method, baseURLString: baseURLString, appendingPaths: appendingPaths, queries: queries, headers: headers, encodedData: bodyData, completion: completion)
    }
    
    func getImage(url: URL, completion: @escaping NetworkCompletion<UIImage>) {
        dataLoader.loadData(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                let responseCode = (response as? HTTPURLResponse)?.statusCode
                let networkError = NetworkError(dataTaskError: error)
                guard let data = data else {
                    completion(nil, responseCode, networkError)
                    return
                }
                let image = UIImage(data: data)
                completion(image, responseCode, networkError)
            }
        }
    }
    
    func getImage(urlString: String, completion: @escaping NetworkCompletion<UIImage>) {
        guard let url = URL(string: urlString) else {
            completion(nil, nil, .badURL)
            return
        }
        getImage(url: url, completion: completion)
    }
    
    private func percentEscape(_ string: String) -> String? {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-._* ")
        return string
            .addingPercentEncoding(withAllowedCharacters: characterSet)?
            .replacingOccurrences(of: " ", with: "+")
    }
    
    private func formEncode(_ parameters: [String : String]) -> Data? {
        let parameterArray = parameters.compactMap { (key, value) -> String? in
            guard let escapedValue = percentEscape(value) else { return nil }
            return "\(key)=\(escapedValue)"
        }
        return parameterArray.joined(separator: "&").data(using: String.Encoding.utf8)
    }
}
