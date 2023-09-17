//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Trang Do on 6/1/23.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    //means that when the game changes, we need to redraw our UI. This game cannot be private since we use it in struct ContentView_Previews
    @ObservedObject var game: EmojiMemoryGame
    
    //The body var cannot be private because the SwiftUI is going to need access to this
    var body: some View {
        VStack {
            HStack {
                Text(game.theme.emojis.randomElement()!)
                Text(game.theme.name)
                Text(game.theme.emojis.randomElement()!)
            }
            .font(Font.custom("Amsterdam-ZVGqm", size: 50))
            .foregroundColor(game.getThemePrimaryColor)
            .fontWeight(.bold)
            
            if (game.numberOfMatches == game.theme.numberPairOfCards) {
                Spacer()
                displayResult
            } else {
                AspectVGrid (items: game.cards, aspectRatio: 2/3) { card in
                    if card.isMatched && !card.isFaceUp {
                        Rectangle().opacity(0)
                    } else {
                        CardView(card: card, gradient: game.getGradient)
                            .padding(3)
                            .onTapGesture {
                                game.choose(card)
                            }
                    }
                }
            }
            Spacer()
            HStack {
                newGame
                Spacer()
                score
            }
        }
        .padding(.all)
        }
    
    //@ViewBuilder in front of a function will let the compiler to know that this function uses syntax as a ViewBuilder
    
    private struct Icon {
        static let star = Image(systemName: "star")
        static let starFilled = Image(systemName: "star.fill")
        static let rectangleFilled = Image(systemName: "rectangle.portrait.fill")
        static let rectangle = Image(systemName: "rectangle.portrait")
    }
    
    private var displayResult: some View {
         ZStack {
            VStack {
                HStack {
                    if (game.score >= Int(Double(game.theme.numberPairOfCards)*0.8)) {
                        Icon.starFilled; Icon.starFilled; Icon.starFilled
                    } else if (game.score >= Int(Double(game.theme.numberPairOfCards)*0.6)) {
                        Icon.starFilled; Icon.starFilled; Icon.star
                    } else if (game.score >= Int(Double(game.theme.numberPairOfCards)*0.3)) {
                        Icon.starFilled; Icon.star; Icon.star
                    } else {
                        Icon.star; Icon.star; Icon.star
                    }
                }
                Text("Congratulation!")
                Text("🥳You won🥳")
            }.font(.largeTitle).foregroundColor(game.getThemePrimaryColor)
            LottieView(lottieFile: "data")
        }
    }
    
    private var newGame: some View {
        Button {
            game.restart()
        } label: {
            VStack {
                Image(systemName: "gamecontroller").font(.largeTitle)
                Text("New Game")
            }
        }.foregroundColor(game.getThemePrimaryColor)
    }
    
    private var score: some View {
        VStack {
            HStack {
                if (game.numberOfMatches == Int(game.theme.numberPairOfCards)) {
                    Icon.rectangleFilled; Icon.rectangleFilled.padding(.horizontal, -6); Icon.rectangleFilled
                } else if (game.numberOfMatches >= Int(Double(game.theme.numberPairOfCards)*0.67)) {
                    Icon.rectangleFilled; Icon.rectangleFilled.padding(.horizontal, -6); Icon.rectangle
                } else if (game.numberOfMatches >= Int(Double(game.theme.numberPairOfCards)/3)) {
                    Icon.rectangleFilled; Icon.rectangle.padding(.horizontal, -6); Icon.rectangle
                } else {
                    Icon.rectangle; Icon.rectangle.padding(.horizontal, -6); Icon.rectangle
                }
            }
            Text("Score: \(game.score)").font(.title3)
        }
        .foregroundColor(game.getThemePrimaryColor)
    }
}

struct CardView: View {
    //when you build a view, just pass through the minimum it needs to do what its job is. CardView's job is to build a UI that shows a card in the model, so we only pass a card. This card cannot be private since we use it in the struct EmojiMemoryGameView (our View). But if we use an init, then we can set it as private
    let card: EmojiMemoryGame.Card
    //View is expensive when you actually rebuild their body but they only got rebuilt when there is actually changes
    
    let gradient: LinearGradient
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack{
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                if card.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth).foregroundColor(.red)
//                    Pie(startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 20)).opacity(0.5).padding(5)
                    Text(card.content)
                        .font(font(in: geometry.size))
                    
                } else if card.isMatched {
                    shape.opacity(0)
                } else {
                    shape.fill(gradient)
                }
            }
        })
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.7
    }
}























struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game)
            .preferredColorScheme(.light)
        EmojiMemoryGameView(game: game)
            .preferredColorScheme(.light)
    }
}

