//
//  Theme.swift
//  Memorize
//
//  Created by Trang Do on 6/12/23.
//

import Foundation

struct Theme<CardContent> {

    let name: String
    let emojis: [CardContent]
    let numberPairOfCards: Int
    let primaryColor: String
    let secondaryColor: String
    
    init(themeName: String, themeEmojis: [CardContent], themeNumberPairOfCards: Int, themePrimaryColor: String, themeSecondaryColor: String ) {
        name = themeName
        emojis = themeEmojis
        numberPairOfCards = (themeNumberPairOfCards <= themeEmojis.count) ? themeNumberPairOfCards : themeEmojis.count
        primaryColor = themePrimaryColor
        secondaryColor = themeSecondaryColor
    }
    
    init(themeName: String, themeEmojis: [CardContent], themePrimaryColor: String, themeSecondaryColor: String) {
        name = themeName
        emojis = themeEmojis
        numberPairOfCards = Int.random(in: 1..<themeEmojis.count)
        primaryColor = themePrimaryColor
        secondaryColor = themeSecondaryColor
    }
}
