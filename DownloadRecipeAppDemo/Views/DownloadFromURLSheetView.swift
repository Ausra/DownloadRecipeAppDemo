import SwiftUI
import RecipeScraper

struct DownloadFromURLSheetView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var url: String = ""
    @State private var recipe: Recipe?
    @State private var errorMessage: String?
    @State private var isLoading: Bool = false

    @FocusState private var isFocused: Bool

    var body: some View {
        NavigationStack {
            Form {
                if let errorMessage = errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .accessibilityLabel("Error message")
                            .accessibilityHint(errorMessage)
                    }
                }
                Section(
                    content: {
                        TextField("Enter the link", text: $url)
                            .focused($isFocused)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .keyboardType(.URL)
                            .accessibilityLabel("Recipe URL")
                            .accessibilityHint("Type the URL of the recipe you want to download")
                    },
                    footer: {
                        Text("Type the direct link to the recipe and tap Download to save your recipe")
                            .accessibilityLabel("URL hint")
                            .accessibilityHint("Enter a valid URL")
                    })
            }
            .navigationTitle("Download Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                isFocused = true
            })
            .toolbar(
                content: {
                    ToolbarItem(placement: .confirmationAction) {
                        if isLoading {
                            ProgressView()
                                .accessibilityLabel("Loading")
                                .accessibilityHint("Downloading the recipe")
                        } else {
                            Button("Download") {
                                Task {
                                    await scrapeRecipe()
                                }
                            }
                            .accessibilityLabel("Download")
                            .accessibilityHint("Download the recipe from the entered URL")
                        }
                    }
                    ToolbarItem(
                        placement: .cancellationAction,
                        content: {
                            Button("Cancel", action: {
                                dismiss()
                            })
                            .accessibilityLabel("Cancel")
                            .accessibilityHint("Dismiss the download recipe view")
                        })
                })

        }

    }

    @MainActor
    private func scrapeRecipe() async {
        guard !url.isEmpty, let validURL = URL(string: url) else {
            self.errorMessage = "Please enter a valid URL."
            return
        }

        isLoading = true
        let dataLoader = DataLoader()
        let scraper = RecipeScraper()

        do {
            let scrapedRecipe = try await scraper.scrapeRecipe(from: validURL.absoluteString)
            self.recipe = await Recipe(from: scrapedRecipe, using: dataLoader)

            self.errorMessage = nil
        } catch {
            self.errorMessage = error.localizedDescription
            self.recipe = nil
        }

        isLoading = false
        if let newRecipe = recipe {
            modelContext.insert(newRecipe)
            dismiss()
        }
    }
}

#Preview {
    DownloadFromURLSheetView()
}
