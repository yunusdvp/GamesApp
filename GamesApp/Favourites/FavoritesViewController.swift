import UIKit

protocol FavoritesViewProtocol: AnyObject {
    func reloadData()
}

import UIKit

class FavoritesViewController: UIViewController, FavoritesViewProtocol {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: FavoritesViewModelProtocol!
    
    init(viewModel: FavoritesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        setupCollectionView()
        viewModel.fetchFavoriteGames()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 150)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .white
        collectionView.register(UINib(nibName: "GamesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: GamesCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func reloadData() {
        print("FavoritesViewController reloading data")
        collectionView.reloadData()
    }
}

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {
            print("ViewModel is nil")
            return 0
        }
        let count = viewModel.favoriteGamesCount()
        print("Number of items in section: \(count)")
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GamesCollectionViewCell.identifier, for: indexPath) as? GamesCollectionViewCell else {
            return UICollectionViewCell()
        }
        let game = viewModel.favoriteGames[indexPath.row]
        cell.configure(with: game)
        print("Configuring cell for game: \(game.name)")
        return cell
    }
}
