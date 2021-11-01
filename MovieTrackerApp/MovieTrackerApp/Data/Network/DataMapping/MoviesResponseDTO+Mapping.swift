//
//  MoviesResponseDTO+Mapping.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/01.
//

import Foundation

struct MoviesResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case movies = "items"
    }
    let movies: [MovieDTO]
}

extension MoviesResponseDTO {
    struct MovieDTO: Decodable {
        private enum CodingKeys: String, CodingKey {
            case title
            case link
            case releaseYear = "pubDate"
            case director
            case cast = "actor"
            case userRating
        }
        let title: String?
        let link: String?
        let releaseYear: String?
        let director: String?
        let cast: String?
        let userRating: String?
    }
}

// MARK: - Mappings to Domain

extension MoviesResponseDTO {
    func toDomain() -> Movies {
        return .init(movies: movies.map { $0.toDomain() })
    }
}

extension MoviesResponseDTO.MovieDTO {
    func toDomain() -> Movie {
        return .init(title: title,
                     link: link,
                     releaseYear: Int(releaseYear ?? ""),
                     director: director,
                     cast: cast,
                     userRating: userRating)
    }
}
