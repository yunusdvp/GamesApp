//
//  LayoutConstans.swift
//  GamesApp
//
//  Created by Yunus Emre ÖZŞAHİN on 24.05.2024.
//

import UIKit

enum LayoutConstants {
    
    // Screen dimensions and related functions
    enum Screen {
        static var width: CGFloat {
            return UIScreen.main.bounds.width
        }
        static var height: CGFloat {
            return UIScreen.main.bounds.height
        }
    }
    
    // TopCollectionView layout and dimensions
    enum TopCollectionView {
        static let hiddenHeight: CGFloat = 0
        static let visibleHeight: CGFloat = 200
        static let itemSpacing: CGFloat = 20
        static let lineSpacing: CGFloat = 20
        static var itemWidth: CGFloat {
            return Screen.width - 20
        }
        static var itemHeight: CGFloat {
            return visibleHeight
        }
    }
    
    // GamesCollectionView layout and dimensions
    enum GamesCollectionView {
        static let itemSpacing: CGFloat = 20
        static let lineSpacing: CGFloat = 20
        static let itemHeightRatio: CGFloat = 1/8
        static var itemWidth: CGFloat {
            return Screen.width - 20
        }
        static var itemHeight: CGFloat {
            return Screen.height * itemHeightRatio
        }
    }
}

