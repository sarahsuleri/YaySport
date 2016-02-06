//
//  ContainerController.swift
//  BooU
//
//  Created by Daria on 30.01.16.
//  Copyright © 2016 Daria. All rights reserved.
//

import UIKit

class ContainerController: UIViewController {
    
    var MyActivity: Bool!
    var detailItemIndex: Int!
    var circleColor: UIColor!
    @IBOutlet weak var noComPic: UIImageView!
    @IBOutlet weak var circleButton: CircleButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        circleButton.fillColor = circleColor
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
            controller.noComPic = noComPic
        }
    }
}
