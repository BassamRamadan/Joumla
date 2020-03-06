//
//  TabGuideController.swift
//  Tourist-Guide
//
//  Created by mac on 11/28/19.
//  Copyright © 2019 Tamkeen. All rights reserved.
//

import UIKit

class TabUserController: UITabBarController , UITabBarControllerDelegate{
    
    
    var index :Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = index ?? 0
    }
}
