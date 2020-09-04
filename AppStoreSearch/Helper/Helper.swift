//
//  Helper.swift
//  AppStoreSearch
//
//  Created by Hyun BnS on 2020/08/08.
//  Copyright © 2020 Hyun BnS. All rights reserved.
//

import UIKit

extension String {
    
    static func stringForRating(_ count: Int64) -> String {
        if count >= 1000000 {
            let n = count / 1000000
            let d = count % 1000000
            
            let numberFormatter = NumberFormatter()
            let number = numberFormatter.number(from: "\(n).\(d)")
            let numberFloatValue = number?.floatValue
            return String(format: "%.1fM", numberFloatValue!)
        } else if count >= 1000 {
            let n = count / 1000
            let d = count % 1000
            
            let numberFormatter = NumberFormatter()
            let number = numberFormatter.number(from: "\(n).\(d)")
            let numberFloatValue = number?.floatValue
            return String(format: "%.1fK", numberFloatValue!)
        }
        return "\(count)"
    }
    
    static func convertMBFormatter(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = ByteCountFormatter.Units.useMB
        formatter.countStyle = ByteCountFormatter.CountStyle.decimal
        formatter.includesUnit = false
        
        let result = formatter.string(fromByteCount: bytes) as String
        return "\(result)MB"
    }
}

extension Date {
    
    /**
     애플 날짜 형식 문자로 부터 Date 타입으로 변환 함수
     - parameters:
     - dateString: 날짜 문자열
     - returns: 날짜
     */
    static func convertAppleStringToDate(_ dateString: String?) -> Date? {
        guard let dateString = dateString else {
            return nil
        }
        if dateString.isEmpty {
            return nil
        }
        return convertStringToDate(dateString, dateFormat: "yyyy-MM-dd'T'HH:mm:ssZ")
    }
    
    /**
     애플 날짜 형식 문자로 부터 Date 타입으로 변환 함수
     - parameters:
     - dateString: 날짜 문자열
     - dateFormat: Date Format
     - returns: 날짜
     */
    static func convertStringToDate(_ dateString: String, dateFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        //dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: dateString)
    }
    
    /**
     날짜를 간소화해서 이전 형식으로 표시
     - parameters:
     - date: 날짜
     - returns: X 년 전 등등으로 반환
     */
    static func timeAgoSince(_ date: Date?) -> String {
        guard let date = date else {
            return ""
        }
        
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
        
        if let year = components.year, year >= 1 {
            return "\(year)년 전"
        }
        
        if let month = components.month, month >= 1 {
            return "\(month)달 전"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "\(week)주 전"
        }
        
        if let day = components.day, day >= 1 {
            return "\(day)일 전"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "\(hour)시간 전"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "\(minute)분 전"
        }
        
        if let second = components.second, second >= 3 {
            return "\(second)초 전"
        }
        
        return "방금 전"
        
    }
    
}
