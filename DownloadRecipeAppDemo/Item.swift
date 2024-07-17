//
//  Item.swift
//  DownloadRecipeAppDemo
//
//  Created by Ausra Balyne on 17/07/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
