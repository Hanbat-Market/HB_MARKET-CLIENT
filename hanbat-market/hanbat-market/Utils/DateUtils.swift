//
//  DateUtils.swift
//  hanbat-market
//
//  Created by dongs on 3/20/24.
//

import Foundation

struct DateUtils {
    static func relativeTimeString(from dateString: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        guard let date = dateFormatter.date(from: dateString) else {
            return "Invalid Date"
        }
        
        let now = Date()
        let secondsAgo = Int(now.timeIntervalSince(date))
        let minutesAgo = secondsAgo / 60
        let hoursAgo = minutesAgo / 60
        
        if secondsAgo < 60 {
            return "\(secondsAgo)초 전"
        } else if minutesAgo < 60 {
            return "\(minutesAgo)분 전"
        } else if hoursAgo < 24 {
            return "\(hoursAgo)시간 전"
        } else {
            let daysAgo = hoursAgo / 24
            return "\(daysAgo)일 전"
        }
    }
    
    static func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일 EEEE"
        return dateFormatter.string(from: date)
    }
    
    static func formatDateTime(date: Date, hour:Int, minute: Int) -> String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let formattedDate = dateFormatter.string(from: date)
        
        let formattedHour = String(format: "%02d", hour)
        let formattedMinute = String(format: "%02d", minute)
        
        let combinedDateTimeString = "\(formattedDate)T\(formattedHour):\(formattedMinute):00.000Z"
        
        return combinedDateTimeString
    }
}

