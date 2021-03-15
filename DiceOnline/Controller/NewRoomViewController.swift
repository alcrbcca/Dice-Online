//
//  NewRoomViewController.swift
//  DiceOnline
//
//  Created by user926704 on 1/24/21.
//  Copyright © 2021 alcrbcca. All rights reserved.
//

import UIKit
import Firebase

class NewRoomViewController: UIViewController, UITextFieldDelegate {
    
    var roomNumber = Int.random(in: 1000...9999)
    var numberOfPlayers = 1
    var playerName = "Host"
    let dbFF = Firestore.firestore()


    @IBOutlet weak var nameField: UITextField!
    
    

        
//    @available(iOS 14.0, *)
    override func viewDidLoad() {
        super.viewDidLoad()

        nameField.delegate = self
        
    //    FirebaseApp.configure()
        }
    

    @IBAction func numberPlayersSelected(_ sender: UISegmentedControl) {
        
        numberOfPlayers = sender.selectedSegmentIndex + 1
    //    print("Room Numer \(roomNumber), Player Name: \(playerName), Number of Players: \(numberOfPlayers)")
    }
    
    @IBAction func createRoomPressed(_ sender: UIButton) {
        print("Room Numer \(roomNumber), Player Name: \(playerName), Number of Players: \(numberOfPlayers)")
        
        
        
    //    Create entry in FF for new room Number
        
        
        dbFF.collection(K.gameRoomFF).addDocument(data: ["RoomNumber" : roomNumber, "NumPlayers" : numberOfPlayers, "PlayerName" : playerName, "date" : Date().timeIntervalSince1970]) {(error) in
            if let e = error {
                print("There was an error savind room data in DB \(e)")
            } else {
                print("Room info data saved succesfuly")
            }
        }
        
    // create firt player turn
        dbFF.collection(K.nextPlayerNameFF).addDocument(data: ["RoomNumber" : roomNumber, "PlayerName" : playerName, "date" : Date().timeIntervalSince1970]) {(error) in
            if let e = error {
                print("There was an error savind room data in DB \(e)")
            } else {
                print("Next Player turn info data saved succesfuly")
            }
        }
    
     // create an entry in the Game interaction table so other players can fetch dice values, via a listerner to the same room, before the first play
        
        dbFF.collection(K.gameInteractionFF).addDocument(data:["RoomNumber" : self.roomNumber , "PlayerName": self.playerName, "die1" : 0, "die2" : 0, "oneDie" : 0, "oneDieTrue" : false, "justChanged" : false, "date" : Date().timeIntervalSince1970 ]) { (error) in
            
            if let e = error {
                print("Error writing to Game Interaction in FF \(e)")
            } else {
                print("Successfully saved Game Interactio into FF")
            }
        }
        
        
        
        self.performSegue(withIdentifier: K.segueFromCreateToWait, sender: self)
        
    }
    

    
    // MARK: - Navigation

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let name = nameField.text {
        textField.endEditing(true)
            playerName = name
            return true
            
        } else {
                return false
            }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        nameField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if nameField.text != "" {
            return true
        } else {
            textField.placeholder = "Type a Name"
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segueFromCreateToWait {
            let destinationVC = segue.destination as! WatingRoomViewController
            
            destinationVC.finalNumberOfPlayers = numberOfPlayers
            destinationVC.myPlayerName = playerName
            destinationVC.finalRoomNumber = roomNumber
//            destinationVC.finalDb = dbFF
            
        }
    }
        

}


