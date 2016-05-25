//
//  Formatters.swift
//  NSExpressionDemo
//
//  Created by Brock Boland on 5/24/16.
//  Copyright © 2016 Vokal. All rights reserved.
//

import Foundation

struct Formatters {

    static let intFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        //format rounded to integer value
        formatter.numberStyle = .NoStyle
        return formatter
    }()

    static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return formatter
    }()

}