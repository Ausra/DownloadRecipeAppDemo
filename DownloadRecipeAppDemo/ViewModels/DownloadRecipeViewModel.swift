import Foundation
import RecipeScraper
import SwiftData

@Observable
class DownloadRecipeViewModel {
    var url: String = ""
    var recipe: Recipe?
    var errorMessage: String?
    var isLoading: Bool = false

    private var modelContext: ModelContext
    private var scraper: RecipeScraper
    private var dataLoader: DataLoader

    init(modelContext: ModelContext, scraper: RecipeScraper, dataLoader: DataLoader) {
        self.modelContext = modelContext
        self.scraper = scraper
        self.dataLoader = dataLoader
    }

    @MainActor
    func scrapeRecipe() async {
        guard !url.isEmpty, let validURL = URL(string: url) else {
            self.errorMessage = "Please enter a valid URL."
            return
        }

        isLoading = true

        do {
            let scrapedRecipe = try await scraper.scrapeRecipe(from: validURL.absoluteString)
            self.recipe = await Recipe(from: scrapedRecipe, using: dataLoader)

            self.errorMessage = nil
        } catch {
            self.errorMessage = error.localizedDescription
            self.recipe = nil
        }

        isLoading = false
        if let newRecipe = recipe {
            modelContext.insert(newRecipe)
        }
    }
}
