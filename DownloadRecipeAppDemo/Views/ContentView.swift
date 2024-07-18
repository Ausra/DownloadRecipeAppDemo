import SwiftUI
import SwiftData
import RecipeScraper

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Recipe.createdAt, order: .reverse) private var recipes: [Recipe]

    @State private var downloadRecipeSheetPresent: Bool = false

    var body: some View {
        NavigationStack{
            List {
                ForEach(recipes) { recipe in
                    NavigationLink {
                        RecipeDetailView(recipe: recipe)
                    } label: {
                        Text(recipe.title)
                            .accessibilityLabel("Recipe title")
                            .accessibilityValue(recipe.title)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                        .accessibilityLabel("Edit")
                        .accessibilityHint("Edit the list of recipes")
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Recipe", systemImage: "plus")
                            .accessibilityLabel("Add Recipe")
                            .accessibilityHint("Add a new recipe")
                    }
                }
            }
            .sheet(
                isPresented: $downloadRecipeSheetPresent,
                content: { DownloadFromURLSheetView() }
            )
            .navigationTitle("Recipes")
            .accessibilityElement(children: .contain)
        }
    }
    
    private func addItem() {
        downloadRecipeSheetPresent = true
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let recipe = recipes[index]
                modelContext.delete(recipes[index])
                UIAccessibility.post(notification: .announcement, argument: "Deleted recipe: \(recipe.title)")
            }
        }
    }
}

#Preview {
    let container = Recipe.preview

    return ContentView()
        .modelContainer(container)
}
