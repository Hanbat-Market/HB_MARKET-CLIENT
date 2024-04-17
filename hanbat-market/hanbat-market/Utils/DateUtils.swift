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
        
        let formattedDate = dateFormatter.string(from: date).prefix(10)
        
        let formattedHour = String(format: "%02d", hour)
        let formattedMinute = String(format: "%02d", minute)
        
        let combinedDateTimeString = "\(formattedDate) \(formattedHour):\(formattedMinute):00"
        
        return combinedDateTimeString
    }
    
    static func formatFullDateTime(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        guard let date = dateFormatter.date(from: dateString) else {
            return "Invalid Date"
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        if let year = components.year,
           let month = components.month,
           let day = components.day,
           let hour = components.hour,
           let minute = components.minute {
            return "\(year)년 \(month)월 \(day)일 \(hour)시 \(minute)분"
        }
        return "2024년 01월 01일 00시 00분"
    }
    
    static func formatChatTime(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        guard let date = dateFormatter.date(from: dateString) else {
            return "Invalid Date"
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        if let hour = components.hour,
           let minute = components.minute {
            let krTime = hour > 12 ? "오후" : "오전"
            let formattedHour = String(format: "%02d", hour % 12)
            let formattedMinute = String(format: "%02d", minute)
            return "\(krTime) \(formattedHour):\(formattedMinute)"
        }
        return "2024년 01월 01일 00시 00분"
    }
}

