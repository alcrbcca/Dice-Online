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
    var percentageJoined : Float = 0.0
    var playersOrdered = ["Name"]
    
    var myTimer : Timer? = nil {
        willSet {
            myTimer?.invalidate()
        }
    }
    
    
    @IBOutlet weak var roomNumberView: UILabel!
    
    @IBOutlet weak var waitingProgressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if let number = finalRoomNumber {
            print ("Room Number = \(number)")
            roomNumberView.text = "0"
            roomNumberView.text = String(number)
            
            loadRoom(room: Int(number))
            startTimer()
            
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
        
    }
    
    func startTimer() {
        stopMyTimer()
        guard self.myTimer == nil else { return }
        myTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    
    func stopMyTimer()  {
        print("Stoping the timer from the stopMyTimer function")
        myTimer?.invalidate()
        myTimer = nil
    }
    
    func updateProgresBar(perctJoined: Float) {
        waitingProgressBar.progress = perctJoined
    }
    
    func prepPlayersOrder () {
        playersOrdered = []
        dbFF.collection(K.gameRoomFF).whereField("RoomNumber", isEqualTo: finalRoomNumber ?? 1).order(by: "date").getDocuments() {
            (queryS, error) in
            if let e = error {
                print("Error retreiving data \(e)")
            } else {
                if let list = queryS?.documents {
                    print("Retreived list.count from gameRoom to create playersOrdered: \(list.count)")
                    for item in list {
                        let data = item.data()
                        print("Data of list of players for a player room \(data)")
                        if let name = data["PlayerName"] as? String {
                            self.playersOrdered.append(name)
                        }
                    }
     //               print("Ordered List \(self.playersOrdered)")
                    print("PlayersOrdered: \(self.playersOrdered.count)")
                    for i in 0...self.playersOrdered.count-1  {
                        print("playersOrdered Item: \(i) Name: \(self.playersOrdered[i])")
                    }
     // Init Segue to GameVC
                    self.performSegue(withIdentifier: K.segueFromWaitToGame, sender: self)
                    
                } else {
                    print("No Data retreived")
                }
            }
        }
      
    }
    
@objc func updateTimer() {
    loadRoom(room: finalRoomNumber!)
//    print("update Timer Called")
    
    let percentageJoined = Float(self.playersJoined)/Float(self.finalNumberOfPlayers ?? Int(Float(1.0)))
    
    updateProgresBar(perctJoined: percentageJoined)
            
            print("% joined: \(percentageJoined)")
            
            if percentageJoined == 1.0 {
                print("all joined and stoping the timer")
                stopMyTimer()
                prepPlayersOrder()
        }
    }

    func loadRoom(room : Int) {
    //   var roomOccupation = 0
        dbFF.collection(K.gameRoomFF).whereField("RoomNumber", isEqualTo: room).getDocuments(){
            (querySnapshot, Error) in
            if let e = Error {
                print ("Erro retriving data from db at waiting room \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                        let data = snapshotDocuments
    //                    print("Has joined: \(data.count)")
                        self.playersJoined = data.count
                    }
                }
            }
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segueFromWaitToGame {
            let destinationVC = segue.destination as! GameViewController
            destinationVC.MyPlayerName = myPlayerName!
            destinationVC.RoomNumber = finalRoomNumber ?? 1
            destinationVC.PlayersOrdered = playersOrdered
            
        }
    }
}
    
    
 


