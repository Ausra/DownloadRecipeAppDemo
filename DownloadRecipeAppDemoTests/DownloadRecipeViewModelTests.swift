import Foundation
import SwiftData
import RecipeScraper
import Testing
@testable import DownloadRecipeAppDemo

@MainActor
struct DownloadRecipeViewModelTests {

    var container: ModelContainer
    var context: ModelContext
    var viewModel: DownloadRecipeViewModel

    var mockNetworking: NetworkingMock
    var dataLoader: DataLoader
    var parserMock: RecipeParserMock
    var mockScraper: RecipeScraper
    var parsedRecipe: ParsedRecipe


    let parsedRecipeJSON = """
        {
            "name": "Pancakes",
            "image": ["https://example.com/image.png"],
            "recipeYield": ["4"],
            "author": { "name": "Jane Doe" },
            "totalTime": "30m",
            "prepTime": "10m",
            "cookTime": "20m",
            "recipeInstructions": [
                { "text": "Mix ingredients" },
                { "text": "Cook on skillet" }
            ],
            "recipeIngredient": ["Flour", "Eggs", "Milk"]
        }
        """.data(using: .utf8)!



    init() async throws {
        container = try ModelContainer(
            for: Recipe.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        context = container.mainContext

        let decoder = JSONDecoder()
        parsedRecipe = try decoder.decode(ParsedRecipe.self, from: parsedRecipeJSON)
        mockNetworking = NetworkingMock(result: .success(parsedRecipeJSON))
        dataLoader = DataLoader(networking: mockNetworking)
        parserMock = RecipeParserMock(result: .success(parsedRecipe))
        mockScraper = RecipeScraper(recipeParser: parserMock)

        viewModel = DownloadRecipeViewModel(modelContext: context, scraper: mockScraper, dataLoader: dataLoader)
    }


    @Test func testScrapeRecipeSuccess() async throws {
        viewModel.url = "https://valid.url"

        await viewModel.scrapeRecipe()

        #expect(viewModel.recipe?.title == "Pancakes")
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.isLoading == false)

        let fetchedRecipes = try context.fetch(FetchDescriptor<Recipe>())
        #expect(fetchedRecipes.count == 1)

        do {
            try container.erase()
        } catch {
            print(error.localizedDescription)
        }
    }

    @Test mutating func testScrapeRecipeInvalidURL() async {

        let expectedError = RecipeParserError.invalidHTML
        parserMock = RecipeParserMock(result: .failure(expectedError))
        mockScraper = RecipeScraper(recipeParser: parserMock)

        let viewModelWithError = DownloadRecipeViewModel(modelContext: context, scraper: mockScraper, dataLoader: dataLoader)

        viewModelWithError.url = "wwwdd"

        await viewModelWithError.scrapeRecipe()

        #expect(viewModelWithError.errorMessage == RecipeParserError.invalidHTML.localizedDescription)
        #expect(viewModelWithError.recipe == nil)
        #expect(viewModelWithError.isLoading == false)

        do {
            let fetchedRecipes = try context.fetch(FetchDescriptor<Recipe>())
            #expect(fetchedRecipes.count == 0)
        } catch {
            Issue.record(error)
        }


    }

    @Test mutating func testScrapeRecipeFailure() async {
        let expectedError = RecipeParserError.scrapingError
        parserMock = RecipeParserMock(result: .failure(expectedError))
        mockScraper = RecipeScraper(recipeParser: parserMock)

        let viewModelWithError = DownloadRecipeViewModel(modelContext: context, scraper: mockScraper, dataLoader: dataLoader)


        viewModelWithError.url = "https://valid.url"

        await viewModelWithError.scrapeRecipe()

        #expect(viewModelWithError.errorMessage != nil)
        #expect(viewModelWithError.recipe == nil)
        #expect(viewModelWithError.isLoading == false)

        do {
            let fetchedRecipes = try context.fetch(FetchDescriptor<Recipe>())
            #expect(fetchedRecipes.count == 0)
        } catch {
            Issue.record(error)
        }
    }

}


