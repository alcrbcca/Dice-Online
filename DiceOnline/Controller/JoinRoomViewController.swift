//
//  JoinRoomViewController.swift
//  DiceOnline
//
//  Created by user926704 on 1/31/21.
//  Copyright © 2021 alcrbcca. All rights reserved.
//

import UIKit
import Firebase

var roomNumber = 1234
var numberOfPlayers : Int = 0
var playersInRoom = 0
var myPlayerName = "Me"
 

// var newPlayerToJoin : String = "newPlayer"

class JoinRoomViewController: UIViewController, UITextFieldDelegate {
    
    let dbFF = Firestore.firestore()

    @IBOutlet weak var playerNameField: UITextField!
    @IBOutlet weak var numberRoomField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerNameField.delegate = self
        numberRoomField.delegate = self

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func joinButtonPressed(_ sender: UIButton) {
        
        if let newPlayerToJoin = playerNameField.text {
            print("Join Button Pressed by player \(newPlayerToJoin) to join Room: \(roomNumber) which has \(playersInRoom) in, out of \(numberOfPlayers)  capacity")
            myPlayerName = newPlayerToJoin

            
            }
        
        else {
            
            print("Please enter a player name" )
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
       // Placed playerNameField.endEditing here again
        playerNameField.endEditing(true)
        numberRoomField.endEditing(true)
        
        if let roomToJoin = Int(numberRoomField.text ?? "1234") {
 //           numberRoomField.endEditing(true)
            print("Room NUmber to Join: \(roomToJoin)")
            roomNumber = roomToJoin
            
       // Check in dbFF if room exists
             confirmRoom(room: roomNumber)
                
            

            
            } else {
                print("Please enter a valid Room number")
                }
    
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = ""
        
        return true
    }
    
    func confirmRoom(room : Int) {
        
//        print("Database id: \(dbFF)")
        dbFF.collection(K.gameRoomFF).whereField("RoomNumber", isEqualTo: room).getDocuments() { (querySnapshot, error) in
            if let err = error {
                print("Error getting documents: \(err)")
            } else {
                print("Number of players in room = \(querySnapshot!.count)")

                let numPlayersOfOneEntry : Int = querySnapshot!.documents[0].data()["NumPlayers",  default: Int()] as! Int
  //              let keyOfOneEntry = oneEntry.keys
  //              print("Keys of One Entry \(keyOfOneEntry)")
                    print("Num of Players of one entry in the list \(numPlayersOfOneEntry)")
                    let confirmedNumberOfPlayers = numPlayersOfOneEntry
                    print("Confirmed Int of Players = \(confirmedNumberOfPlayers)")
                    numberOfPlayers = confirmedNumberOfPlayers
               
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    }
                
                playersInRoom = querySnapshot!.count
                
              }
        }
       
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
