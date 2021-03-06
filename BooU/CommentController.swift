//
//  CommentController.swift
//  BooU
//
//  Created by Daria on 30.01.16.
//  Copyright © 2016 Daria. All rights reserved.
//

import UIKit

class CommentController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textView.text = "Add your comment"
        textView.textColor = UIColor.lightGrayColor()
        textView.becomeFirstResponder()
        textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
    }
    
    // Type comment text in the text view
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        let currentText: NSString = textView.text
        // Replace current text
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString: text)
        
        // If the text is empty string, put placeholder
        if updatedText.isEmpty {
            textView.text = "Add your comment"
            textView.textColor = UIColor.lightGrayColor()
            textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            return false
        }
        // Otherwise, type in black color
        else if textView.textColor == UIColor.lightGrayColor() && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
        return true
    }
    
    // Don't allow to put the cursor anywhere except from the beginning of
    // placeholder text
    func textViewDidChangeSelection(textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGrayColor() {
                textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            }
        }
    }
    
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CommentSaveSegue" {
            // Pass new comment to the previous contoller
            let comment = Comment(Commentor: YayMgr.owner, Comment: textView.text.stringByReplacingOccurrencesOfString("\n", withString: " "), Timestamp: NSDate().timeIntervalSince1970)
          
            let controller = segue.destinationViewController as! PostDetailController
            controller.newCom = comment
        }
    }
    
    
    // Unwind segue functions
    
    @IBAction func cancel(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func post(segue: UIStoryboardSegue) {
        
    }

}
