//
//  AppDIContainer.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/01.
//

import Foundation
import Alamofire

final class AppDIContainer {
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - Network
    lazy var apiClient: APIClient = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!,
                                          headers: ["X-Naver-Client-Id": appConfiguration.clientID,
                                                    "X-Naver-Client-Secret": appConfiguration.clientSecret])
        return DefaultAPIClient(config: config, session: AF)
    }()
    
    // MARK: - DIContainers of scenes
    func makeMoviesSceneDIContainer() -> MoviesSceneDIContainer {
        let dependencies = MoviesSceneDIContainer.Dependencies(apiClient: apiClient)
        return MoviesSceneDIContainer(dependencies: dependencies)
    }
}
