import SwiftUI
import SwiftData
import RecipeScraper

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var recipes: [Recipe]

    @State private var downloadRecipeSheetPresent: Bool = false

    var body: some View {
        NavigationSplitView(sidebar: {
            List {
                ForEach(recipes) { recipe in
                    NavigationLink {
                        Text(recipe.title)
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
        }, detail: {
            Text("Select an item")
        })
    }

    private func addItem() {
        withAnimation {
            let newItem = Recipe(title: "new")
            modelContext.insert(newItem)
        }
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
    ContentView()
        .modelContainer(for: Recipe.self, inMemory: true)
}
