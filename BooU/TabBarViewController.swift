//
//  TabBarViewController.swift
//  BooU
//
//  Created by Daria on 24.01.16.
//  Copyright © 2016 Daria. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("View tab bar loaded")
        YayMgr.load()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

}
