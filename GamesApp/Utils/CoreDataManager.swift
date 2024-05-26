import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "GamesApp")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                print("Unable to load persistent stores: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Add Favorite Game
    func addFavoriteGame(id: Int32, name: String, imageUrl: String) {
        let favoriteGame = FavoriteGames(context: context)
        favoriteGame.id = id
        favoriteGame.name = name
        favoriteGame.imageUrl = imageUrl
        
        saveContext()
    }
    
    // MARK: - Fetch Favorite Games
    func fetchFavoriteGames() -> [FavoriteGames] {
        let fetchRequest: NSFetchRequest<FavoriteGames> = FavoriteGames.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch favorite games: \(error)")
            return []
        }
    }
    
    // MARK: - Remove Favorite Game
    func removeFavoriteGame(withId id: Int32) {
        let fetchRequest: NSFetchRequest<FavoriteGames> = FavoriteGames.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let games = try context.fetch(fetchRequest)
            for game in games {
                context.delete(game)
            }
            saveContext()
        } catch {
            print("Failed to fetch or delete favorite game: \(error)")
        }
    }
    
    // MARK: - Check if Game is Favorite
    func isFavoriteGame(withId id: Int32) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteGames> = FavoriteGames.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let games = try context.fetch(fetchRequest)
            return !games.isEmpty
        } catch {
            print("Failed to fetch favorite game: \(error)")
            return false
        }
    }
    
    // MARK: - Save Context
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
}

