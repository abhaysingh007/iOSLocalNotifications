//
//  ViewController.swift
//  JojoPizzaNotification
//
//  Created by abhay singh on 05/07/17.
//  Copyright © 2017 abhay singh. All rights reserved.
//

import UIKit
import UserNotifications
class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    var isGrantedNotificationAccess: Bool = false
    var pizzaNumber = 0
    let pizzaSteps = ["Make Pizza", "Roll Dough", "Add Cheese", "Add Sauce", "Add Ingredients", "Bake Pizza", "Done"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            self.isGrantedNotificationAccess = granted
            if !granted{
                //add alert
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Delegates
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let action = response.actionIdentifier
        let request = response.notification.request
        if action == "next.step.action"{
            updatePizzaSteps(request:  request)
        }
        if action == "stop.action"{
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [request.identifier])
        }
        if action == "snooze.action"{
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
            let newRequest = UNNotificationRequest(identifier: request.identifier, content: request.content, trigger: trigger)
            UNUserNotificationCenter.current().add(newRequest, withCompletionHandler: { (error) in
                if error != nil{
                    print("\(String(describing: error?.localizedDescription))")
                }
            })
        }
        if action == "text.input"{
            let textResponse = response as! UNTextInputNotificationResponse
            let newContent = request.content.mutableCopy() as! UNMutableNotificationContent
            newContent.subtitle = textResponse.userText
            addNotification(trigger: request.trigger, content: newContent, identifier: request.identifier)
        }
        completionHandler()
    }
    
    func notificationAttachment(for identifier: String, resource: String, type: String) -> [ UNNotificationAttachment]{
        let extendedIdentifer = identifier + "." + type
        guard let path = Bundle.main.path(forResource: resource, ofType: type) else{
            print("The File \(resource).\(type) was not found")
            return []
        }
        let videoURL = URL(fileURLWithPath: path)
        do{
            let attachment = try UNNotificationAttachment(identifier: extendedIdentifer, url: videoURL, options: nil)
            return [attachment]
        }catch{
            print("The attachment was not loaded")
            return []
        }
        
    }
    
    func pizzaGif() -> [ UNNotificationAttachment]{
        let extendedIdentifer = "pizza.gif"
        guard let path = Bundle.main.path(forResource: "MakePizza_0", ofType: "gif") else{
            print("The file  was not found")
            return []
        }
        let videoURL = URL(fileURLWithPath: path)
        do{
            let attachment = try UNNotificationAttachment(identifier: extendedIdentifer, url: videoURL, options: [UNNotificationAttachmentOptionsThumbnailTimeKey: 11])
            return [attachment]
        }catch{
            print("The attachment was not loaded")
            return []
        }
        
    }
    
    func pizzaStepImage(step: Int) -> [UNNotificationAttachment]{
        let stepsString = String(format: "%i", step)
        let identifier = "pizza.step." + stepsString
        let resource = "MakePizza_" + stepsString
        let type = "jpg"
        return notificationAttachment(for: identifier, resource: resource, type: type)
    }
    
    //MARK: - Actions and Supporting Methods
    func updatePizzaSteps(request: UNNotificationRequest){
        if request.identifier.hasPrefix("message.pizza"){
            var stepNumber = request.content.userInfo["Step"] as! Int
            stepNumber = (stepNumber + 1) % pizzaSteps.count
            let updatedContent = makePizzaContent()
            updatedContent.body = pizzaSteps[stepNumber]
            updatedContent.userInfo["Step"] = stepNumber
            updatedContent.subtitle = request.content.subtitle
            updatedContent.attachments = pizzaStepImage(step: stepNumber)
            addNotification(trigger: request.trigger, content: updatedContent, identifier: request.identifier)
        }
    }
    
    func addNotification(trigger: UNNotificationTrigger?, content: UNMutableNotificationContent, identifier: String){
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request){ (error) in
            if error  != nil {
                print("error adding notification \(String(describing: error?.localizedDescription))")
            }
        }
     }
    
    
    func makePizzaContent() -> UNMutableNotificationContent{
        let content = UNMutableNotificationContent()
        content.title = "A Timed Pizza Step"
        content.body = "Making Pizza"
        content.userInfo = ["Step": 0]
        content.categoryIdentifier = "pizza.steps.category"
//        content.attachments = pizzaStepImage(step: 0)
        content.attachments = pizzaGif()
        return content
    }
    
    @IBAction func schedulePizza(_ sender: Any) {
        if isGrantedNotificationAccess{
            let content = UNMutableNotificationContent()
            content.title = "Schedule Pizza"
            content.body = "Time To Make A Pizza!!!!!"
            content.categoryIdentifier = "snooze.category"
            let attachment = notificationAttachment(for: "pizza.video", resource: "JojoPizzaMovie", type: "mp4")
//            let attachment = notificationAttachment(for: "pizza.mp3", resource: "Jojo", type: "mp3")
            content.attachments = attachment
            let unitFlag: Set<Calendar.Component> =  [.minute, .hour, .second]
            var date = Calendar.current.dateComponents(unitFlag, from: Date())
            date.second = date.second! + 15
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
            addNotification(trigger: trigger, content: content, identifier: "message.scheduled")
        }
    }
    @IBAction func makePizza(_ sender: Any) {
        if isGrantedNotificationAccess{
            pizzaNumber += 1
            let content = makePizzaContent()
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 7.0, repeats: false)
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
            content.subtitle = "Pizza \(pizzaNumber)"
            addNotification(trigger: trigger, content: content, identifier: "message.pizza.\(pizzaNumber)")
        }
    }
    @IBAction func nextPizzaStep(_ sender: Any) {
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            if let request = requests.first {
                if request.identifier.hasPrefix("message.pizza"){
                self.updatePizzaSteps(request: request)
                }else{
                    let content = request.content.mutableCopy() as! UNMutableNotificationContent
                    self.addNotification(trigger: request.trigger!, content: content, identifier: request.identifier)
                }
            }
        }
        
    }
    @IBAction func viewPendingPizzas(_ sender: Any) {
        UNUserNotificationCenter.current().getPendingNotificationRequests{
            (requestList) in
            print("\(Date()) ---> \(requestList.count) requests pending")
            for request in requestList{
                print("\(request.identifier) body: \(request.content.body)")
            }
        }
    }

    @IBAction func viewDeliveredPizzas(_ sender: Any) {
        
        UNUserNotificationCenter.current().getDeliveredNotifications { (notifications) in
            print("\(Date()) ---> \(notifications.count) delivered")
            for notification in notifications{
                print("\(notification.request.identifier) body: \(notification.request.content.body)")
            }
        }
        
    }
    @IBAction func removeNotifications(_ sender: Any) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            if let request = requests.first{
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [request.identifier])
            }
        }
    }
}

