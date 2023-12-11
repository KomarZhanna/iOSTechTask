//
//  Movie.swift
//  iOSTestTask
//
//  Created by Zhanna Komar on 09.12.2023.
//

import Foundation

struct Movie: Codable {
    let id: Int
    let overview: String
    let popularity: Double
    let poster_path: String?
    let release_date: String
    let title: String
    let vote_average: Double
}

struct MovieResult: Codable {
    let page: Int
    let results: [Movie]?
    let total_pages: Int
    let total_results: Int
}
