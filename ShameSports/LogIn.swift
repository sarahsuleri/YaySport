//
//  LogIn.swift
//  ShameSports
//
//  Created by Mohammad Alhareeqi on 09/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import UIKit

class LogIn: UIViewController {
    
    @IBOutlet weak var FBloginBTN: UIButton!
    
    @IBAction func FBLoginClick(sender: AnyObject) {
        
         performSegueWithIdentifier("loginSuccess", sender: sender)
        
    }
    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
