import SwiftUI
import RecipeScraper

struct DownloadFromURLSheetView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var url: String = ""
    @State private var recipe: ParsedRecipe?
    @State private var errorMessage: String?

    @FocusState private var isFocused: Bool

    var body: some View {
        Form {
            Section(
                content: {
                    TextField("Paste the link", text: $url)
                        .focused($isFocused)
                },
                footer: { Text("Paste in the direct link to the recipe and tap Download to save your recipe")})
        }
        .onAppear(perform: {
            isFocused = true
        })
        .toolbar(content: {
            ToolbarItem(placement: .confirmationAction) {
                Button("Download", action: {
                    Task {
                        await scrapeRecipe()
                    }
                })
            }
            ToolbarItem(
                placement: .cancellationAction,
                content: {
                    Button("Cancel", action: {
                        dismiss()
                    })
                })
        })
    }

    private func scrapeRecipe() async {
        let scraper = RecipeScraper()

        do {
            let scrapedRecipe = try await scraper.scrapeRecipe(from: url)
            DispatchQueue.main.async {
                self.recipe = scrapedRecipe
                self.errorMessage = nil
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.recipe = nil
            }
        }
    }
}

#Preview {
    DownloadFromURLSheetView()
}
