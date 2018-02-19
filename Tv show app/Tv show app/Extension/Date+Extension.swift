//
//  Date+Extension.swift
//  Tv show app
//
//  Created by Yveslym on 2/16/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import Foundation
extension Date {
    static func dayLeft(day: Date) -> DateComponents{
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let day2 = calendar.startOfDay(for: day)
        return calendar.dateComponents([.day], from: today, to: day2)
    }
}

extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: self) else {return nil}
        return date
    }
}
