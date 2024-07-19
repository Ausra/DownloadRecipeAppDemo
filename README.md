# Download Recipe Demo App

This is a SwiftUI-based application that allows users to manage their recipes. Users can add recipes by downloading them from URLs, view detailed recipe information, and delete recipes. It has been built to show case the [RecipeScraper](https://github.com/Ausra/RecipeScraper) and [JSONLDDecoder](https://github.com/Ausra/JSONLDDecoder) packaged in action. The app also leverages `SwiftData` for data persistence.

## Features

- **Add Recipes**: Download recipes from a URL and save them to the app.
- **View Recipes**: Display a list of recipes and view detailed information for each recipe.
- **Delete Recipes**: Remove recipes from the app.
- **Accessibility**: The app includes accessibility features for better usability.

## Demo
A recipe has been scraped and image downloaded from the following website: 
https://www.bbcgoodfood.com/recipes/cupcakes

  ![demoApp](https://github.com/Ausra/DownloadRecipeAppDemo/blob/main/DownloadRecipeDemo.gif)

## Requirements
- iOS 18.0+
- Xcode 16.0+
- Swift 6.0+

## Installation

1. Clone the repository:
   ```swift
   git clone https://github.com/Ausra/DownloadRecipeAppDemo.git
   cd DownloadRecipeAppDemo
2. Open the project in Xcode:
   ```swift
   open RecipeApp.xcodeproj
3. Build and run the project on your simulator or device.


## Usage

### Adding a Recipe
1. Tap the "+" button on the navigation bar.
2. Enter the URL of the recipe you want to download.
3. Tap the "Download" button to fetch and save the recipe.

### Viewing Recipes
- On the main screen, a list of recipes is displayed. Tap on any recipe to view its details.

### Deleting Recipes
1. Tap the "Edit" button on the navigation bar.
2. Select the recipes you want to delete and tap the delete button.

## Code Overview
### ContentView
The main view displaying the list of recipes.
```swift
struct ContentView: View {
    // ...
}
```
### DownloadFromURLSheetView
The view presented as a sheet for downloading recipes from a URL.
```swift
struct DownloadFromURLSheetView: View {
    // ...
}
```

### RecipeDetailView
The view displaying detailed information about a selected recipe.
```swift
struct RecipeDetailView: View {
    // ...
}
```
### Recipe Model
Defines the properties of a recipe.
```swift
@Model
final class Recipe {
    // ...
}
```
### DownloadRecipeViewModel
Handles the logic for downloading and saving a recipe.
```swift
@Observable
class DownloadRecipeViewModel {
    // ...
}
```
### Accessibility
The app includes accessibility labels, hints, and values to ensure a smooth experience for users with disabilities. For example:
```swift
.accessibilityLabel("Recipe title")
.accessibilityHint("Type the URL of the recipe you want to download")
```
### License
This project is licensed under the MIT License. See the LICENSE file for more information.

### Acknowledgments
- [RecipeScraper](https://github.com/Ausra/RecipeScraper)

