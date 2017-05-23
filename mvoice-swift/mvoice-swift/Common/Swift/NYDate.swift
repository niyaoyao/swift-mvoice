//
//  NYDate.swift
//  mvoice-swift
//
//  Created by NY on 5/23/17.
//  Copyright © 2017 NY. All rights reserved.
//

import Foundation

extension Date {
    func currentDateString(formatString: String) -> String {
        return dateToString(formatString: formatString, date: Date())
    }
    func dateToString(formatString: String, date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString
        return dateFormatter.string(from: date)
    }
}
