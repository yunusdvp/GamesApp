import Foundation
import Combine
import Kingfisher

protocol DetailViewModelInterface: AnyObject {
    var view: DetailViewInterface? { get set }
    func fetchGameDetails()
}

final class DetailViewModel: DetailViewModelInterface {
    weak var view: DetailViewInterface?
    
    private let gameId: Int
    private let gameService: GameService
    private var cancellables = Set<AnyCancellable>()
    
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
