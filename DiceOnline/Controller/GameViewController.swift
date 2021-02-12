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
    var currentPlayer = "System"
    var RoomNumber = 1
    var PlayersOrdered : [String]?
    
    let dbFF = Firestore.firestore()
    
    @IBOutlet weak var diceImageView1: UIImageView!
    @IBOutlet weak var diceImageView2: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updatePlayerLabel()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func rollButtonPressed(_ sender: UIButton) {
    
    
        
        let allDice = [#imageLiteral(resourceName: "DiceOne"), #imageLiteral(resourceName: "DiceTwo"), #imageLiteral(resourceName: "DiceThree"), #imageLiteral(resourceName: "DiceFour"), #imageLiteral(resourceName: "DiceFive"), #imageLiteral(resourceName: "DiceSix")]
        
        
        
        diceImageView1.image = allDice[Int.random(in: 0...5)]
        diceImageView2.image = allDice[Int.random(in: 0...5)]
        
    }
    
    
    @IBAction func nextButtonPresed(_ sender: UIButton) {
    
    }
    
    func updatePlayerLabel() {
        
        dbFF.collection(K.gameRoomFF).whereField("RoomNumber", isEqualTo: RoomNumber ).limit(to: 1).getDocuments() {
            (query, error) in
            if let e = error {
                print("Error retreiving data for next player anme \(e)")
            } else {
                if let list = query?.documents {
   //                 print("Retreived docs : \(list.count)")
                    for item in list {
                        let data = item.data()
   //                     print("Data ' \(data)")
                        if let name = data["PlayerName"] as? String {
                            self.currentPlayer = name
                        }
                    }
     //               print("Ordered List \(self.playersOrdered)")
                    print("Current Player: \(self.currentPlayer)")
                        self.playerNameLabel.text = self.currentPlayer
                
                } else {
                    print("No Next Player Data retreived")
                }
            }
        }
        
    }
    
    
}

