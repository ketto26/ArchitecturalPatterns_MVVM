//
//  MovieItemCollectionViewCell.swift
//  MVVM
//
//  Created by Keto Nioradze on 20.11.23.
//

import UIKit

final class MovieItemCollectionViewCell: UICollectionViewCell{
    
    // MARK: - Properties
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let favouriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .red
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var topButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubView()
        setupConstraints()
        setupButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        movieImageView.image = nil
        titleLabel.text = nil
        favouriteButton.setImage(UIImage(named: "heart"), for: .normal)
    }
    
    // MARK: - Private Methods
    private func setupSubView() {
        contentView.addSubview(movieImageView)
        contentView.addSubview(favouriteButton)
        contentView.addSubview(titleLabel)
       
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            movieImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 15),
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            movieImageView.heightAnchor.constraint(equalToConstant: 230)
        ])
        
        NSLayoutConstraint.activate([
            favouriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            favouriteButton.leftAnchor.constraint(equalTo: movieImageView.leftAnchor, constant: 20),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func setupButtonAction() {
        favouriteButton.addAction(
            UIAction(
                title: "",
                handler: { [weak self] _ in
                    let isFavorite = self?.favouriteButton.currentImage == UIImage(systemName: "heart.fill")
                    self?.favouriteButton.setImage(UIImage(systemName: isFavorite ? "heart" : "heart.fill"), for: .normal)
                }
            ),
            for: .touchUpInside
        )
    }
    
    // MARK: - Configuration
    func configure(with movie: MovieModel.Movie) {
        titleLabel.text = movie.title
        setImage(from: movie.posterPath)
    }
    
    private func setImage(from url: String) {
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.movieImageView.image = image
            }
        }
    }
}

