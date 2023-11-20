//
//  MainPageView.swift
//  MVVM
//
//  Created by Keto Nioradze on 20.11.23.
//

import Foundation
import UIKit

final class MainPageView: UIViewController {
    // MARK: - Properties
    private let logoImageView = UIImageView()
    private let profileButton = UIButton()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var movies = [MovieModel.Movie]()
    private let viewModel = MainPageViewModel()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK: - SetupView
    private func setupView() {
        view.backgroundColor = UIColor(red: 26/255.0, green: 34/255.0, blue: 50/255.0, alpha: 1)
        
        view.addSubview(collectionView)
        
        setupLogoImageView()
        setupProfileButton()
        setupCollectionView()
        setupNavBar()
        setupViewModelDelegate()
        viewModel.viewDidLoad()
    }
    
    // MARK: - Private Methods
    private func setupLogoImageView() {
        logoImageView.image = UIImage(named: "logo")
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    private func setupProfileButton() {
        profileButton.setTitle("Profile", for: .normal)
        profileButton.backgroundColor = .orange
        profileButton.layer.cornerRadius = 8
        profileButton.titleLabel?.font = UIFont(name: "Helvetica", size: 12)
        profileButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        profileButton.widthAnchor.constraint(equalToConstant: 78).isActive = true
        profileButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupCollectionView() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieItemCollectionViewCell.self, forCellWithReuseIdentifier: "MovieItemCell")
    }
    
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoImageView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileButton)
    }
    
    private func setupViewModelDelegate() {
        viewModel.delegate = self
    }
}

    // MARK: - DataSource
extension MainPageView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieItemCell", for: indexPath) as? MovieItemCollectionViewCell else { return  UICollectionViewCell() }
        cell.configure(with: movies[indexPath.row])
        return cell
    }
}

    // MARK: - Delegate
extension MainPageView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
        + flowLayout.sectionInset.right
        + flowLayout.minimumInteritemSpacing
        
        let width = Int((collectionView.bounds.width - totalSpace) / 2)
        let height = 278
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - CollectionView Delegate
extension MainPageView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectMovie(at: indexPath)
    }
}

// MARK: - MoviesListViewModelDelegate
extension MainPageView: MainPageViewModelDelegate {
    func navigateToDetailsPage(with movieID: Int) {
        let viewController = MovieDetailsViewController()
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func moviesFetched(_ movies: [MovieModel.Movie]) {
        self.movies = movies
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func showError(_ error: Error) {
        print("error")
    }
    
}


