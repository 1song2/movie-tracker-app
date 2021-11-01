//
//  Endpoint.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/01.
//

import Foundation
import Alamofire

class Endpoint<R>: ResponseRequestable {
    typealias Response = R
    
    let path: String
    let method: HTTPMethod
    let headerParamaters: [String: String]
    let queryParameters: Encodable?
    
    init(path: String,
         method: HTTPMethod,
         headerParamaters: [String: String] = [:],
         queryParameters: Encodable? = nil) {
        self.path = path
        self.method = method
        self.headerParamaters = headerParamaters
        self.queryParameters = queryParameters
    }
}

protocol Requestable {
    var path: String { get }
    var method: HTTPMethod { get }
    var headerParamaters: [String: String] { get }
    var queryParameters: Encodable? { get }
    
    func urlRequest(with networkConfig: NetworkConfigurable) throws -> URLRequest
}

protocol ResponseRequestable: Requestable {
    associatedtype Response
}

enum RequestGenerationError: Error {
    case components
}

extension Requestable {
    func url(with config: NetworkConfigurable) throws -> URL {
        let baseURL = config.baseURL.absoluteString.last != "/"
        ? config.baseURL.absoluteString + "/"
        : config.baseURL.absoluteString
        let endpoint = baseURL.appending(path)
        
        guard var urlComponents = URLComponents(string: endpoint) else { throw RequestGenerationError.components }
        var urlQueryItems = [URLQueryItem]()
        
        let queryParameters = try queryParameters?.toDictionary()
        queryParameters?.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        guard let url = urlComponents.url else { throw RequestGenerationError.components }
        return url
    }
    
    func urlRequest(with config: NetworkConfigurable) throws -> URLRequest {
        let url = try self.url(with: config)
        var urlRequest = URLRequest(url: url)
        var allHeaders: [String: String] = config.headers
        headerParamaters.forEach { allHeaders.updateValue($1, forKey: $0) }
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = allHeaders
        return urlRequest
    }
}

private extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let josnData = try JSONSerialization.jsonObject(with: data)
        return josnData as? [String: Any]
    }
}
