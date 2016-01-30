//
//  Settings.swift
//  ShameSports
//
//  Created by Omar Tawfik on 29/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import UIKit

class Settings: UITableViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {

   
    @IBOutlet weak var minSteps: UITextField!
    @IBOutlet weak var maxSteps: UITextField!
    
    
    @IBOutlet weak var minMiles: UITextField!
    @IBOutlet weak var maxMiles: UITextField!
    
    
    @IBOutlet weak var minFloors: UITextField!
    @IBOutlet weak var maxFloors: UITextField!
    
    
    @IBOutlet weak var FBLogout: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let arrayField:[UITextField] = [minSteps,maxSteps,minMiles,maxMiles,minFloors,maxFloors]
        var count = 1
        
        for field in arrayField{
        
            field.tag = count
            field.delegate = self
            field.keyboardType = .NumberPad
            count++
        }
        
        
        minSteps.placeholder = String (YayMgr.userSettings.minSteps) + " steps"
        maxSteps.placeholder = String(YayMgr.userSettings.maxSteps) + " steps"
        
        minMiles.placeholder = String(YayMgr.userSettings.minMiles) + " miles"
        maxMiles.placeholder = String(YayMgr.userSettings.maxMiles) + " miles"
        
        minFloors.placeholder = String(YayMgr.userSettings.minFloors) + " floors"
        maxFloors.placeholder = String(YayMgr.userSettings.maxFloors) + " floors"

        FBLogout.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        // Create a button bar for the number pad
        let keyboardDoneButtonView = UIToolbar()
        keyboardDoneButtonView.sizeToFit()
        
        // Setup the buttons to be put in the system.
        let item = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("done") )
        let toolbarButtons = [item]
        
        //Put the buttons into the ToolBar and display the tool bar
        keyboardDoneButtonView.setItems(toolbarButtons, animated: false)
        textField.inputAccessoryView = keyboardDoneButtonView
        
        return true
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let invalidCharacters = NSCharacterSet(charactersInString: "0123456789").invertedSet
        if let _ = string.rangeOfCharacterFromSet(invalidCharacters, range:Range<String.Index>(start: string.startIndex, end: string.endIndex)) {
            return false
        }
        
        return true
    }
  
    func textFieldDidEndEditing(textField: UITextField) {
        
        textField.resignFirstResponder()
        if ((textField.text?.isEmpty) == false)
        {
            let tag = textField.tag
            
            switch tag
            {
            case 1 :
                YayMgr.userSettings.minSteps = Int(textField.text!)!
            case 2 :
                YayMgr.userSettings.maxSteps = Int(textField.text!)!
            case 3 :
                YayMgr.userSettings.minMiles = Int(textField.text!)!
            case 4 :
                YayMgr.userSettings.maxMiles = Int(textField.text!)!
                print(YayMgr.userSettings.maxMiles)
            case 5 :
                YayMgr.userSettings.minFloors = Int(textField.text!)!
            default:
                YayMgr.userSettings.maxFloors = Int(textField.text!)!
            }
            
            YayMgr.saveDefaults()
            
       }
    }
    
    func done(){
        self.view.endEditing(true)
    }

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        FBSDKLoginManager().logOut()
        YayMgr.logOut()
        performSegueWithIdentifier("GoLogin", sender: nil)
    }

}
