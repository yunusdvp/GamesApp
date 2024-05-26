import Combine

class GameService {
    private let apiClient: APIClient

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    func getListOfGames(page: Int = 1) -> AnyPublisher<PostModel, APIError> {
        let parameters = ["page": "\(page)"]
        return apiClient.fetch(endpoint: "games", parameters: parameters)
    }

    func searchGames(byName name: String, page: Int = 1) -> AnyPublisher<PostModel, APIError> {
            let parameters = [
                "search": name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? name,
                "page": "\(page)" 
            ]
            return apiClient.fetch(endpoint: "games", parameters: parameters)
        }
    func getGamesByPlatform(platformId: Int, page: Int = 1) -> AnyPublisher<PostModel, APIError> {
            let parameters = [
                "platforms": "\(platformId)",
                "page": "\(page)"
            ]
            return apiClient.fetch(endpoint: "games", parameters: parameters)
        }
    func getGameDetails(byId id: Int) -> AnyPublisher<GameDetailsModel, APIError>{
    
        apiClient.fetch(endpoint: "games/\(id)")
    }
    
    func getScreenshots(byGameId id: Int) -> AnyPublisher<[Screenshot], APIError> {
            return apiClient.fetch(endpoint: "games/\(id)/screenshots")
                .map { (response: ScreenshotResponse) in response.results }
                .eraseToAnyPublisher()
        }
}

