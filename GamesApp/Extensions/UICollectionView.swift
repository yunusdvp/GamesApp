import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(cellType: T.Type, bundle: Bundle? = nil) {
        let className = String(describing: cellType)
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: className)
    }
    
    func dequeueCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: type), for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(String(describing: type))")
        }
        return cell
    }
    
    func setDataSourceAndDelegate(_ dataSource: UICollectionViewDataSource & UICollectionViewDelegate) {
            self.dataSource = dataSource
            self.delegate = dataSource
        }
}
