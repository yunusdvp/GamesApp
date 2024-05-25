import UIKit

extension UICollectionViewCell {
    func apply3DEffect() {
        // Shadow
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 5)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 20
        layer.masksToBounds = false

        // 3D Transformation
        transform = CGAffineTransform(scaleX: 1, y: 1)
        layer.zPosition = 15
    }

    func remove3DEffect() {
        // Reset to normal
        transform = .identity
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0
        layer.shadowRadius = 0
        layer.zPosition = 0
    }
}

