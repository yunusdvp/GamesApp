//
//  GamesCollectionViewCell.swift
//  GamesApp
//
//  Created by Yunus Emre ÖZŞAHİN on 19.05.2024.
//

import UIKit
import Kingfisher

struct ResizingProcessor: ImageProcessor {
    let identifier = "com.yourapp.ResizingProcessor"
    let targetSize: CGSize
    
    func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            return image.kf.resize(to: targetSize)
        case .data(let data):
            guard let image = KFCrossPlatformImage(data: data) else { return nil }
            return image.kf.resize(to: targetSize)
        }
    }
}

class GamesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var gameName: UILabel!
    private var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupActivityIndicator()
        imageView.layer.cornerRadius = 15
    }
    
    static let identifier = "GamesCollectionViewCell"
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
    
       func configure(with favoriteGame: FavoriteGames) {
           gameName.text = favoriteGame.name
           if let imageUrlString = favoriteGame.imageUrl,
              let imageUrl = URL(string: imageUrlString) {
               activityIndicator.startAnimating()
               imageView.kf.setImage(with: imageUrl, completionHandler: { [weak self] _ in
                   self?.activityIndicator.stopAnimating()
               })
           } else {
               imageView.image = UIImage(named: "placeholder")
           }
       }
    public func configure(withModel model: Result) {
        gameName.text = model.name
        guard let imageUrlString = model.backgroundImage,
              let imageUrl = URL(string: imageUrlString) else {
            print("Invalid URL string: \(String(describing: model.backgroundImage))")
            imageView.image = UIImage(named: "placeholder")
            return
        }
        
        activityIndicator.startAnimating()
        KingfisherManager.shared.retrieveImage(with: imageUrl) { [weak self] result in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            
            switch result {
            case .success(let value):
                let originalSize = value.image.size
                let targetSize = CGSize(width: originalSize.width / 5, height: originalSize.height / 5)
                let processor = ResizingImageProcessor(referenceSize: targetSize)
                
                self.imageView.kf.setImage(
                    with: imageUrl,
                    placeholder: nil,
                    options: [
                        .processor(processor),
                        .transition(.fade(0.2))
                    ],
                    progressBlock: nil,
                    completionHandler: { result in
                        switch result {
                        case .success(let value): break
                            //print("Image successfully loaded: \(value.source.url?.absoluteString ?? "")")
                        case .failure(let error):
                            print("Error loading image: \(error.localizedDescription)")
                            self.imageView.image = UIImage(named: "placeholder")
                        }
                    }
                )
            case .failure(let error):
                print("Error retrieving image: \(error.localizedDescription)")
                self.imageView.image = UIImage(named: "placeholder")
            }
        }
    }
}

