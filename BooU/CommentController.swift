//
//  CommentController.swift
//  BooU
//
//  Created by Daria on 30.01.16.
//  Copyright © 2016 Daria. All rights reserved.
//

import UIKit

class CommentController: UIViewController {
    
    
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CommentSaveSegue" {
            let comment = Comment(Commentor: YayMgr.owner, Comment: textView.text.stringByReplacingOccurrencesOfString("\n", withString: ""), Timestamp: NSDate().timeIntervalSince1970)
          
            let controller = segue.destinationViewController as! PostDetailController
            controller.newCom = comment
        }
    }
    
    @IBAction func cancel(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func post(segue: UIStoryboardSegue) {
        
    }

}
