/*
 Abstract:
 A model class that defines the properties of a recipe.
 */

import Foundation
import SwiftData
import SwiftUI
import RecipeScraper

@Model
final class Recipe {
    var id: UUID = UUID()
    var createdAt: Date = Date()
    var title: String = ""
    @Relationship(deleteRule: .cascade, inverse: \Ingredient.recipe)
    var ingredients: [Ingredient]? = []
    var servings: Int = 1

    @Relationship(deleteRule: .cascade, inverse: \Step.recipe)
    var steps: [Step]? = []

    @Relationship(deleteRule: .cascade, inverse: \HeaderImage.recipe)
    var headerImage: HeaderImage?

    var recipeAuthor: String = ""
    var totalCookTime: String = ""
    var prepTime: String = ""
    var cookTime: String = ""

    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        title: String = "",
        ingredients: [Ingredient]? = [],
        servings: Int = 1,
        steps: [Step]? = [],
        headerImage: HeaderImage? = nil,
        recipeAuthor: String = "",
        totalCookTime: String = "",
        prepTime: String = "",
        cookTime: String = ""
    ) {
        self.id = id
        self.createdAt = createdAt
        self.title = title
        self.ingredients = ingredients
        self.servings = servings
        self.steps = steps
        self.headerImage = headerImage
        self.recipeAuthor = recipeAuthor
        self.totalCookTime = totalCookTime
        self.prepTime = prepTime
        self.cookTime = cookTime
    }
}

extension Recipe {
    var viewHeaderImage: UIImage? {
        if let data = headerImage?.data {
            return UIImage(data: data) ?? nil
        } else {
            return nil
        }
    }
}

extension Recipe {
    convenience init(from parsedRecipe: ParsedRecipe) async {
        self.init()
        self.title = parsedRecipe.name ?? "Unknown Title"
        self.recipeAuthor = parsedRecipe.author ?? ""
        self.totalCookTime = parsedRecipe.totalTime ?? ""
        self.prepTime = parsedRecipe.prepTime ?? ""
        self.cookTime =  parsedRecipe.cookTime ?? ""

        if let recipeYield = parsedRecipe.recipeYield, let recipeYieldFirst = recipeYield.first, let servings = Int(recipeYieldFirst) {

            self.servings = servings
        } else {
            self.servings = 1
        }

        if let ingredientContents = parsedRecipe.ingredients {
            self.ingredients = ingredientContents.map { Ingredient(contents: $0, recipe: self) }
        } else {
            self.ingredients = []
        }

        if let instructions = parsedRecipe.instructions {
            self.steps = instructions.map { Step(contents: $0.text ?? "", recipe: self) }
        } else {
            self.steps = []
        }

        if let firstImageUrl = parsedRecipe.images?.first  {
            let dataLoader = DataLoader()
            do {
                if let data = try await dataLoader.loadData(from: firstImageUrl) {
                    let headerImage = HeaderImage(data: data, name: URL(string: firstImageUrl)?.lastPathComponent, recipe: self)
                    self.headerImage = headerImage
                }
            } catch {
                print("Failed to download image: \(error)")
            }
        }
    }
}
