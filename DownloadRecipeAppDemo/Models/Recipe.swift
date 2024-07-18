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
    var recipeSource: String = ""
    var totalCookTime: String = ""
    var prepTime: String = ""
    var cookTime: String = ""
    var calories: String = ""

    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        title: String = "",
        ingredients: [Ingredient]? = [],
        servings: Int = 1,
        steps: [Step]? = [],
        headerImage: HeaderImage? = nil,
        recipeAuthor: String = "",
        recipeSource: String = "",
        totalCookTime: String = "",
        prepTime: String = "",
        cookTime: String = "",
        calories: String = ""
    ) {
        self.id = id
        self.createdAt = createdAt
        self.title = title
        self.ingredients = ingredients
        self.servings = servings
        self.steps = steps
        self.headerImage = headerImage
        self.recipeAuthor = recipeAuthor
        self.recipeSource = recipeSource
        self.totalCookTime = totalCookTime
        self.prepTime = prepTime
        self.cookTime = cookTime
        self.calories = calories
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
    convenience init(from parsedRecipe: ParsedRecipe) {
        self.init()
        self.title = parsedRecipe.name ?? "Unknown Title"
    }
}
