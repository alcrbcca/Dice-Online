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
    
    var roomNumber = 3
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
        
        
        
    //    let dbFF = Firestore.firestore()
    //    print("this is my FF DB \(dbFF)")
        
        
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


