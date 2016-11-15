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
        self.players.first!.wins = 0
        self.players.first!.losses = 0
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
            
            let guess =  player.brain.feedForward(inputs: [card.suit, card.rank])
            if guess == 1 {
                if((card.suit == .Heart || card.suit == .Diamond) && (card.rank == .King || card.rank == .Queen)) {
                    player.brain.feedbackError(error: 0)
                    player.wins += 1
                }
                else {
                    player.brain.feedbackError(error: -1.0/12.0)
                    player.losses += 1
                    dealer.hand.append(card)
                }
            }
            if guess == 0 {
                if((card.suit == .Heart || card.suit == .Diamond) && (card.rank == .King || card.rank == .Queen)) {
                    player.brain.feedbackError(error: 1.0/12.0)
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

