//
//  Router.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/01.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    case getMovies(query: String)
    
    var baseURL: URL {
        lazy var appConfiguration = AppConfiguration()
        return URL(string: appConfiguration.apiBaseURL)!
    }
    
    var method: HTTPMethod {
        switch self {
        case .getMovies: return .get
        }
    }
    
    var headers: HTTPHeaders {
        lazy var appConfiguration = AppConfiguration()
        return ["X-Naver-Client-Id": appConfiguration.clientID,
                "X-Naver-Client-Secret": appConfiguration.clientSecret]
    }
    
    var path: String {
        switch self {
        case .getMovies: return "v1/search/movie.json"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        request.headers = headers
        
        switch self {
        case let .getMovies(query):
            request = try URLEncodedFormParameterEncoder().encode(["query": query], into: request)
        }
        
        return request
    }
}
