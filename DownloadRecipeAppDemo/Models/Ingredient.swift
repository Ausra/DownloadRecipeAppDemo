/*
 Abstract:
 A model class that defines the properties of a recipe ingredient.
 */

import Foundation
import SwiftData

@Model
final class Ingredient {
    var id: UUID = UUID()
    var createdAt: Date = Date()

    var contents: String = ""

    @Relationship
    var recipe: Recipe?

    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        contents: String = "",
        recipe: Recipe? = nil
    ) {
        self.id = id
        self.createdAt = createdAt
        self.contents = contents
        self.recipe = recipe
    }

}

