/*
 Abstract:
 A model class that defines the properties of a recipe header image.
 */

import Foundation
import SwiftData

@Model class HeaderImage {
    var id: UUID = UUID()
    var createdAt: Date = Date()

    @Attribute(.externalStorage)
    var data: Data?

    var name: String?

    @Relationship
    var recipe: Recipe?

    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        data: Data? = nil,
        name: String? = "",
        recipe: Recipe? = nil
    ) {
        self.id = id
        self.createdAt = createdAt
        self.data = data
        self.name = name
        self.recipe = recipe
    }
}

