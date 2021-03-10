//
//  ViewController.swift
//  DiceOnline
//
//  Adjusted by Alfredo Cruz
//
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
    let allDice = [#imageLiteral(resourceName: "DiceOne"), #imageLiteral(resourceName: "DiceTwo"), #imageLiteral(resourceName: "DiceThree"), #imageLiteral(resourceName: "DiceFour"), #imageLiteral(resourceName: "DiceFive"), #imageLiteral(resourceName: "DiceSix")]
    
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
        updateInteraction()
    }
    
    @IBAction func diceSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            oneDie = false
            diceImageView2.isHidden = false
            dbFF.collection(K.gameInteractionFF).addDocument(data:["RoomNumber" : self.RoomNumber , "PlayerName": self.MyPlayerName, "die1" : 0, "die2" : 0, "oneDieTrue" : self.oneDie, "date" : Date().timeIntervalSince1970 ]) { (error) in
                
                if let e = error {
                    print("Error writing to Game Interaction in FF \(e)")
                } else {
                    print("Successfully saved Game Interactio into FF")
                }
            }
            
        } else {
            oneDie = true
            diceImageView2.isHidden = true
            dbFF.collection(K.gameInteractionFF).addDocument(data:["RoomNumber" : self.RoomNumber , "PlayerName": self.MyPlayerName, "die1" : 1, "die2" : 1, "oneDieTrue" : self.oneDie, "date" : Date().timeIntervalSince1970 ]) { (error) in
                
                if let e = error {
                    print("Error writing to Game Interaction in FF \(e)")
                } else {
                    print("Successfully saved Game Interactio into FF")
                }
            }
        }
    }
    
    @IBAction func rollButtonPressed(_ sender: UIButton) {
    
    print("My Player  Name is \(MyPlayerName) and Crrent Player is \(currentPlayer)")
    
        sender.showsTouchWhenHighlighted = true
 
  // Copied to up in the class the allDice
  //    let allDice = [#imageLiteral(resourceName: "DiceOne"), #imageLiteral(resourceName: "DiceTwo"), #imageLiteral(resourceName: "DiceThree"), #imageLiteral(resourceName: "DiceFour"), #imageLiteral(resourceName: "DiceFive"), #imageLiteral(resourceName: "DiceSix")]
        
    if MyPlayerName == currentPlayer || MyPlayerName == "Tester" {
        let die1 = Int.random(in: 0...5)
        let die2 = Int.random(in: 0...5)
        
    
        dbFF.collection(K.gameInteractionFF).addDocument(data:["RoomNumber" : self.RoomNumber , "PlayerName": self.MyPlayerName, "die1" : die1, "die2" : die2, "oneDieTrue" : self.oneDie, "date" : Date().timeIntervalSince1970 ]) { (error) in
            
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
        
        updateInteraction()
        
    }
    
    func updateInteraction() {
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
                        
                        if let die1FF = data["die1"] as? Int , let die2FF = data["die2"] as? Int, let oneDieTrueFF = data["oneDieTrue"] as? Bool {
                            // present random numbers for 1 sec
                       
                              for i in 0...4 {
                                  Timer.scheduledTimer(withTimeInterval: Double(i) * 0.25, repeats: false) {
                                      (nil) in
                                    self.diceImageView1.image = self.allDice[Int.random(in: 0...5)]
                                    self.diceImageView2.image = self.allDice[Int.random(in: 0...5)]
                                    if oneDieTrueFF {
                                        self.diceImageView2.isHidden = true
                                    }
                                  }
                              }
                         
                            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) {
                                (nil) in
                                self.diceImageView1.image = self.allDice[die1FF]
                                self.diceImageView2.image = self.allDice[die2FF]
                                if oneDieTrueFF {
                                    self.diceImageView2.isHidden = true
                                }
                            }
                        }
                    }
                
                } else {
                    print("No dice roll data retreived")
                }
            }
        }
    }

    func updatePlayerLabel() {
        
        dbFF.collection(K.nextPlayerNameFF).whereField("RoomNumber", isEqualTo: RoomNumber).order(by: "date", descending: true).limit(to: 1).addSnapshotListener {
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
    
    @IBAction func nextButtonPresed(_ sender: UIButton) {
        
            if self.currentPlayer == self.MyPlayerName {
                    var NextPlayerIndex = 0
                  //  print("Players Orderes as : \(PlayersOrdered as Any)")
                    
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
         else {
         print("No my turn to change player")
        }
    }

    
    @IBAction func exitButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to leave the game room", preferredStyle: UIAlertController.Style.alert)
 
        alert.addAction(UIAlertAction(title: "Cancel", style:      UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            print("Cancel Exiting")
        } ))
        
        alert.addAction(UIAlertAction(title: "Yes", style:      UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        } ))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
