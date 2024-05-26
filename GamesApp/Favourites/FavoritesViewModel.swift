import Foundation
import Combine

protocol FavoritesViewModelProtocol: AnyObject {
    var view: FavoritesViewProtocol? { get set }
    var favoriteGames: [FavoriteGames] { get }
    var favoriteGamesPublisher: Published<[FavoriteGames]>.Publisher { get }
    func fetchFavoriteGames()
    func favoriteGamesCount() -> Int
    func removeFavoriteGame(byId id: Int32)
}

final class FavoritesViewModel: FavoritesViewModelProtocol {
    weak var view: FavoritesViewProtocol?
    
    @Published private(set) var favoriteGames: [FavoriteGames] = []
    private var cancellables = Set<AnyCancellable>()
    
    var favoriteGamesPublisher: Published<[FavoriteGames]>.Publisher { $favoriteGames }
    
    func fetchFavoriteGames() {
        let favorites = CoreDataManager.shared.fetchFavoriteGames()
        if favorites.isEmpty {
            print("No favorite games found")
        }
        self.favoriteGames = favorites
        view?.reloadData()
    }
    
    func favoriteGamesCount() -> Int {
        return favoriteGames.count
    }
    
    func removeFavoriteGame(byId id: Int32) {
        CoreDataManager.shared.removeFavoriteGame(withId: id)
        fetchFavoriteGames()
    }
}
