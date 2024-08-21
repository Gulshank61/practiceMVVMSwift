//
//  DateUtility.swift
//  practiceMVVM
//
//  Created by Gulshan Khandale  on 21/08/24.
//

import Foundation

class DateUtility {
    
    private init(){}
    
    static func formatDate(from dateString: String,input inputDateFormat: String, output outputDateFormat:String) -> String {
        
        let inputFormatter:DateFormatter = DateFormatter()
        inputFormatter.dateFormat = inputDateFormat
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let outputFormatter:DateFormatter = DateFormatter()
        outputFormatter.dateFormat = outputDateFormat
        outputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        
        if let date = inputFormatter.date(from: dateString){
            let formattedDateString = outputFormatter.string(from: date)
            return formattedDateString
        }
        
        return "Invalid Date"
    }
}
