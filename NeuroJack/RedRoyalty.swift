//
//  RedRoyalty.swift
//  NeuroJack
//
//  Created by Josh Edson on 11/13/16.
//  Copyright © 2016 Josh Edson. All rights reserved.
//

import Foundation

class RedRoyaltyTable:CardTable {
    
    func reset() {
        dealer.deck = CardDeck()
        dealer.deck.shuffle()
        dealer.hand = []
        self.players.first!.hand = []
    }
    func processRound() {
    
        
        let player = players.first!
        while !dealer.deck.cards.isEmpty {
            dealer.deal(player: player, count: 1, faceUp: true)
            let card = player.hand.last!
            
            let guess =  player.brain.feedForward(inputs: [Double(card.rank.value()),Double(card.suit.doubleValue())])
            if guess == 1 {
                if((card.rank == .Jack || card.rank == .Queen || card.rank == .King) && card.suit == .Heart || card.suit == .Diamond) {
                    player.brain.feedbackError(error: 0)
                    player.wins += 1
                }
                else {
                    player.brain.feedbackError(error: -1)
                    player.losses += 1
                    dealer.hand.append(card)
                }
            }
            if guess == 0 {
                if((card.rank == .Jack || card.rank == .Queen || card.rank == .King) && card.suit == .Heart || card.suit == .Diamond) {
                    player.brain.feedbackError(error: 1)
                    player.losses += 1
                    dealer.hand.append(card)
                }
                else {
                    player.brain.feedbackError(error: 0)
                    player.wins += 1
                }
            }
            
        }
    }
}

