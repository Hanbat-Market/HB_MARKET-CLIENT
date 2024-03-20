//
//  DateUtils.swift
//  hanbat-market
//
//  Created by dongs on 3/20/24.
//

import Foundation

struct DateUtils {
    static func relativeTimeString(from dateString: String) -> String {
        print("[날짜]", dateString)
        
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
}

