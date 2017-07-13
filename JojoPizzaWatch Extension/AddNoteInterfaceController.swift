//
//  AddNoteInterfaceController.swift
//  JojoPizzaNotification
//
//  Created by abhay singh on 12/07/17.
//  Copyright © 2017 abhay singh. All rights reserved.
//

import WatchKit
import Foundation


class AddNoteInterfaceController: WKInterfaceController {

    @IBOutlet var text: WKInterfaceLabel!
    @IBAction func didPressDismiss() {
        dismiss()
    }
    @IBAction func didPressAddNote() {
        let suggestions = ["As soon as possible", "Urgent", "Take away", "Later in evening", "Not Sure", "Payment Due", "Payment Completed"]
        presentTextInputController(withSuggestions: suggestions, allowedInputMode: .allowEmoji) { (results) -> Void in
            guard let responses = results else{
                self.text.setText("Cancelled")
                return
            }
            let text = responses[0] as! String
            self.text.setText(text)
        }
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
