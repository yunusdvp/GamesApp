import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let gamesVC = HomeViewController()
        gamesVC.tabBarItem = UITabBarItem(title: "Games", image: UIImage(systemName: "gamecontroller"), tag: 0)

        let favoritesVC = FavoritesViewController(viewModel: FavoritesViewModel())
        //let favoritesViewModel = FavoritesViewModel()
        //favoritesVC.setViewModel(favoritesViewModel)
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star.fill"), tag: 1)

        viewControllers = [
            UINavigationController(rootViewController: gamesVC),
            UINavigationController(rootViewController: favoritesVC)
        ]
    }
}
