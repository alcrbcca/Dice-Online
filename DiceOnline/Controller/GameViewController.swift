//
//  ViewController.swift
//  DiceOnline
//
//  Adjusted to be DiceOnline by Alfredo Cruz
//
//

import UIKit
import Firebase
import AVFoundation



class GameViewController: UIViewController {
    
    var MyPlayerName = "Nick Name"
    var currentPlayer = "System"
    var RoomNumber = 1
    var PlayersOrdered : [String]?
    var oneDie = false
    var soundFile = "C"
    var die1 = 0
    var die2 = 0
    var player: AVAudioPlayer!
    
    let dbFF = Firestore.firestore()
    let allDice = [#imageLiteral(resourceName: "DiceOne"), #imageLiteral(resourceName: "DiceTwo"), #imageLiteral(resourceName: "DiceThree"), #imageLiteral(resourceName: "DiceFour"), #imageLiteral(resourceName: "DiceFive"), #imageLiteral(resourceName: "DiceSix"),#imageLiteral(resourceName: "Dice1-3.png"),#imageLiteral(resourceName: "Dice2-4.png"),#imageLiteral(resourceName: "Dice3-1.png"),#imageLiteral(resourceName: "Dice4-5.png"),#imageLiteral(resourceName: "Dice5-3.png"),#imageLiteral(resourceName: "Dice6-3.png")]
    let colorForPayer = [UIColor.yellow,UIColor.green,UIColor.blue,UIColor.red,UIColor.purple,UIColor.orange]
    
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
    
    func playSound(sound: String) {
        print("play a sound: \(sound) on my turn")
        let url = Bundle.main.url(forResource: sound, withExtension:  "wav" )
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }
    
    @IBAction func diceSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            oneDie = false
            diceImageView2.isHidden = false
            dbFF.collection(K.gameInteractionFF).addDocument(data:["RoomNumber" : self.RoomNumber , "PlayerName": self.MyPlayerName, "die1" : die1, "die2" : die2, "oneDieTrue" : self.oneDie, "justChanged" : true, "date" : Date().timeIntervalSince1970 ]) { (error) in
                
                if let e = error {
                    print("Error writing to Game Interaction in FF \(e)")
                } else {
                    print("Successfully saved Game Interactio into FF")
                }
            }
            
        } else {
            oneDie = true
            diceImageView2.isHidden = true
            dbFF.collection(K.gameInteractionFF).addDocument(data:["RoomNumber" : self.RoomNumber , "PlayerName": self.MyPlayerName, "die1" : die1, "die2" : die2, "oneDieTrue" : self.oneDie, "justChanged" : true, "date" : Date().timeIntervalSince1970 ]) { (error) in
                
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
         
    if MyPlayerName == currentPlayer || MyPlayerName == "Tester" {
        die1 = Int.random(in: 0...5)
        die2 = Int.random(in: 0...5)
        self.playSound(sound: "dice")
    
        dbFF.collection(K.gameInteractionFF).addDocument(data:["RoomNumber" : self.RoomNumber , "PlayerName": self.MyPlayerName, "die1" : die1, "die2" : die2, "oneDieTrue" : self.oneDie, "justChanged" : false, "date" : Date().timeIntervalSince1970 ]) { (error) in
            
            if let e = error {
                print("Error writing to Game Interaction in FF \(e)")
            } else {
              //  print("Successfully saved Game Interactio into FF")
            }
        }

    } else {
        playerNameLabel.text = "Not your turn"
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) {
            (nil) in
            self.playerNameLabel.text = self.currentPlayer
            }
        }
      // Comented next line to reduce times feching Game interactions
      //  updateInteraction()
        
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
                        
                        if let die1FF = data["die1"] as? Int , let die2FF = data["die2"] as? Int, let oneDieTrueFF = data["oneDieTrue"] as? Bool, let justChangedFF = data["justChanged"] as? Bool  {
                            // present random numbers for 1.5 sec
                            print("Number of images in allDice Array: \(self.allDice.count)")
                              for i in 0...6 {
                                  Timer.scheduledTimer(withTimeInterval: Double(i) * 0.25, repeats: false) {
                                      (nil) in
                                    if !justChangedFF {
                                        self.diceImageView1.image = self.allDice[Int.random(in: 0...11)]
                                        self.diceImageView2.image = self.allDice[Int.random(in: 0...11)]
                                    }
                                    if oneDieTrueFF {
                                        self.diceImageView2.isHidden = true
                                    } else {
                                        self.diceImageView2.isHidden = false
                                    }
                                  }
                              }
                         
                            Timer.scheduledTimer(withTimeInterval: 1.75, repeats: false) {
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
                    
                    if self.currentPlayer == self.MyPlayerName {
                        self.playSound(sound: "C")
                    }
                    
    // Asign color to player
                    
                    if let roomSize = self.PlayersOrdered?.count  {
                        for entry in 0...roomSize - 1 {
                            if self.currentPlayer == self.PlayersOrdered![entry] {
                                self.playerNameLabel.backgroundColor = self.colorForPayer[entry]
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
