//
//  WatingRoomViewController.swift
//  DiceOnline
//
//  Created by user926704 on 1/24/21.
//  Copyright © 2021 alcrbcca. All rights reserved.
//

import UIKit
import Firebase




class WatingRoomViewController: UIViewController {
    
    var finalRoomNumber : Int?
    var finalNumberOfPlayers : Int?
    var myPlayerName : String?
    let dbFF = Firestore.firestore()
    var playersJoined = 1

    @IBOutlet weak var roomNumberView: UILabel!
    
    @IBOutlet weak var waitingProgressBar: UIProgressView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let number = finalRoomNumber {
            print ("Room Number = \(number)")
            roomNumberView.text = "0"
            roomNumberView.text = String(number)
            
            loadRoom(room: Int(number))
        } else {
            print ("No room number passed")
        }

        if let name = myPlayerName {
        print( "My Player Name is: \(name)")
        } else {
            print ( "no name passed" )
        }
        
        // Do any additional setup after loading the view.
        // Check periodically if room is full
     
        
        
        let percentageJoined : Float = Float(playersJoined)/Float(finalNumberOfPlayers ?? 1)
        
      //  print("Number of Players for progress var: \(String(describing: finalNumberOfPlayers))")
        updateProgresBar(percentageJoined: percentageJoined)
        
        
        }
    
    func updateProgresBar(percentageJoined: Float) {
        waitingProgressBar.progress = percentageJoined
    }
   
    func loadRoom(room : Int) {
    //   var roomOccupation = 0
        dbFF.collection(K.gameRoomFF).whereField("RoomNumber", isEqualTo: room).getDocuments(){
            (querySnapshot, Error) in
            if let e = Error {
                print ("Erro retriving data from db at waiting room \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
      //              for doc in snapshotDocuments {
                     
                        let data = snapshotDocuments
    
                        print("Has joined: \(data.count)")
    //                    self.playersJoined = data.count
                    
                    DispatchQueue.main.async {
                        self.playersJoined = data.count
                        print("Checking if more players join")
                    }
    
                    }
                }
            }
        }
}
    
    
 


