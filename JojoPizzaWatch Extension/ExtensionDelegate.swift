//
//  ExtensionDelegate.swift
//  JojoPizzaWatch Extension
//
//  Created by abhay singh on 11/07/17.
//  Copyright © 2017 abhay singh. All rights reserved.
//

import WatchKit
import UserNotifications
class ExtensionDelegate: NSObject, WKExtensionDelegate, UNUserNotificationCenterDelegate {

    var isGrantedAccess = false
    
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        setCategories()
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert]) { (granted, error) in
            self.isGrantedAccess = granted
            if granted == false {
                print("Notification Error \(String(describing: error?.localizedDescription))")
            }
        }
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompleted()
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompleted()
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompleted()
            default:
                // make sure to complete unhandled task types
                task.setTaskCompleted()
            }
        }
    }
    
    //MARK: -Delegates
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound,.alert])
        print("Will present!")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let actionIdentifier = response.actionIdentifier
        if actionIdentifier == "dessert.action"{
            print("Dessert")
        }
        if actionIdentifier == "next.action"{
            print("Next Action")
        }
        if actionIdentifier == "no.dessert.action"{
            print("No Dessert")
        }
        if actionIdentifier == "snooze.action"{
            print("Snooze!!")
        }
        if actionIdentifier == "stop.action"{
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()
            center.removeAllDeliveredNotifications()
        }
        
        completionHandler()
    }
    
    func setCategories(){
        let nextStepAction = UNNotificationAction(identifier: "next.step.action", title: "Next", options: [])
        let stopAction = UNNotificationAction(identifier: "stop.action", title: "Stop", options: [])
        let snoozeAction = UNNotificationAction(identifier: "snooze.action", title: "Snooze", options: [])
        let dessertAction = UNNotificationAction(identifier: "dessert.action", title: "Hot Fudge", options: [])
        let noDessertAction = UNNotificationAction(identifier: "no.dessert.action", title: "No Dessert", options: [])
        let textInputAction = UNTextInputNotificationAction(identifier: "text.input", title: "Comment", options: [])
        let pizzaCategory = UNNotificationCategory(identifier: "pizza.steps.category", actions: [nextStepAction, stopAction, textInputAction], intentIdentifiers: [], options: [])
        let snoozeCategory = UNNotificationCategory(identifier: "snooze.category", actions: [snoozeAction], intentIdentifiers: [], options: [])
        let dessertCategory = UNNotificationCategory(identifier: "dessert.category", actions: [dessertAction, noDessertAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories( [pizzaCategory, snoozeCategory, dessertCategory] )
        
    }

}
