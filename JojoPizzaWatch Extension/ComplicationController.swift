//
//  ComplicationController.swift
//  JojoPizzaWatch Extension
//
//  Created by abhay singh on 11/07/17.
//  Copyright © 2017 abhay singh. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    var startDate = Date()
    let events = ["Making Pizza","Baking Pizza","Boxing Pizza","Delivering Pizza","Eating Pizza"]
    
    //Templates
    func utilitarianLarge(text:String) -> CLKComplicationTemplate{
        let template = CLKComplicationTemplateUtilitarianLargeFlat()
        template.textProvider = CLKSimpleTextProvider(text:text)
//        template.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "Utilitarian")!)
        return template
    }
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(startDate)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(Date(timeInterval: 7200, since: startDate))
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        if complication.family == .utilitarianLarge{
            let timeLineEntry = CLKComplicationTimelineEntry(date: startDate, complicationTemplate: utilitarianLarge(text: "Starting Pizza"))
            handler(timeLineEntry)
            return
        }
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        var timelineEntries:[CLKComplicationTimelineEntry] = []
        for time in 0..<events.count{
            if complication.family == .utilitarianLarge{
                let date = Date(timeInterval: TimeInterval(time) * 300.0, since: startDate)
                let timelineEntry = CLKComplicationTimelineEntry(date: date, complicationTemplate: utilitarianLarge(text: events[time]))
                timelineEntries += [timelineEntry]
            }
        }
        handler(timelineEntries)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        var template:CLKComplicationTemplate? = nil
        if complication.family == .utilitarianLarge {
            template = utilitarianLarge(text: "-- ------")
        }
        handler(template)
    }
    
}
