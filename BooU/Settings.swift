//
//  Settings.swift
//  BooU
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
    
    @IBOutlet weak var soundSwitch: UISwitch!
    
   /*
    * Added a place holder text for each text field and assign each a tag
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let arrayField:[UITextField] = [minSteps,maxSteps,minMiles,maxMiles,minFloors,maxFloors]
        var count = 1
        
        for field in arrayField{
        
            field.tag = count
            field.delegate = self
            field.keyboardType = .NumberPad
            count += 1
        }
        
        
        minSteps.placeholder = String (YayMgr.userSettings.minSteps) + " steps"
        maxSteps.placeholder = String(YayMgr.userSettings.maxSteps) + " steps"
        
        minMiles.placeholder = String(YayMgr.userSettings.minMiles) + " miles"
        maxMiles.placeholder = String(YayMgr.userSettings.maxMiles) + " miles"
        
        minFloors.placeholder = String(YayMgr.userSettings.minFloors) + " floors"
        maxFloors.placeholder = String(YayMgr.userSettings.maxFloors) + " floors"
        
        soundSwitch.setOn(Bool(YayMgr.userSettings.hasSound), animated: true)
        soundSwitch.addTarget(self, action: #selector(Settings.soundSwitchChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)


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
        let item = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(Settings.done) )
        let toolbarButtons = [item]
        
        //Put the buttons into the ToolBar and display the tool bar
        keyboardDoneButtonView.setItems(toolbarButtons, animated: false)
        textField.inputAccessoryView = keyboardDoneButtonView
        
        return true
    }

    /*
    * Check whether the text field has only number and its length not more than 10
    */
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let invalidCharacters = NSCharacterSet(charactersInString: "0123456789").invertedSet
        let str = string.rangeOfCharacterFromSet(invalidCharacters, range:Range<String.Index>(string.startIndex ..< string.endIndex))
        if str != nil || (textField.text?.characters.count > 10)
        {
            return false
        }
        
        return true
    }
  
    /*
    * Update the property values with the respective user input
    */
    func textFieldDidEndEditing(textField: UITextField) {
        
        textField.resignFirstResponder()
        if ((textField.text?.isEmpty) == false)
        {
            let tag = textField.tag
            
            switch tag
            {
            case 1 :
                let oldValue = YayMgr.userSettings.minSteps
                YayMgr.userSettings.minSteps = Int(textField.text!)!
                checkBoundaries(1,oldValue: oldValue)
            case 2 :
                let oldValue = YayMgr.userSettings.maxSteps
                YayMgr.userSettings.maxSteps = Int(textField.text!)!
                checkBoundaries(2,oldValue: oldValue)
            case 3 :
                let oldValue = YayMgr.userSettings.minMiles
                YayMgr.userSettings.minMiles = Int(textField.text!)!
                checkBoundaries(3,oldValue: oldValue)
            case 4 :
                let oldValue = YayMgr.userSettings.maxMiles
                YayMgr.userSettings.maxMiles = Int(textField.text!)!
                checkBoundaries(4,oldValue: oldValue)
            case 5 :
                let oldValue = YayMgr.userSettings.minFloors
                YayMgr.userSettings.minFloors = Int(textField.text!)!
                checkBoundaries(5,oldValue: oldValue)
            default:
                let oldValue = YayMgr.userSettings.maxFloors
                YayMgr.userSettings.maxFloors = Int(textField.text!)!
                checkBoundaries(6,oldValue: oldValue)
            
            }
            

            
       }
    }
    
    /*
    * Check that max is not less than min then save changes in user default
    */
    func checkBoundaries(buttonId:Int, oldValue:Int)
 {
  
    
        let alert = UIAlertController(title: "Inconsistency!", message: "The maximum value can't be less than the minimum.", preferredStyle: UIAlertControllerStyle.Alert)
    if (YayMgr.userSettings.minSteps > YayMgr.userSettings.maxSteps || YayMgr.userSettings.minMiles > YayMgr.userSettings.maxMiles || YayMgr.userSettings.minFloors > YayMgr.userSettings.maxFloors  )
    {
        
        switch buttonId
        {
            case 1 :
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {  action in
                self.minSteps.text = nil
                self.minSteps.placeholder = String (oldValue) + " steps"}))
            case 2 :
                self.maxSteps.text = nil
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in self.maxSteps.placeholder = String(oldValue) + " steps" }))
            case 3 :
                self.minMiles.text = nil
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in self.minMiles.placeholder = String(oldValue) + " miles"}))
            case 4 :
                self.maxMiles.text = nil
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in self.maxMiles.placeholder = String(oldValue) + " miles" }))
            case 5 :
                self.minFloors.text = nil
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in self.minFloors.placeholder = String(oldValue) + " floors" }))
            default :
                self.maxFloors.text = nil
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in self.maxFloors.placeholder = String(oldValue) + " floors" }))
            
        }
        
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    else{
        YayMgr.saveDefaults()
    }
    
    
 }
    func soundSwitchChanged(_soundSwitch: UISwitch) {
        saveSoundSettings()
    }
    
    func  saveSoundSettings()
    {
        YayMgr.userSettings.hasSound = soundSwitch.on
        YayMgr.saveDefaults()
    }
    
    func done(){
        
        self.view.endEditing(true)
    }

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
    }
    /*
    * Once user logs out, call log out function and goes to the first screen.
    */
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        FBSDKLoginManager().logOut()
        YayMgr.logOut()
        YayMgr.load()
        performSegueWithIdentifier("GoLogin", sender: nil)
    }
    
    

}
