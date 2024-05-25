//
//  FilteredOptionCollectionViewCell.swift
//  GamesApp
//
//  Created by Yunus Emre ÖZŞAHİN on 24.05.2024.
//

import UIKit

class FilteredOptionCollectionViewCell: UICollectionViewCell {
    
    //@IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var platfomNameLabel: UILabel!
    
    static let identifier =  "FilteredOptionCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureBorder()
    }
    private func configureBorder() {
        self.layer.borderColor = UIColor.systemGray5.cgColor
            self.layer.borderWidth = 0.5
            self.layer.cornerRadius = 12.0
            self.clipsToBounds = true
        }
    func configure(with platform: Platforms) {
            platfomNameLabel.text = platform.name
            
        }
    }


