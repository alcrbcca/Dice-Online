//
//  ViewController.swift
//  AutoLayout-iOS13
//
//  Created by Angela Yu on 28/06/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import Firebase



class GameViewController: UIViewController {
    
    var MyPlayerName = "Nick Name"
    var RoomNumber = 1
    var PlayersOrdered : [String]?
    
    let dbFF = Firestore.firestore()
    
    @IBOutlet weak var diceImageView1: UIImageView!
    @IBOutlet weak var diceImageView2: UIImageView!
    
    @IBOutlet weak var playerNameLabel: UILabel!
    
    @IBAction func rollButtonPressed(_ sender: UIButton) {
        
        let allDice = [#imageLiteral(resourceName: "DiceOne"), #imageLiteral(resourceName: "DiceTwo"), #imageLiteral(resourceName: "DiceThree"), #imageLiteral(resourceName: "DiceFour"), #imageLiteral(resourceName: "DiceFive"), #imageLiteral(resourceName: "DiceSix")]
        
        diceImageView1.image = allDice[Int.random(in: 0...5)]
        diceImageView2.image = allDice[Int.random(in: 0...5)]
        
    }
    
    
    @IBAction func nextButtonPresed(_ sender: UIButton) {
    }
    
}

