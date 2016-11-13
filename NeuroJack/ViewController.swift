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

    
    let table:BlackjackTable = BlackjackTable()

    @IBAction func goPressed(_ sender: Any) {
  
        table.reset()
        table.processRound()

        cardCollectionView.reloadData()

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
