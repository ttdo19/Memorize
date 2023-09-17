//
//  MemoryGame.swift
//  Memorize
//
//  Created by Trang Do on 6/9/23.
//

import Foundation

//where CardContent behaves like an Equatable so we could change a Don't care type to mostly don't care
//Our model is a struct because Swift can only detect changes in a struct, not a class
struct MemoryGame<CardContent> where CardContent: Equatable {
    
    //We use private (set) to protect the Model by other code could view the cards, but they could not set anything about the cards
    private (set) var cards: Array<Card>
    private (set ) var score = 0
    
    //we make indexOfTheOneAndOnlyFaceUpCard private because indexOfTheOneAndOnlyFaceUpCard is completely private to our internal implementation. We don't want any code outside of our MemoryGame looking at that
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter{cards[$0].isFaceUp}.oneAndOnly }
        set { cards.indices.forEach{cards[$0].isFaceUp = ($0 == newValue) }}
    }

    private (set) var numberOfMatches = 0
        
    //calling this function is going to change the struct by saying mutating. This choose function is not private because we want other to be able to choose the cards. Internal means that it can be used anywhere within your app and it is the default so we don't have to put it
    mutating func choose(_ card: Card) {
        //you cannot use && in an if statement if you start with let, but you can use comma to separate the term
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}),
            !cards[chosenIndex].isFaceUp,
            !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2
                    cards[chosenIndex].isSeen = false
                    cards[potentialMatchIndex].isSeen = false
                    numberOfMatches += 1
                } else {
                    if cards[potentialMatchIndex].isSeen {
                        score -= 1
                    }
                    if cards[chosenIndex].isSeen {
                        score -= 1
                    }
                }
                cards[potentialMatchIndex].isSeen = true
                cards[chosenIndex].isSeen = true
                cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            
        }
    }
    
    //For the most parts, inits tend to be non-private
    init (numberOfPairOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        //add numberOfPairOfCards x 2 cards to cards array
        for pairIndex in 0..<numberOfPairOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: 2 * pairIndex))
            cards.append(Card(content: content, id: 2 * pairIndex + 1))
        }
        cards.shuffle()
    }
    
    //we will make our card behave like an Identifiable. Since we allow people to look at the Cards, we have to make the struct Card public
    struct Card: Identifiable {
        //Since people need to be able to look at all the properties in the cards, these properties should be non-private. The content and the id properties could be a let to prevent people from changing them
        var isFaceUp = false
        var isMatched = false
        var isSeen = false
        let content: CardContent //This is a "don't care" type
        let id: Int
    }
}

//if you have a var in an extension, it has to be computed vars, cannot be stored vars
extension Array {
    var oneAndOnly: Element? {
        if count == 1  {
            return first
        } else {
            return nil
        }
    }
}

