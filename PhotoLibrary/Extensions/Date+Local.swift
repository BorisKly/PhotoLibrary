//
//  Date+Local.swift
//  PhotoLibrary
//
//  Created by Borys Klykavka on 28.08.2023.
//


import Foundation

// MARK: - Extensions

extension Date {

    func formatTo(style: DateFormatterStyle) -> String {
        let dateFormatter = DateFormatter()
       
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = style.rawValue
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
       
        return dateFormatter.string(from: self)
    }

}
