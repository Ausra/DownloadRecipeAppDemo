import SwiftUI
import SwiftData
import RecipeScraper

struct DownloadFromURLSheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel: DownloadRecipeViewModel
    var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        let dataLoader = DataLoader()
        let scraper = RecipeScraper()
        let viewModel = DownloadRecipeViewModel(
            modelContext: modelContext,
            scraper: scraper,
            dataLoader: dataLoader
        )
        _viewModel = State(initialValue: viewModel)
        self.modelContext = modelContext
    }
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                if let errorMessage = viewModel.errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .accessibilityLabel("Error message")
                            .accessibilityHint(errorMessage)
                    }
                }
                Section(
                    content: {
                        TextField("Enter the link", text: $viewModel.url)
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
                        if viewModel.isLoading {
                            ProgressView()
                                .accessibilityLabel("Loading")
                                .accessibilityHint("Downloading the recipe")
                        } else {
                            Button("Download") {
                                Task {
                                    await viewModel.scrapeRecipe()
                                    if viewModel.recipe != nil {
                                        dismiss()
                                    }
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
}

#if DEBUG
#Preview {
    let container = Recipe.preview
    
    DownloadFromURLSheetView(modelContext: container.mainContext)
}
#endif
