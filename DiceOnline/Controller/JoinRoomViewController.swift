//
//  JoinRoomViewController.swift
//  DiceOnline
//
//  Created by user926704 on 1/31/21.
//  Copyright © 2021 alcrbcca. All rights reserved.
//

import UIKit
import Firebase

var roomToJoin : Int = 1234
var newPlayerToJoin : String = "newPlayer"

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
    print("Join Button Pressed")
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        playerNameField.endEditing(true)
        numberRoomField.endEditing(true)
        
        if let roomNumber = numberRoomField.text {
        print("Rom NUmber: \(roomNumber)")
        }
        print(textField.text ?? "Printing any defaul text")
    
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
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
