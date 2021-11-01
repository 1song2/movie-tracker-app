//
//  AppConfigurations.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/01.
//

import Foundation

final class AppConfiguration {
    lazy var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
    lazy var clientID: String = {
        guard let clientID = Bundle.main.object(forInfoDictionaryKey: "ClientID") as? String else {
            fatalError("ClientID must not be empty in plist")
        }
        return clientID
    }()
    lazy var clientSecret: String = {
        guard let clientSecret = Bundle.main.object(forInfoDictionaryKey: "ClientSecret") as? String else {
            fatalError("ClientSecret must not be empty in plist")
        }
        return clientSecret
    }()
}
