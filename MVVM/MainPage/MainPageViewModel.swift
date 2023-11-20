//
//  MainPageViewModel.swift
//  MVVM
//
//  Created by Keto Nioradze on 20.11.23.
//

import Foundation

protocol MainPageViewModelDelegate: AnyObject {
    func moviesFetched(_ movies: [MovieModel.Movie])
    func showError(_ error: Error)
    func navigateToDetailsPage(with movieID: Int)
}

final class MainPageViewModel {
    private var movies: [MovieModel.Movie]?
    weak var delegate: MainPageViewModelDelegate?
    
    func viewDidLoad() {
        fetchMovies()
    }
    
    func didSelectMovie(at indexPath: IndexPath) {
        if let movieID = movies?[indexPath.row].id {
            delegate?.navigateToDetailsPage(with: movieID)
        }
    }
    
    private func fetchMovies() {
        NetworkManager.shared.fetchMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                self?.delegate?.moviesFetched(movies)
            case .failure(let error):
                self?.delegate?.showError(error)
            }
        }
    }
    
}
