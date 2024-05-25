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

    func searchGames(byName name: String, page: Int = 1) -> AnyPublisher<PostModel, APIError> { // Added page parameter
            let parameters = [
                "search": name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? name,
                "page": "\(page)" // Added page parameter
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
}

