//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Trang Do on 6/1/23.
//

import SwiftUI

@main
struct MemorizeApp: App {
    //class EmojiMemoryGame gets a free init for during nothing, but that works here because we already init the only var in EmojiMemoryGame class. We make it a let because it is a class (reference type), we will not change the pointer but what it pointed to can be changed. Technically your app is global but it is good practice to set things private and then remove it if you realize that you have to access it somewhere else
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
            //pass the view model game to our EmojiMemoryGameView
        }
    }
}
