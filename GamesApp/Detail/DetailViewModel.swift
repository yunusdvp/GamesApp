import Foundation
import Combine
import Kingfisher
import SafariServices
protocol DetailViewModelInterface: AnyObject {
    var view: DetailViewInterface? { get set }
    func fetchGameDetails()
    func openWebsite(from viewController: UIViewController)
}

final class DetailViewModel: DetailViewModelInterface {
    func openWebsite(from viewController: UIViewController) {
        guard let url = websiteURL else { return }
        let safariVC = SFSafariViewController(url: url)
        viewController.present(safariVC, animated: true, completion: nil)
    }
    
    weak var view: DetailViewInterface?
    
    private let gameId: Int
    private let gameService: GameService
    private var cancellables = Set<AnyCancellable>()
    private var websiteURL: URL?
    
    init(gameId: Int, gameService: GameService = GameService()) {
        self.gameId = gameId
        self.gameService = gameService
    }
    
    func fetchGameDetails() {
        gameService.getGameDetails(byId: gameId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    print("Failed to fetch game details: \(error)")
                    self?.view?.showError(error)
                }
            }, receiveValue: { [weak self] gameDetails in
                print("Fetched game details: \(gameDetails)")
                if let text = gameDetails.descriptionRaw{
                    self?.view?.updateDescriptionText(text)
                }
                
                self?.view?.updateDescriptionText(gameDetails.descriptionRaw)
                
                if let imageUrlString = gameDetails.backgroundImage,
                   let imageUrl = URL(string: imageUrlString) {
                    self?.fetchGameImage(from: imageUrl)
                }
                if let website = gameDetails.website, let url = URL(string: website) {
                    self?.websiteURL = url
                }
                
                self?.fetchScreenshots()
            })
            .store(in: &cancellables)
    }
    
    private func fetchGameImage(from url: URL) {
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let value):
                self.view?.updateGameImage(value.image)
            case .failure(let error):
                print("Error fetching image: \(error)")
            }
        }
    }
    
    private func fetchScreenshots() {
        gameService.getScreenshots(byGameId: gameId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    print("Failed to fetch screenshots: \(error)")
                    self?.view?.showError(error)
                }
            }, receiveValue: { [weak self] screenshots in
                print("Fetched screenshots: \(screenshots)")
                let urls = screenshots.compactMap { URL(string: $0.image) }
                self?.view?.updateScreenshots(urls)
            })
            .store(in: &cancellables)
    }
}
