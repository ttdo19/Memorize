//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Trang Do on 6/9/23.
//

import SwiftUI
//
class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    //only the ViewModel should be able to create a memory game, so that static function should be private
    private static func createMemoryGame(with numberPairOfCards: Int, in emojisList: [String]) -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairOfCards: numberPairOfCards)  { index in emojisList[index]
        }
    }
    //Our view model publishes the changes from the model to the world because it behaves like an observable object. Using private var here because the ViewModel acts as a gatekeeper between the View and the Model and it also ensures that the only way the Model could be changed is by using the Intent function. 
    @Published private var model: MemoryGame<String>
    
    private var themes = [
        Theme<String>(themeName: "Travel",
                      themeEmojis: ["🚗", "🛞", "🚑", "🚐", "✈️", "🚤", "🛳️", "🚆", "🚘", "🚁", "🛵", "🚀", "🛩️", "🚃", "🛺", "⛵️", "⛱️", "🚖", "⛴️", "🚎", "🚠", "🛴", "🛸", "🚅"],
                      themeNumberPairOfCards: 22, 
                      themePrimaryColor: "cyan",
                      themeSecondaryColor: "blue"),
        Theme<String>(themeName: "Animal",
                      themeEmojis: ["🐱", "🐶", "🐰", "🐭", "🐹", "🦊", "🐻", "🐻‍❄️", "🐼", "🐨", "🐷", "🐮", "🐸", "🐝", "🐥", "🐟", "🦀", "🐙", "🐬", "🦞", "🐌", "🦇", "🦉", "🐛", "🦖", "🦕"],
                      themeNumberPairOfCards: 25,
                      themePrimaryColor: "red",
                      themeSecondaryColor: "orange"),
        Theme<String>(themeName: "Fruit",
                      themeEmojis: ["🍒", "🍓", "🍇", "🍎", "🍉", "🍑", "🍊", "🍋", "🍍", "🍌", "🥑", "🍐", "🥝", "🥭", "🥥", "🍅"],
                      themeNumberPairOfCards: 8,
                      themePrimaryColor: "green",
                      themeSecondaryColor: "mint"),
        Theme<String>(themeName: "Food",
                      themeEmojis: ["🥐", "🥯", "🍞", "🥖", "🥨", "🧀", "🧇", "🥓", "🥩", "🍗", "🍖", "🌭", "🍔", "🍟", "🍕", "🥪", "🌮"],
                      themeNumberPairOfCards: 17,
                      themePrimaryColor: "yellow",
                      themeSecondaryColor: "orange"),
        Theme<String>(themeName: "Astronomy",
                      themeEmojis: ["🌞", "🌝", "🌛", "🌜", "🌕", "🌖", "🌗", "🌘", "🌑", "🌒", "🌓", "🌔", "🌙", "🌎", "🪐", "🌟"],
//                      themeNumberPairOfCards: 14,
                      themePrimaryColor: "blue",
                      themeSecondaryColor: "mint"),
        Theme<String>(themeName: "Flag",
                      themeEmojis: ["🇦🇺", "🇦🇹", "🇦🇿", "🇧🇩", "🇧🇷", "🇨🇦", "🇹🇩", "🇩🇲", "🇱🇷", "🇻🇳", "🇺🇸", "🇰🇷", "🇲🇽", "🇹🇯"],
                      themeNumberPairOfCards: 20,
                      themePrimaryColor: "cyan",
                      themeSecondaryColor: "indigo")
    ]
    
    private var currentTheme: Theme<String>
    
    init() {
        currentTheme = themes.randomElement()!
        model = EmojiMemoryGame.createMemoryGame(with: currentTheme.numberPairOfCards, in: currentTheme.emojis.shuffled())
    }
    
    //the cards could not be private because that's how people could look into the cards in the Model
    var cards: Array<Card> {
        return model.cards //read-only because this is a var whose value is calculated by a function, so we can only get the value
    }
    
    var theme: Theme<String> {
        currentTheme
    }
    
    var getThemeSecondaryColor: Color {
        switch theme.secondaryColor {
            case "red":
                return .red
            case "blue":
                return .blue
            case "teal":
                return .teal
            case "yellow":
                return .yellow
            case "mint":
                return .mint
            case "orange":
                return .orange
            case "indigo":
                return .indigo
            default:
                return .gray
        }
    }
    
    var getGradient: LinearGradient {
        LinearGradient(gradient: Gradient(colors: [getThemePrimaryColor , getThemeSecondaryColor]), startPoint: .top, endPoint: .bottom)
    }
    
    var getThemePrimaryColor: Color {
        switch theme.primaryColor {
            case "red":
                return .red
            case "blue":
                return .blue
            case "green":
                return .green
            case "yellow":
                return .yellow
            case "cyan":
                return .cyan
            case "orange":
                return .orange
            default:
                return .gray
        }
    }
    
    var score: Int {
        return model.score
    }
    
    var numberOfMatches: Int {
        return model.numberOfMatches
    }
    //MARK: - User Intent(s)
    
    func choose(_ card: Card) {
//        objectWillChange.send() will let others know that this model changes or you can add @Published
        model.choose(card)
    }
    
    func restart() {
        currentTheme = themes.randomElement()!
        model = EmojiMemoryGame.createMemoryGame(with: currentTheme.numberPairOfCards, in: currentTheme.emojis.shuffled())
    }
}




