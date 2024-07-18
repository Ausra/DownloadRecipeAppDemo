import SwiftUI
import SwiftData

struct RecipeDetailView: View {
    var recipe: Recipe

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                RecipeImageView(image: recipe.viewHeaderImage)
                RecipeTitleView(title: recipe.title)
                RecipeIngredientsView(ingredients: recipe.ingredients ?? [])
                RecipeStepsView(steps: recipe.steps ?? [])
            }
        }
    }
}

private struct RecipeTitleView: View {
    var title: String

    var body: some View {
        Text(title)
    }
}

private struct RecipeIngredientsView: View {
    var ingredients: [Ingredient]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Ingredients")
                .font(.headline)
                .padding(.bottom, 5)
            ForEach(ingredients) { ingredient in
                Text(ingredient.contents)
            }
        }
        .padding()
    }
}

private struct RecipeStepsView: View {
    var steps: [Step]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Steps")
                .font(.headline)
                .padding(.bottom, 5)
            ForEach(steps) { step in
                Text(step.contents)
            }
        }
        .padding()
    }
}

private struct RecipeImageView: View {
    var image: UIImage?

    var body: some View {
        if let uIImage = image {
            Image(uiImage: uIImage)
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .cornerRadius(10)
                .padding()
        } else {
            Color.gray
                .frame(height: 300)
                .cornerRadius(10)
                .padding()
        }
    }
}

#if DEBUG
#Preview {
    let container = Recipe.preview

    let recipes = try? container.mainContext.fetch(
        FetchDescriptor<Recipe>(
            predicate: #Predicate { recipe in
                recipe.title == "Cottage Cheeze Pie"
            }))

    return RecipeDetailView(recipe: recipes?.first ?? Recipe(title: "no value"))
        .modelContainer(container)
}
#endif

