//
//  DetailInterfaceController.swift
//  JojoPizzaNotification
//
//  Created by abhay singh on 11/07/17.
//  Copyright © 2017 abhay singh. All rights reserved.
//

import WatchKit
import Foundation


class DetailInterfaceController: WKInterfaceController {

    @IBOutlet var stepName: WKInterfaceLabel!
    @IBOutlet var stepImage: WKInterfaceImage!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if let dict = context as? [String: Any]{
            stepName.setText(dict["StepName"] as? String)
            stepImage.setImageNamed("MakePizza_" + String(format: "%d", dict["ImageNo"] as! Int) + ".jpg")
        }
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
