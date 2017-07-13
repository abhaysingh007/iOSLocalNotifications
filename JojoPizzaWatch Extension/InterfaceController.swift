//
//  InterfaceController.swift
//  JojoPizzaWatch Extension
//
//  Created by abhay singh on 11/07/17.
//  Copyright © 2017 abhay singh. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBAction func didPressAddDessert() {
//        presentController(withName: "Schedule", context: nil)
        DessertNotification.addRequest()
    }
    @IBAction func didPressMakePizza() {
        pushController(withName: "Steps", context: nil)
    }
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
