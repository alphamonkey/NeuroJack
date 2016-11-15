//
//  Cards.swift
//  NeuroJack
//
//  Created by Josh Edson on 11/12/16.
//  Copyright © 2016 Josh Edson. All rights reserved.
//

import Foundation
import UIKit

enum Suit {
    case Diamond
    case Heart
    case Spade
    case Club
    

}

extension Suit:NeuralInput {
    var charge:Double {
        switch self {
        case .Diamond:
            return 0.0
        case .Heart:
            return 1.0
        case .Spade:
            return 2.0
        case .Club:
            return 3.0
        }
    }
}
enum Rank {
    

    case Two
    case Three
    case Four
    case Five
    case Six
    case Seven
    case Eight
    case Nine
    case Ten
    case Jack
    case Queen
    case King
    case Ace
    
    func value() -> Int {
        switch self {

        case .Two:
            return 2
        case .Three:
            return 3
        case .Four:
            return 4
        case .Five:
            return 5
        case .Six:
            return 6
        case .Seven:
            return 7
        case .Eight:
            return 8
        case .Nine:
            return 9
        case .Ten:
            return 10
        case .Jack:
            return 10
        case .Queen:
            return 10
        case .King:
            return 10
        case .Ace:
            return 1
        }
    }
}

extension Rank:NeuralInput {
    var charge:Double {
        switch self {
            
        case .Two:
            return 2.0
        case .Three:
            return 3.0
        case .Four:
            return 4.0
        case .Five:
            return 5.0
        case .Six:
            return 6.0
        case .Seven:
            return 7.0
        case .Eight:
            return 8.0
        case .Nine:
            return 9.0
        case .Ten:
            return 10.0
        case .Jack:
            return 20.0
        case .Queen:
            return 30.0
        case .King:
            return 40.0
        case .Ace:
            return 1.0
        }
    }

}
class Card {
    let rank:Rank
    let suit:Suit
    var faceUp:Bool
    
    init(rank:Rank, suit:Suit) {
        
        self.rank = rank
        self.suit = suit
        self.faceUp = true
    
    }
    
    func flipOver() {
        if faceUp == false {
            faceUp = true
        }
    }
    func stringValue() -> String {
        switch rank {
        case  .Two, .Three, .Four, .Five, .Six, .Seven, .Eight, .Nine, .Ten:
            return "\(rank.value())"
        case .Jack:
            return "J"
        case .Queen:
            return "Q"
        case .King:
            return "K"
        case .Ace:
            return "A"
        }
    }
}


extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (unshuffledCount, firstUnshuffled) in zip(stride(from: c, to: 1, by: -1), indices) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}

class CardDeck {
    
    var cards:[Card]
    init() {
        cards = []
        let suits = [Suit.Diamond, Suit.Heart, Suit.Spade, Suit.Club]
        for suit in suits {
            let ranks = [ Rank.Two, Rank.Three, Rank.Four, Rank.Five, Rank.Six, Rank.Seven, Rank.Eight, Rank.Nine, Rank.Ten, Rank.Jack, Rank.King, Rank.Ace]
            for rank in ranks {
                let newCard = Card(rank:rank, suit:suit)
                cards.append(newCard)
            }
        }
    }
    
    func shuffle() {
        cards.shuffle()
    }
    
    func top() -> Card {
        return cards.first!
    }
}

class CardTable {
    let dealer:CardDealer
    let players:[CardPlayer]
    
    init() {
        dealer = CardDealer()
        players = [CardPlayer()]
    }
}

class CardCell:UICollectionViewCell {
    
    @IBOutlet weak var suitImage: UIImageView!

    @IBOutlet weak var rankLabel: UILabel!
    
    func configure(card:Card) {
        if card.faceUp == false {
            rankLabel.text = ""
            suitImage.image = nil
            backgroundColor = UIColor.blue
            return
        }
        backgroundColor = UIColor.white
        self.rankLabel.text = card.stringValue()
        switch card.suit {
        case .Diamond:
            self.rankLabel.textColor = UIColor.red
            self.suitImage.image = UIImage(named: "diamond.png")
        case .Heart:
            self.rankLabel.textColor = UIColor.red
            self.suitImage.image = UIImage(named: "heart.png")
        case .Club:
            self.rankLabel.textColor = UIColor.black
            self.suitImage.image = UIImage(named: "club.jpg")
        case .Spade:
            self.rankLabel.textColor = UIColor.black
            self.suitImage.image = UIImage(named: "spade.png")
        }
    }
}
class CardDealer:CardPlayer {
    var deck:CardDeck

    override init() {
     
        deck = CardDeck()

        deck.shuffle()
           super.init()
    }
    
    func deal(player:CardPlayer, count:Int, faceUp:Bool) {
        for _ in 0..<count {
            var card = deck.top()
            card.faceUp = faceUp
            player.hand.append(card)
            deck.cards.remove(at: 0)
        }
    }
    
}
class CardPlayer {
    
    var wins = 0
    var losses = 0
    
    var hand:[Card]
    var brain:Perceptron = Perceptron(count:2)
    
    init() {
        hand = []
        
    }

    func handValue() -> Int {
        var total = 0
        for card in hand {
            if card.faceUp == true {
                total += card.rank.value()
            }
        }
        if hasAce() && total <= 11 {
            total += 10
        }
        return total
    }
    
    func hasAce() -> Bool {
        for card in hand {
            if card.rank == .Ace {
                return true
            }
        }
        return false
    }
    
    func getCardCount(table:CardTable) -> Int {
        var total:Int = 0
        for card in table.dealer.hand {
            if card.faceUp == true {
                if card.rank.value() < 7 {
                    total += -1
                }
                else if card.rank.value() > 9 {
                    total += 1
                }
             
            }
        }
        
        for player in table.players {
            for card in player.hand {
                if card.faceUp == true {
                    if card.rank.value() < 7 {
                        total += -1
                    }
                    else if card.rank.value() > 9 {
                        total += 1
                    }
                    
                }
            }
        }
        return total
    }
}
