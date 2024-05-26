import UIKit
import SkeletonView

protocol DetailViewInterface: AnyObject {
    func updateDescriptionText(_ text: String?)
    func showError(_ error: APIError)
    func updateScreenshots(_ urls: [URL])
    func updateGameImage(_ image: UIImage)
    func updateFavoriteButton(isFavorite: Bool)
}

class DetailViewController: UIViewController {
    
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var gameImage: UIImageView!
    
    var viewModel: DetailViewModelInterface!
    private var screenshotURLs: [URL] = []
    
    private let fullScreenImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        imageView.isUserInteractionEnabled = true
        imageView.alpha = 0.0
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.fetchGameDetails()
        setupCollectionView()
        showSkeletons()
        setupFavoriteButton()
        gameImage.applyGradient()
        self.view.applyGradientBackground()
    }
    
    private func setupFavoriteButton() {
        let favoriteButton = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(favoriteButtonTapped))
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    @objc private func favoriteButtonTapped() {
        // Handle favorite button tap
    }
    
    func updateFavoriteButton(isFavorite: Bool) {
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: isFavorite ? "star.fill" : "star")
    }
    
    @IBAction func goToWebButtonTapped(_ sender: UIButton) {
        viewModel.openWebsite(from: self)
    }
    
    private func setupCollectionView() {
        imagesCollectionView.isSkeletonable = true
        imagesCollectionView.setDataSourceAndDelegate(self)
        imagesCollectionView.layer.cornerRadius = 10
        imagesCollectionView.register(ScreenshotCollectionViewCell.self, forCellWithReuseIdentifier: ScreenshotCollectionViewCell.identifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: LayoutConstants.TopCollectionView.itemWidth, height: LayoutConstants.TopCollectionView.itemHeight)
        layout.minimumLineSpacing = LayoutConstants.TopCollectionView.lineSpacing
        layout.minimumInteritemSpacing = LayoutConstants.TopCollectionView.itemSpacing
        imagesCollectionView.collectionViewLayout = layout
    }
    
    private func showSkeletons() {
        descriptionText.isSkeletonable = true
        descriptionText.showAnimatedSkeleton()
        imagesCollectionView.showAnimatedSkeleton()
    }
    
    private func hideSkeletons() {
        descriptionText.hideSkeleton()
        imagesCollectionView.hideSkeleton()
    }
}

extension DetailViewController: DetailViewInterface {
    func updateGameImage(_ image: UIImage) {
        gameImage.image = image
        hideSkeletons()
    }
    
    func updateDescriptionText(_ text: String?) {
        print("Updating description text: \(String(describing: text))")
        descriptionText.text = text
        hideSkeletons()
    }
    
    func showError(_ error: APIError) {
        hideSkeletons()
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func updateScreenshots(_ urls: [URL]) {
        print("Updating screenshots with URLs: \(urls)")
        self.screenshotURLs = urls
        imagesCollectionView.reloadData()
        hideSkeletons()
    }
}

extension DetailViewController: SkeletonCollectionViewDelegate, SkeletonCollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenshotURLs.count
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return ScreenshotCollectionViewCell.identifier
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScreenshotCollectionViewCell.identifier, for: indexPath) as! ScreenshotCollectionViewCell
        let url = screenshotURLs[indexPath.item]
        cell.configure(with: url)
        return cell
    }
}
