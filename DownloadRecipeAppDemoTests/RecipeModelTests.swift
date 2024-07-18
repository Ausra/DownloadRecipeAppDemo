import Foundation
import UIKit
import SwiftData
import RecipeScraper
import Testing
@testable import DownloadRecipeAppDemo

@MainActor
final class RecipeModelTests {

    var container: ModelContainer

    var context: ModelContext


    init() async throws {
        container = try ModelContainer(
            for: Recipe.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        context = container.mainContext
    }

    deinit {
        do {
            try container.erase()
        } catch {
            print(error.localizedDescription)
        }
    }

    @Test func testRecipeInitialization() throws {

        let ingredients = [
            Ingredient(contents: "Flour"),
            Ingredient(contents: "Sugar")
        ]
        let steps = [
            Step(contents: "Mix ingredients"),
            Step(contents: "Bake")
        ]
        let headerImage = HeaderImage(data: Data(), name: "image.png")

        let recipe = Recipe(
            title: "Cake",
            ingredients: ingredients,
            servings: 4,
            steps: steps,
            headerImage: headerImage,
            recipeAuthor: "John Doe",
            totalCookTime: "1h 30m",
            prepTime: "30m",
            cookTime: "1h"
        )

        context.insert(recipe)

        try context.save()

        let fetchedRecipes = try context.fetch(FetchDescriptor<Recipe>())

        #expect(fetchedRecipes.count == 1)
        let fetchedRecipe = fetchedRecipes.first!

        #expect(fetchedRecipe.title == "Cake")
        #expect(fetchedRecipe.ingredients?.count == 2)
        #expect(fetchedRecipe.steps?.count == 2)
        #expect(fetchedRecipe.headerImage?.name == "image.png")
        #expect(fetchedRecipe.recipeAuthor == "John Doe")
        #expect(fetchedRecipe.totalCookTime == "1h 30m")
        #expect(fetchedRecipe.prepTime == "30m")
        #expect(fetchedRecipe.cookTime == "1h")
        #expect(fetchedRecipe.servings == 4)
    }

    @Test func testRecipeFromParsedRecipe() async throws {
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

        let decoder = JSONDecoder()
        let parsedRecipe = try decoder.decode(ParsedRecipe.self, from: parsedRecipeJSON)

        // Mock DataLoader
        struct DataLoaderMock: DataLoaderProtocol {
            var result: Result<Data, Error>?

            init(result: Result<Data, Error>?) {
                self.result = result
            }

            func loadData(from urlString: String) async throws -> Data? {
                return try result?.get()
            }
        }

        struct NetworkingMock: Networking {
            var result = Result<Data, Error>.success(Data())

            func data(
                from url: URL
            ) async throws -> (Data, URLResponse) {
                try (result.get(), URLResponse())
            }
        }

        let mockNetworking = NetworkingMock(result: .success(parsedRecipeJSON))
        let dataLoader = DataLoader(networking: mockNetworking)
        let recipe = await Recipe(from: parsedRecipe, using: dataLoader)

        context.insert(recipe)
        try context.save()

        let fetchedRecipes = try context.fetch(FetchDescriptor<Recipe>())

        #expect(fetchedRecipes.count == 1)
        let fetchedRecipe = fetchedRecipes.first!

        #expect(fetchedRecipe.title == "Pancakes")
        #expect(fetchedRecipe.ingredients?.count == 3)
        #expect(fetchedRecipe.steps?.count == 2)
        #expect(fetchedRecipe.recipeAuthor == "Jane Doe")
        #expect(fetchedRecipe.totalCookTime == "30m")
        #expect(fetchedRecipe.prepTime == "10m")
        #expect(fetchedRecipe.cookTime == "20m")
        #expect(fetchedRecipe.servings == 4)
        #expect(fetchedRecipe.headerImage != nil)
    }

    @Test func testRecipeViewHeaderImage() throws {
        let imageData = UIImage(named: "CheezePie")?.pngData()
        let headerImage = HeaderImage(data: imageData, name: "testImage.png")

        let recipe = Recipe(title: "Smoothie", headerImage: headerImage)

        context.insert(recipe)
        try context.save()

        let fetchedRecipes = try context.fetch(FetchDescriptor<Recipe>())

        #expect(fetchedRecipes.count == 1)
        let fetchedRecipe = fetchedRecipes.first!

        #expect(fetchedRecipe.viewHeaderImage != nil)
    }

}
