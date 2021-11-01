//
//  APIEndpoints.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/01.
//

import Foundation

struct APIEndpoints {
    static func getMovies(with moviesRequestDTO: MoviesRequestDTO) -> Endpoint<MoviesResponseDTO> {
        return Endpoint(path: "v1/search/movie.json",
                        method: .get,
                        queryParameters: moviesRequestDTO)
    }
}
