//
//  MovieListViewModel.swift
//  iOSTestTask
//
//  Created by Zhanna Komar on 08.12.2023.
//

import Foundation
import UIKit

class MovieListViewModel {
    private var movies: [Movie]?
    private var imageCache = [Int: Data]()
    
    private let apiKey = "fa3f8f7f0c25ccab71744dfd246ac4ff"
    private let baseURL = "https://api.themoviedb.org/3/"
    private let searchURLQuery = "search/movie?query="
    private let topRatedURLQuery = "movie/top_rated?language=en-US"
    
    func fetchMovies(completion: @escaping((Result<[Movie]?, Error>) -> Void)) {
        let urlString = "\(baseURL)\(topRatedURLQuery)&page=1"
        guard let request = createRequest(with: urlString) else { return }
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, _, error) in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let movieResults = try JSONDecoder().decode(MovieResult.self, from: data)
                self.movies = movieResults.results
                self.downloadImages {
                    DispatchQueue.main.async {
                        completion(.success(movieResults.results))
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func searchMovies(by keyword: String, completion: @escaping (Result<[Movie]?, Error>) -> Void) {
        let searchQuery = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseURL)\(searchURLQuery)\(searchQuery)&include_adult=false&language=en-US&page=1"
        guard let request = createRequest(with: urlString) else { return }
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, _, error) in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let movieResults = try JSONDecoder().decode(MovieResult.self, from: data)
                self.movies = movieResults.results
                self.downloadImages {
                    DispatchQueue.main.async {
                        completion(.success(movieResults.results))
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getImageData(for row: Int) -> UIImage? {
        guard let cachedImageData = imageCache[row] else { return nil }
        return UIImage(data: cachedImageData)
    }
    
    private func downloadImages(completion: @escaping () -> Void) {
        guard let movies = movies else { return }
        let baseImageURL = "https://image.tmdb.org/t/p/w500"
        let posterURLs = movies.compactMap { $0.poster_path }.map { "\(baseImageURL)\($0)" }
        
        let group = DispatchGroup()
        
        for (index, url) in posterURLs.enumerated() {
            group.enter()
            getData(from: url) { [weak self] data, _, _ in
                defer { group.leave() }
                if let data = data {
                    self?.imageCache[index] = data
                }
            }
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
    
    private func createRequest(with urlString: String) -> URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmYTNmOGY3ZjBjMjVjY2FiNzE3NDRkZmQyNDZhYzRmZiIsInN1YiI6IjY1NzMzZjI0YzRmNTUyMDEwYmEwMzU5YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.FpRfzNHjHS7hVeS9unqZ5thjTjDYH6T3aoGqEE1qcKQ"
        ]
        return request
    }
    
    private func getData(from urlString: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
