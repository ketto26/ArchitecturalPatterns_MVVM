//
//  MainPageModel.swift
//  MVVM
//
//  Created by Keto Nioradze on 20.11.23.
//

import Foundation


struct MovieModel: Decodable {
    let results: [Movie]

    struct Movie: Codable {
        let id: Int
        let posterPath: String
        let title: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case posterPath = "poster_path"
            case title
        }
    }
}

