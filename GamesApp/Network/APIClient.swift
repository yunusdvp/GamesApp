import Foundation
import Combine

enum APIError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
}

class APIClient {
    static let shared = APIClient()
    private let baseURL = "https://api.rawg.io/api/"
    private let apiKey = "f00bc32deb804013b62e122ac698f1d8" // Replace with your actual API key

    private init() {}

    func fetch<T: Decodable>(endpoint: String, parameters: [String: String] = [:]) -> AnyPublisher<T, APIError> {
        var urlComponents = URLComponents(string: baseURL + endpoint)!
        var queryItems = [URLQueryItem(name: "key", value: apiKey)]
        for (key, value) in parameters {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                return error is DecodingError ? .decodingFailed : .requestFailed
            }
            .eraseToAnyPublisher()
    }
}
