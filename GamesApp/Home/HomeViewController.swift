import UIKit
import SkeletonView

// MARK: - HomeViewInterface Protocol

protocol HomeViewInterface: AnyObject {
    func prepareCollectionView()
    func prepareTopCollectionView()
    func prepareFilteredOptionCollectionView()
    func reloadCollectionView()
    func setupSearchBar()
    func hideTopCollectionView()
    func showTopCollectionView()
    func showError(error: APIError)
    func scrollToNextTopItem(currentItem: Int, nextItem: Int)
}

// MARK: - HomeViewController

final class HomeViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet private weak var gamesCollectionView: UICollectionView!
    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var filteredOptionCollectionView: UICollectionView!
    @IBOutlet weak var topCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gamesCollectionTopConstraint: NSLayoutConstraint!
    
    private lazy var viewModel: HomeViewModelInterface = HomeViewModel()
    private var isDataLoading = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
        self.view.applyGradientBackground()
        registerSkeletonCells()
        showSkeleton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear()
    }
    
    @IBAction func allGamesButtonTapped(_ sender: UIButton) {
        viewModel.allGamesButtonTapped()
    }
    
    private func showSkeleton() {
        gamesCollectionView.showAnimatedGradientSkeleton()
        topCollectionView.showAnimatedGradientSkeleton()
    }
    
    private func hideSkeleton() {
        gamesCollectionView.hideSkeleton()
        topCollectionView.hideSkeleton()
    }
    
    private func registerSkeletonCells() {
        filteredOptionCollectionView.register(SkeletonCollectionViewCell.self, forCellWithReuseIdentifier: "SkeletonCell")
        gamesCollectionView.register(SkeletonCollectionViewCell.self, forCellWithReuseIdentifier: "SkeletonCell")
        topCollectionView.register(SkeletonCollectionViewCell.self, forCellWithReuseIdentifier: "SkeletonCell")
    }
    
    private func animateVisibleCells() {
        let visibleCells = gamesCollectionView.visibleCells
        let collectionViewWidth = gamesCollectionView.bounds.size.width
        
        for (index, cell) in visibleCells.enumerated() {
            cell.transform = CGAffineTransform(translationX: collectionViewWidth, y: 0)
            UIView.animate(withDuration: 0.6, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
}

// MARK: - HomeViewInterface Implementation

extension HomeViewController: HomeViewInterface {
    func prepareFilteredOptionCollectionView() {
        filteredOptionCollectionView.isSkeletonable = true
        filteredOptionCollectionView.setDataSourceAndDelegate(self)
        filteredOptionCollectionView.backgroundColor = .clear
        filteredOptionCollectionView.register(cellType: FilteredOptionCollectionViewCell.self)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 4 - 15, height: filteredOptionCollectionView.bounds.height - 10)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        filteredOptionCollectionView.collectionViewLayout = layout
    }
    
    func showError(error: APIError) {
        AlertManager.showError(on: self, error: error)
    }
    
    func hideTopCollectionView() {
        topCollectionView.isHidden = true
        topCollectionViewHeightConstraint.constant = LayoutConstants.TopCollectionView.hiddenHeight
        view.layoutIfNeeded()
    }
    
    func showTopCollectionView() {
        topCollectionView.isHidden = false
        topCollectionViewHeightConstraint.constant = LayoutConstants.TopCollectionView.visibleHeight
        view.layoutIfNeeded()
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = SearchBar.placeholder
        searchBar.layer.cornerRadius = 10
        searchBar.backgroundColor = .clear
        searchBar.tintColor = .clear
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.isDataLoading = self.viewModel.isDataLoading
            if !self.isDataLoading {
                self.hideSkeleton()
                self.animateVisibleCells()
            }
            self.gamesCollectionView.reloadData()
            self.topCollectionView.reloadData()
            self.filteredOptionCollectionView.reloadData()
        }
    }
    
    func prepareCollectionView() {
        gamesCollectionView.isSkeletonable = true
        gamesCollectionView.setDataSourceAndDelegate(self)
        gamesCollectionView.register(cellType: GamesCollectionViewCell.self)
        gamesCollectionView.backgroundColor = .clear
        gamesCollectionView.layer.cornerRadius = 10
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: LayoutConstants.GamesCollectionView.itemWidth, height: LayoutConstants.GamesCollectionView.itemHeight)
        layout.minimumLineSpacing = LayoutConstants.GamesCollectionView.lineSpacing
        layout.minimumInteritemSpacing = LayoutConstants.GamesCollectionView.itemSpacing
        gamesCollectionView.collectionViewLayout = layout
    }
    
    func prepareTopCollectionView() {
        topCollectionView.isSkeletonable = true
        topCollectionView.setDataSourceAndDelegate(self)
        topCollectionView.layer.cornerRadius = 10
        topCollectionView.register(cellType: TopCollectionViewCell.self)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: LayoutConstants.TopCollectionView.itemWidth, height: LayoutConstants.TopCollectionView.itemHeight)
        layout.minimumLineSpacing = LayoutConstants.TopCollectionView.lineSpacing
        layout.minimumInteritemSpacing = LayoutConstants.TopCollectionView.itemSpacing
        topCollectionView.collectionViewLayout = layout
    }
    
    func scrollToNextTopItem(currentItem: Int, nextItem: Int) {
        let visibleItems = topCollectionView.indexPathsForVisibleItems.sorted()
        guard let currentIndexPath = visibleItems.first else { return }
        let nextIndexPath = IndexPath(item: nextItem, section: currentIndexPath.section)
        topCollectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchBarTextDidChange(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        viewModel.searchBarSearchButtonClicked(query: query)
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        gamesCollectionView.setContentOffset(.zero, animated: true)
    }
}

// MARK: - CollectionViewDataSource, CollectionViewDelegate

extension HomeViewController: SkeletonCollectionViewDataSource, SkeletonCollectionViewDelegate {
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isDataLoading ? 10 : (skeletonView == topCollectionView ? min(viewModel.results.count, 3) : max(viewModel.results.count - 3, 0))
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        if isDataLoading {
            return "SkeletonCell"
        } else if skeletonView == filteredOptionCollectionView {
            return FilteredOptionCollectionViewCell.identifier
        } else if skeletonView == topCollectionView {
            return TopCollectionViewCell.identifier
        } else {
            return GamesCollectionViewCell.identifier
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isDataLoading ? 10 : (collectionView == topCollectionView ? min(viewModel.results.count, 3) : max(viewModel.results.count - 3, 0))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isDataLoading {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkeletonCell", for: indexPath) as! SkeletonCollectionViewCell
            return cell
        } else if collectionView == filteredOptionCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilteredOptionCollectionViewCell.identifier, for: indexPath) as! FilteredOptionCollectionViewCell
            let platform = Platforms.allCases[indexPath.row]
            cell.configure(with: platform)
            return cell
        } else if collectionView == topCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopCollectionViewCell.identifier, for: indexPath) as! TopCollectionViewCell
            if indexPath.row < viewModel.results.count {
                cell.configure(withModel: viewModel.results[indexPath.row])
                cell.apply3DEffect()
            } else {
                // Handle the case where the index is out of bounds
                // Optionally configure a default state or return a placeholder cell
                print("Index out of bounds for viewModel.results at indexPath.row: \(indexPath.row)")
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GamesCollectionViewCell.identifier, for: indexPath) as! GamesCollectionViewCell
            if indexPath.row < viewModel.results.count {
                cell.configure(withModel: viewModel.results[indexPath.row])
                cell.apply3DEffect()
            } else {
                // Handle the case where the index is out of bounds
                // Optionally configure a default state or return a placeholder cell
                print("Index out of bounds for viewModel.results at indexPath.row: \(indexPath.row)")
            }
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == filteredOptionCollectionView {
            let platform = Platforms.allCases[indexPath.row]
            print("Platform selected: \(platform)")
            viewModel.fetchGames(for: platform.rawValue, loadMore: false)
        } else {
            let game = viewModel.results[indexPath.row]
            navigateToDetailViewController(with: game.id)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == gamesCollectionView {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let height = scrollView.frame.size.height
            viewModel.handleScroll(offsetY: offsetY, contentHeight: contentHeight, frameHeight: height)
        }
    }
    
    private func navigateToDetailViewController(with gameId: Int?) {
        guard let gameId = gameId else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let detailViewModel = DetailViewModel(gameId: gameId)
        detailViewController.viewModel = detailViewModel
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
