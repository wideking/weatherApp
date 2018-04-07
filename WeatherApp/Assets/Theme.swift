//
//  Theme.swift
//  WeatherApp
//
//  Created by Korisnik on 06/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//

import UIKit
struct Theme {
    static let normalFontSize : CGFloat = 14
    static let extraFontSize : CGFloat = 48
    static let hugeFontSize : CGFloat = 72
    
    static func getNormalFont() -> UIFont {
        return UIFont.systemFont(ofSize: normalFontSize)
    }
    static func getExtraFont() -> UIFont {
    return UIFont.systemFont(ofSize: extraFontSize)
    }
}
