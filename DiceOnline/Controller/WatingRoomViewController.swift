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
    var timerStarted = false
    var stopTimer = false
    var percentageJoined : Float = 0.0
    
    var myTimer : Timer? = nil {
        willSet {
            myTimer?.invalidate()
        }
    }
    
//    let myTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    
    
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
     
 //      let myTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
  //      if timerStarted {
            startTimer()
            timerStarted = true
    //     }
        
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
    
@objc func updateTimer() {
     //       loadRoom(room: finalRoomNumber!)
    let percentageJoined = Float(self.playersJoined)/Float(self.finalNumberOfPlayers ?? Int(Float(1.0)))
    
    // percentageJoined = Float(playersJoined)/Float(10.0)
            
    // print("Number of Players for progress var: \(String(describing: self.finalNumberOfPlayers))")
            
    updateProgresBar(perctJoined: percentageJoined)
            
            print("% joined: \(percentageJoined)")
            
            if percentageJoined == 1.0 {
                print("all joined and stoping the timer")
                stopTimer = true
                stopMyTimer()
                
//            } else {
//            self.playersJoined += 1
//            }
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
    
                        print("Has joined: \(data.count)")
    //                    self.playersJoined = data.count
                    
                        self.playersJoined = data.count
                        print("Data load was succesful")
                    
    
                    }
                }
            }
        }
}
    
    
 


