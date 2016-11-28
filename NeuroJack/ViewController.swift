//
//  ViewController.swift
//  NeuroJack
//
//  Created by Josh Edson on 11/12/16.
//  Copyright © 2016 Josh Edson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var meter1: UIProgressView!
    @IBOutlet weak var meter2: UIProgressView!
    @IBOutlet weak var playcountSlider: UISlider!

    @IBOutlet weak var meter3: UIProgressView!
    @IBOutlet weak var cardCollectionView: UICollectionView!

    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var winMeter: UIProgressView!
    
    let table:BlackjackTable = BlackjackTable()

    @IBAction func goPressed(_ sender: Any) {
    
        meter1.progressTintColor = UIColor.white
        meter2.progressTintColor = UIColor.white
        meter3.progressTintColor = UIColor.white
    
        for i in 0..<Int(playcountSlider.value) {
            table.reset()
            table.processRound()
        }
        
        cardCollectionView.reloadData()
        let weights = table.players.first!.brain.weights
        
        let totalWeight:Double = fabs(weights[0]) + fabs(weights[1])
        let weight1 = weights[0]
        let weight2 = weights[1]
     let weight3 = weights[2]
    
        if weight1 < 0 {
            meter1.progressTintColor = UIColor.red
        }
        if weight2 < 0 {
            meter2.progressTintColor = UIColor.red
        }

    meter1.progress = Float(fabs(weight1) / totalWeight)
    meter2.progress = Float(fabs(weight2) / totalWeight)
    meter3.progress = Float(fabs(weight3) / totalWeight)

    winMeter.progress = Float(table.players.first!.wins) / Float(table.players.first!.losses + table.players.first!.wins)
    winLabel.text = "Win Rate: \(winMeter.progress)"
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
