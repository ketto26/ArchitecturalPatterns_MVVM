//
//  NetworkManager.swift
//  MVVM
//
//  Created by Keto Nioradze on 20.11.23.
//

import Foundation
import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    private let mainURL = "https://api.themoviedb.org/3"
    private let apiKey =  "d8ff3e307af3e5b687d07d89d33e6128"
    
    private init() {}
    
    func fetchMovies(completion: @escaping (Result<[MovieModel.Movie], Error>) -> Void) {
        let urlStr = "\(mainURL)/movie/top_rated?api_key=\(apiKey)"
        
        guard let url = URL(string: urlStr) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let moviesResponse = try JSONDecoder().decode(MovieModel.self, from: data)
                completion(.success(moviesResponse.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(urlString)") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            completion(image)
        }.resume()
    }
}


