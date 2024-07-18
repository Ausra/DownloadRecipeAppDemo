import SwiftUI
import RecipeScraper

struct DownloadFromURLSheetView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var url: String = ""
    @State private var recipe: ParsedRecipe?
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
                        } else {
                            Button("Download") {
                                Task {
                                    await scrapeRecipe()
                                }
                            }
                        }
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

    }

    @MainActor
    private func scrapeRecipe() async {
        guard !url.isEmpty, let validURL = URL(string: url) else {
            self.errorMessage = "Please enter a valid URL."
            return
        }

        isLoading = true

        let scraper = RecipeScraper()

        do {
            let scrapedRecipe = try await scraper.scrapeRecipe(from: validURL.absoluteString)
            self.recipe = scrapedRecipe
            self.errorMessage = nil
        } catch {
            self.errorMessage = error.localizedDescription
            self.recipe = nil
        }

        isLoading = false
    }
}

#Preview {
    DownloadFromURLSheetView()
}
