//
//  DessertNotification.swift
//  JojoPizzaNotification
//
//  Created by abhay singh on 13/07/17.
//  Copyright © 2017 abhay singh. All rights reserved.
//

import WatchKit
import  UserNotifications
class DessertNotification: NSObject {

    class func addRequest(){
        let isGrantedAccess = (WKExtension.shared().delegate as! ExtensionDelegate).isGrantedAccess
        if isGrantedAccess{
                let content = UNMutableNotificationContent()
                content.title = "Make Dessert"
                content.body = " Hot Fudgu"
                content.categoryIdentifier = "dessert.category"
            
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
                let request = UNNotificationRequest(identifier: "Dessert", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                    if error != nil{
                        print("Dessert Error \(String(describing: error?.localizedDescription))")
                    }
                })
        }
    }
    
}
