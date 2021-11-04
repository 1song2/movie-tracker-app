//
//  NetworkService.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/01.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case urlGeneration
}

protocol NetworkSession {
    func request(_ convertible: URLRequestConvertible, interceptor: RequestInterceptor?) -> DataRequest
}

extension Session: NetworkSession { }
