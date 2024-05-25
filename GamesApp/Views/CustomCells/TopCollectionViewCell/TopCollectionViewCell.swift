//
//  TopCollectionViewCell.swift
//  GamesApp
//
//  Created by Yunus Emre ÖZŞAHİN on 21.05.2024.
//

import UIKit
import Kingfisher

class TopCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    private var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupActivityIndicator()
        imageView.layer.cornerRadius = 10
        
    }
    
     static let identifier = "TopCollectionViewCell"
    
    private func setupActivityIndicator() {
            activityIndicator = UIActivityIndicatorView(style: .medium)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            imageView.addSubview(activityIndicator)
            
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
            ])
        }
    
    public func configure(withModel model: Result) {
        guard let imageUrlString = model.backgroundImage,
              let imageUrl = URL(string: imageUrlString) else {
            print("Invalid URL string: \(String(describing: model.backgroundImage))")
            imageView.image = UIImage(named: "placeholder")
            return
        }

        activityIndicator.startAnimating()
        imageView.kf.setImage(
            with: imageUrl,
            placeholder: nil,
            options: [.transition(.fade(0.2))],
            progressBlock: nil) { [weak self] result in
                guard let self = self else { return }
                self.activityIndicator.stopAnimating()
                switch result {
                case .success(let value):
                    print("Image successfully loaded: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("Error loading image: \(error.localizedDescription)")
                    self.imageView.image = UIImage(named: "placeholder")
                }
            }
    }
    
    
}
