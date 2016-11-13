//
//  BlackjackTable.swift
//  NeuroJack
//
//  Created by Josh Edson on 11/13/16.
//  Copyright © 2016 Josh Edson. All rights reserved.
//

import Foundation

class BlackjackTable: CardTable {
    
    var lastShuffle = 0
    
    func reset() {
        
        for card in self.dealer.hand {
            self.dealer.deck.cards.append(card)
        }
        self.dealer.hand = []
        
        for player in self.players {
            for card in player.hand {
                self.dealer.deck.cards.append(card)
            }
            player.hand = []
            
        }
        
        lastShuffle += 1
        
        if lastShuffle > 3 {
            lastShuffle = 0
            self.dealer.deck.shuffle()
        }
    }
    func processRound() {
        let player = self.players.first!
        self.dealer.deal(player: self.dealer, count: 1, faceUp: false)
        self.dealer.deal(player: self.dealer, count: 1, faceUp: true)
        self.dealer.deal(player: player, count: 2, faceUp:true)
        
        while (player.brain.feedForward(inputs: [Double(-player.getCardCount(table: self)), (fabs(Double(self.dealer.handValue()) / 16.0)), (Double(player.handValue())/21.0 * 2.0) - 1.0]) != 0 && player.handValue() < 17) || player.handValue() <= 11 {
            
            self.dealer.deal(player: player, count: 1, faceUp: true)
            
            if(player.handValue() > 21) {
                player.brain.feedbackError(error: 21 - player.handValue())
                break
            }
            if(player.handValue() == 21) {
                
                
                break
            }
        }
        
        for card in self.dealer.hand {
            card.flipOver()
        }
        
        if player.handValue() <= 21 {
            while self.dealer.handValue() < 17 {
                self.dealer.deal(player: self.dealer, count: 1, faceUp: true)
            }
            if(player.handValue() == self.dealer.handValue()) {
                
                return
            }
            if(player.handValue() > self.dealer.handValue() || self.dealer.handValue() > 21) {
                
                player.brain.feedbackError(error: 0)
                player.wins += 1
            }
            else {
                player.brain.feedbackError(error:self.dealer.handValue() - player.handValue())
                
                player.losses += 1
            }
        }
        else {
            // Bust
            player.losses += 1
        }
        
        
        
        
        
        
    }
    
}
