//
//  FirstViewController.swift
//  DiceOnline
//
//  Created by user926704 on 1/28/21.
//  Copyright © 2021 alcrbcca. All rights reserved.
//

import UIKit
import Firebase

class FirstViewController: UIViewController {

    @IBOutlet weak var welcomeView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseApp.configure()
        
        welcomeView.layer.cornerRadius = welcomeView.frame.size.height/10
        
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
