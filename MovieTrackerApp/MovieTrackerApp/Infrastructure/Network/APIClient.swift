//
//  APIClient.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/01.
//

import Foundation
import Alamofire
import RxSwift

enum APIError: Error {
    case badRequest             // Status code 400
    case forbidden              // Status code 403
    case notFound               // Status code 404
    case internalServerError    // Status code 500
}

protocol APIClient {
    func getMovies(query: MovieQuery) -> Observable<MoviesResponseDTO>
}

// MARK: - Implementation

final class DefaultAPIClient {
    private let config: NetworkConfigurable
    private let session: NetworkSession
    
    init(config: NetworkConfigurable, session: NetworkSession) {
        self.config = config
        self.session = session
    }
    
    private func request<T: Decodable>(_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        return Observable<T>.create { [weak self] observer in
            let request = self?.session.request(urlConvertible, interceptor: nil)
                .responseDecodable { (response: DataResponse<T, AFError>) in
                    switch response.result {
                    case .success(let value):
                        observer.onNext(value)
                        observer.onCompleted()
                    case .failure(let error):
                        guard let self = self else { return }
                        let resolvedError = self.resolve(error: error, with: response.response?.statusCode)
                        observer.onError(resolvedError)
                        printIfDebug(error.localizedDescription)
                    }
                }
            return Disposables.create {
                request?.cancel()
            }
        }
    }
    
    private func resolve(error: Error, with statusCode: Int?) -> Error {
        switch statusCode {
        case 400:
            return APIError.badRequest
        case 403:
            return APIError.forbidden
        case 404:
            return APIError.notFound
        case 500:
            return APIError.internalServerError
        default:
            return error
        }
    }
}

extension DefaultAPIClient: APIClient {
    func getMovies(query: MovieQuery) -> Observable<MoviesResponseDTO> {
        return request(Router.getMovies(query: query))
    }
}

func printIfDebug(_ string: String) {
    #if DEBUG
    print(string)
    #endif
}
