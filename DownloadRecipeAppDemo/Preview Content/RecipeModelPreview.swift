/*
 Abstract:
 This preview data file initializes a ModelContainer with in-memory storage for SwiftData entities including Recipe, Ingredient,
 Step, and HeaderImage. It sets up sample data for three recipes: "Cottage Cheeze Pie", "Scrambled Eggs", and "Apple Pie". Each
 recipe is populated with relevant ingredients and steps, and an image is associated with the "Cottage Cheeze Pie" recipe. This
 setup facilitates testing and previewing of the data model within SwiftUI views.
 */


import Foundation
import SwiftUI
import SwiftData

extension Recipe {
    @MainActor
    static var preview: ModelContainer {
        let schema = Schema([
            Recipe.self,
            Ingredient.self,
            Step.self,
            HeaderImage.self
        ])
        // swiftlint:disable:next force_try
        let container = try! ModelContainer(
            for: schema, configurations:
                ModelConfiguration(isStoredInMemoryOnly: true))
        // MARK: - Recipes
        let cottageCheezePie = Recipe(title: "Cottage Cheeze Pie")
        container.mainContext.insert(cottageCheezePie)

        let scrambledEggs = Recipe(title: "Scrambled Eggs")
        container.mainContext.insert(scrambledEggs)

        let applePie = Recipe(title: "Apple Pie")
        container.mainContext.insert(applePie)

        try? container.mainContext.save()

        // MARK: - Ingredients
        // Adding ingredients to the recipes
        let rBanana = Ingredient(contents: "1 Banana")
        container.mainContext.insert(rBanana)

        let rCottageCheeze = Ingredient(contents: "200g Cottage Cheeze")
        container.mainContext.insert(rCottageCheeze)

        let rEggs = Ingredient(contents: "2 Eggs")
        container.mainContext.insert(rEggs)

        let rMana = Ingredient(contents: "3 spoons Mana")
        container.mainContext.insert(rMana)

        let rRaisins = Ingredient(contents: "50g Raisins")
        container.mainContext.insert(rRaisins)

        let rMilk = Ingredient(contents: "60ml Milk")
        container.mainContext.insert(rMilk)

        cottageCheezePie.ingredients = [rBanana, rCottageCheeze, rEggs, rMana, rRaisins, rMilk]

        scrambledEggs.ingredients = [rEggs, rMilk]

        try? container.mainContext.save()

        // MARK: - Steps

        let step1 = Step(contents: "boil water and pour it on to the raisins")
        container.mainContext.insert(step1)

        let step2 = Step(contents: "let it cool")
        container.mainContext.insert(step2)

        let step3 = Step(contents: "mix milk and mana")
        container.mainContext.insert(step3)

        let step4 = Step(contents: "whisk banana with eggs and cottage cheeze")
        container.mainContext.insert(step4)

        let step5 = Step(contents: "add mana with milk and drained raises to the mix")
        container.mainContext.insert(step5)

        let step6 = Step(contents: "put into the oven for 40 min in 200celsius")
        container.mainContext.insert(step6)

        // adding steps to the recipe
        cottageCheezePie.steps = [step1]
        try? container.mainContext.save()
        scrambledEggs.steps = [step2, step3, step4]
        try? container.mainContext.save()
        applePie.steps = [step5, step6]
        try? container.mainContext.save()

        // MARK: - Image
        let imageData = UIImage(named: "CheezePie")?.pngData() ?? nil
        let image = HeaderImage(data: imageData)
        cottageCheezePie.headerImage = image
        try? container.mainContext.save()

        return container
    }
}
