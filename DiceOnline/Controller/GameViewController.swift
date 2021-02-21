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
    var oneDie = false
    
    let dbFF = Firestore.firestore()
    
    @IBOutlet weak var diceImageView1: UIImageView!
    @IBOutlet weak var diceImageView2: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var rollButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updatePlayerLabel()
        rollButton.layer.cornerRadius = rollButton.frame.size.height/4
        
        nextButton.layer.cornerRadius = nextButton.frame.size.height/5
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func diceSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            oneDie = false
            diceImageView2.isHidden.toggle()
        } else {
            oneDie = true
            diceImageView2.isHidden.toggle()
        }
    }
    
    @IBAction func rollButtonPressed(_ sender: UIButton) {
    
    print("My Player  Name is \(MyPlayerName) and Crrent Player is \(currentPlayer)")
    
        sender.showsTouchWhenHighlighted = true
        
    let allDice = [#imageLiteral(resourceName: "DiceOne"), #imageLiteral(resourceName: "DiceTwo"), #imageLiteral(resourceName: "DiceThree"), #imageLiteral(resourceName: "DiceFour"), #imageLiteral(resourceName: "DiceFive"), #imageLiteral(resourceName: "DiceSix")]
        
    if MyPlayerName == currentPlayer || MyPlayerName == "Tester" {
        let die1 = Int.random(in: 0...5)
        let die2 = Int.random(in: 0...5)
        
        dbFF.collection(K.gameInteractionFF).addDocument(data:["RoomNumber" : self.RoomNumber , "PlayerName": self.MyPlayerName, "die1" : die1, "die2" : die2, "date" : Date().timeIntervalSince1970 ]) { (error) in
            
            if let e = error {
                print("Error writing to Game Interaction in FF \(e)")
            } else {
                print("Successfully saved Game Interactio into FF")
            }
        }

    } else {
        playerNameLabel.text = "Not your turn"
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) {
            (nil) in
            self.playerNameLabel.text = self.currentPlayer
            }
        }
        
        dbFF.collection(K.gameInteractionFF).whereField("RoomNumber", isEqualTo: RoomNumber).order(by: "date", descending: true).limit(to: 1).addSnapshotListener {
            (queryInteraction, error) in
            if let e = error {
                print("Error retreiving data for next dice roll \(e)")
            } else {
                if let listInteraction = queryInteraction?.documents {
   //                 print("Retreived docs : \(list.count)")
                    for item in listInteraction {
                        let data = item.data()
                        print("Game Interaction Data \(data)")
    //          Update dice Images:
                        
                        if let die1FF = data["die1"] as? Int , let die2FF = data["die2"] as? Int {
                            // present random numbers for 1 sec
                       
                              for i in 0...4 {
                                  Timer.scheduledTimer(withTimeInterval: Double(i) * 0.25, repeats: false) {
                                      (nil) in
                                      self.diceImageView1.image = allDice[Int.random(in: 0...5)]
                                      self.diceImageView2.image = allDice[Int.random(in: 0...5)]
                                  }
                              }
                         
                            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) {
                                (nil) in
                            self.diceImageView1.image = allDice[die1FF]
                            self.diceImageView2.image = allDice[die2FF]
                            }
                        }
                    }
                
                } else {
                    print("No Next Player Data retreived")
                }
            }
        }
    }
    
    
    @IBAction func nextButtonPresed(_ sender: UIButton) {
        var NextPlayerIndex = 0
        print("Players Orderes as : \(PlayersOrdered as Any)")
        
        for i in 0...PlayersOrdered!.count-1 {
            if PlayersOrdered![i] == MyPlayerName {
              NextPlayerIndex = i + 1
            }
        }
        
        if NextPlayerIndex == PlayersOrdered!.count {
             NextPlayerIndex = 0
   //        NextPlayerIndex = 1
        }
        print("Next Player Name : \(PlayersOrdered![NextPlayerIndex])")
        dbFF.collection(K.nextPlayerNameFF).addDocument(data: ["RoomNumber" : RoomNumber, "PlayerName" : self.PlayersOrdered![NextPlayerIndex], "date" : Date().timeIntervalSince1970])
        updatePlayerLabel()
    }
    
    func updatePlayerLabel() {
        
        dbFF.collection(K.nextPlayerNameFF).whereField("RoomNumber", isEqualTo: RoomNumber).order(by: "date", descending: true).limit(to: 1).getDocuments() {
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

