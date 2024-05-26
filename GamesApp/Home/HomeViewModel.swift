import Foundation
import Combine

protocol HomeViewModelInterface: AnyObject {
    var view: HomeViewInterface? { get set }
    var results: [Result] { get }
    var isSearching: Bool { get }
    var isDataLoading: Bool { get set }
    
    func viewDidLoad()
    func viewWillDisappear()
    func loadMoreData()
    func searchGames(byName name: String)
    func clearSearch()
    func autoScroll()
    func handleScroll(offsetY: CGFloat, contentHeight: CGFloat, frameHeight: CGFloat)
    func startAutoScrollTimer()
    func stopAutoScrollTimer()
    func searchBarTextDidChange(searchText: String)
    func searchBarSearchButtonClicked(query: String)
    func fetchAllGames()
    func fetchGames(for platformId: Int, loadMore: Bool)
    func allGamesButtonTapped()
}

final class HomeViewModel: HomeViewModelInterface {
    
    weak var view: HomeViewInterface?
    
    private var allResults = [Result]()
    private var filteredResults = [Result]()
    private var nextPageURL: String?
    private var searchNextPageURL: String?
    private var platformNextPageURL: String?
    private var isLoading = false
    private(set) var isSearching = false
    var isDataLoading = true
    private var cancellables = Set<AnyCancellable>()
    private var currentPlatformId: Int?
    
    private let gameService: GameService
    private var autoScrollTimer: Timer?
    
    init(gameService: GameService = GameService()) {
        self.gameService = gameService
    }
    
    var results: [Result] {
        return isSearching ? filteredResults : allResults
    }
    
    func viewDidLoad() {
        loadInitialData()
        view?.prepareCollectionView()
        view?.prepareTopCollectionView()
        view?.prepareFilteredOptionCollectionView()
        view?.setupSearchBar()
        startAutoScrollTimer()
    }
    
    func viewWillDisappear() {
        stopAutoScrollTimer()
    }
    
    func loadMoreData() {
        guard !isLoading else { return }
        if let platformId = currentPlatformId {
            fetchGames(for: platformId, loadMore: true)
        } else {
            guard let urlToLoad = isSearching ? searchNextPageURL : nextPageURL else { return }
            isLoading = true
            fetchData(urlString: urlToLoad)
        }
    }
    
    func searchGames(byName name: String) {
        isSearching = true
        currentPlatformId = nil
        resetPagination()
        
        gameService.searchGames(byName: name, page: 1)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: handleCompletion, receiveValue: { [weak self] postModel in
                self?.handleSearchResponse(postModel: postModel)
            })
            .store(in: &cancellables)
    }
    
    func clearSearch() {
        isSearching = false
        currentPlatformId = nil
        filteredResults.removeAll()
        searchNextPageURL = nil
        view?.reloadCollectionView()
        view?.showTopCollectionView()
    }
    
    private func fetchData(urlString: String) {
        let isSearch = urlString.contains("search")
        let page = getPage(from: urlString)
        let searchQuery = isSearch ? getSearchQuery(from: urlString) : nil
        
        let publisher: AnyPublisher<PostModel, APIError> = isSearch ? gameService.searchGames(byName: searchQuery ?? "", page: page) : gameService.getListOfGames(page: page)
        
        publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: handleCompletion, receiveValue: { [weak self] postModel in
                self?.handleDataResponse(postModel: postModel, isSearch: isSearch)
            })
            .store(in: &cancellables)
    }
    
    private func handleDataResponse(postModel: PostModel, isSearch: Bool) {
        if isSearch {
            filteredResults.append(contentsOf: postModel.results ?? [])
            searchNextPageURL = postModel.next
        } else {
            allResults.append(contentsOf: postModel.results ?? [])
            nextPageURL = postModel.next
        }
        isDataLoading = false
        view?.reloadCollectionView()
        isLoading = false
    }
    
    private func handleSearchResponse(postModel: PostModel) {
        filteredResults.append(contentsOf: postModel.results ?? [])
        searchNextPageURL = postModel.next
        isDataLoading = false
        view?.reloadCollectionView()
        isLoading = false
    }
    
    private func handleCompletion(completion: Subscribers.Completion<APIError>) {
        isLoading = false
        if case .failure(let error) = completion {
            handleDataError(error)
        }
    }
    
    private func handleDataError(_ error: APIError) {
        view?.showError(error: error)
    }
    
    private func loadInitialData() {
        resetPagination()
        gameService.getListOfGames(page: 1)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: handleCompletion, receiveValue: { [weak self] postModel in
                self?.handleDataResponse(postModel: postModel, isSearch: false)
            })
            .store(in: &cancellables)
    }
    
    private func resetPagination() {
        allResults.removeAll()
        filteredResults.removeAll()
        searchNextPageURL = nil
        nextPageURL = nil
        platformNextPageURL = nil
        currentPlatformId = nil
    }
    
    private func getPage(from urlString: String) -> Int {
        URLComponents(string: urlString)?.queryItems?.first(where: { $0.name == "page" })?.value.flatMap(Int.init) ?? 1
    }
    
    private func getSearchQuery(from urlString: String) -> String? {
        URLComponents(string: urlString)?.queryItems?.first(where: { $0.name == "search" })?.value ?? ""
    }
    
    func autoScroll() {
        guard results.count > 1 else { return }
        view?.scrollToNextTopItem(currentItem: 0, nextItem: 1)
    }
    
    func handleScroll(offsetY: CGFloat, contentHeight: CGFloat, frameHeight: CGFloat) {
        if offsetY > contentHeight - frameHeight * 2 {
            loadMoreData()
        }
    }
    
    func startAutoScrollTimer() {
        autoScrollTimer = Timer.scheduledTimer(timeInterval: AutoScroll.timeInterval, target: self, selector: #selector(autoScrollTimerFired), userInfo: nil, repeats: true)
    }
    
    func stopAutoScrollTimer() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }
    
    @objc private func autoScrollTimerFired() {
        autoScroll()
    }
    
    func searchBarTextDidChange(searchText: String) {
        if searchText.count > 2 {
            view?.hideTopCollectionView()
            searchGames(byName: searchText)
        } else if searchText.isEmpty {
            clearSearch()
            allGamesButtonTapped()
            view?.showTopCollectionView()
        }
    }
    
    func searchBarSearchButtonClicked(query: String) {
        searchGames(byName: query)
        view?.hideTopCollectionView()
    }
    
    func fetchAllGames() {
        currentPlatformId = nil
        loadInitialData()
        isSearching = false
        view?.showTopCollectionView()
    }
    
    func fetchGames(for platformId: Int, loadMore: Bool = false) {
        if !loadMore {
            resetPagination()
            currentPlatformId = platformId
            isDataLoading = true
            view?.reloadCollectionView()
        }
        
        gameService.getGamesByPlatform(platformId: platformId, page: loadMore ? getPage(from: platformNextPageURL ?? "") : 1)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: handleCompletion, receiveValue: { [weak self] postModel in
                self?.handlePlatformResponse(postModel: postModel)
            })
            .store(in: &cancellables)
    }
    
    private func handlePlatformResponse(postModel: PostModel) {
        allResults.append(contentsOf: postModel.results ?? [])
        platformNextPageURL = postModel.next
        isDataLoading = false
        view?.reloadCollectionView()
        isLoading = false
    }
    
    func allGamesButtonTapped() {
        fetchAllGames()
    }
}
