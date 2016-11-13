//
//  ViewController.swift
//  NeuroJack
//
//  Created by Josh Edson on 11/12/16.
//  Copyright © 2016 Josh Edson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cardCollectionView: UICollectionView!
    var wins:Int = 0
    var losses:Int = 0
    var lastShuffle = 0
    
    let table:CardTable = CardTable()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        processRound()
    }
    
    @IBAction func goPressed(_ sender: Any) {
        wins = 0
        losses = 0
        for _ in 0..<100000{
            self.reset()
            self.processRound()
            
        }
        cardCollectionView.reloadData()
        print(Double(wins) / (Double(wins) + Double(losses)))
      // print(table.players.first!.brain.weights)
    }
    func reset() {
        
        for card in table.dealer.hand {
            table.dealer.deck.cards.append(card)
        }
        table.dealer.hand = []
        
        for player in table.players {
            for card in player.hand {
                table.dealer.deck.cards.append(card)
            }
            player.hand = []

        }
    
        lastShuffle += 1
        if lastShuffle > 3 {
            lastShuffle = 0
            table.dealer.deck.shuffle()
        }
    }
    func processRound() {
        let player = table.players.first!
        table.dealer.deal(player: table.dealer, count: 1, faceUp: false)
        table.dealer.deal(player: table.dealer, count: 1, faceUp: true)
        table.dealer.deal(player: player, count: 2, faceUp:true)
       
        
        while (player.brain.feedForward(inputs: [Double(-player.getCardCount(table: table)), (fabs(Double(table.dealer.handValue()) / 16.0)), (Double(player.handValue())/21.0 * 2.0) - 1.0]) != 0 && player.handValue() < 17) || player.handValue() <= 11 {
            
            table.dealer.deal(player: player, count: 1, faceUp: true)
            
            if(player.handValue() > 21) {
                player.brain.feedbackError(error: -2)
                break
            }
            if(player.handValue() == 21) {
     
             
                break
            }
        }
        
        for card in table.dealer.hand {
            card.flipOver()
        }
        
        if player.handValue() <= 21 {
        while table.dealer.handValue() < 17 {
            table.dealer.deal(player: table.dealer, count: 1, faceUp: true)
        }
            if(player.handValue() == table.dealer.handValue()) {
               
                return
            }
        if(player.handValue() > table.dealer.handValue() || table.dealer.handValue() > 21) {
        
            player.brain.feedbackError(error: 0)
            wins += 1
        }
        else {
            player.brain.feedbackError(error:2)
      
            losses += 1
        }
        }
        else {
            losses += 1
        }
        
  

        


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return table.players.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return table.dealer.hand.count
        default:
            return table.players[section - 1].hand.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Card", for: indexPath) as? CardCell {
            switch indexPath.section {
            case 0:
                let card = table.dealer.hand[indexPath.row]
                cell.configure(card: card)
                return cell
                
            default:
                let card = table.players[indexPath.section - 1].hand[indexPath.row]
                cell.configure(card: card)
                return cell
            }
            return cell
        }
        return UICollectionViewCell()
    }
}
