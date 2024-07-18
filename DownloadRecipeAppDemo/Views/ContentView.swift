import SwiftUI
import SwiftData
import RecipeScraper

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var recipes: [Recipe]

    @State private var downloadRecipeSheetPresent: Bool = false

    var body: some View {
        NavigationSplitView(
            sidebar: {
                List {
                    ForEach(recipes) { recipe in
                        NavigationLink {
                            RecipeDetailView(recipe: recipe)
                        } label: {
                            Text(recipe.title)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }

            },
            detail: {
                Text("recipe.title")
            }
        ).sheet(
            isPresented: $downloadRecipeSheetPresent,
            content: { DownloadFromURLSheetView() }
        )
    }

    private func addItem() {
        downloadRecipeSheetPresent = true
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(recipes[index])
            }
        }
    }
}

#Preview {
    let container = Recipe.preview

    return ContentView()
        .modelContainer(container)
}
