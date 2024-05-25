import UIKit

class SkeletonCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        isSkeletonable = true
        contentView.isSkeletonable = true
        contentView.backgroundColor = .concrete
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        isSkeletonable = true
        contentView.isSkeletonable = true
        contentView.backgroundColor = .concrete
    }
}
