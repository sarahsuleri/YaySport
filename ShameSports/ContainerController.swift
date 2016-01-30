//
//  ContainerController.swift
//  ShameSports
//
//  Created by Daria on 30.01.16.
//  Copyright © 2016 Daria. All rights reserved.
//

import UIKit

class ContainerController: UIViewController {
    
    var MyActivity: Bool!
    var detailItemIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowComments" {
            let controller = (segue.destinationViewController as! PostDetailController)
            controller.MyActivity = MyActivity
            controller.detailItemIndex = detailItemIndex
        }
    }
}
