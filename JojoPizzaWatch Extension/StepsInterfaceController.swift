//
//  StepsInterfaceController.swift
//  JojoPizzaNotification
//
//  Created by abhay singh on 11/07/17.
//  Copyright © 2017 abhay singh. All rights reserved.
//

import WatchKit
import Foundation


class StepsInterfaceController: WKInterfaceController {

    let pizzaSteps = ["Let's Make Pizza", "Roll Dough", "Add Cheese", "Add Sauce", "Add Ingredients", "Bake Pizza", "It's Done"]

    
    @IBOutlet var pizzaStepTable: WKInterfaceTable!

    func tableRefresh(){
        pizzaStepTable.setNumberOfRows(pizzaSteps.count, withRowType: "Row")
        for index in 0..<pizzaSteps.count{
            let row = pizzaStepTable.rowController(at: index) as! RowController
            row.stepName.setText(pizzaSteps[index])
        }
        
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        tableRefresh()
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
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        setTitle(pizzaSteps[rowIndex])
        pizzaStepTable.performSegue(forRow: rowIndex)
    }
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        let context: [String: Any] = ["StepName": pizzaSteps[rowIndex], "ImageNo": rowIndex]
        return context
    }

}
