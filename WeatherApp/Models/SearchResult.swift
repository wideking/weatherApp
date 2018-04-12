//
//  SearchResult.swift
//  WeatherApp
//
//  Created by Korisnik on 11/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//

import Foundation
import UIKit
public struct SearchResult {
    let prefix: String
    let title: String
    let prefixColor: PrefixColor
    let city : City
}
enum PrefixColor : String {
    case A = "A"
    case B = "B"
    case C = "C"
    case D = "D"
    case E = "E"
    case F = "F"
    case G = "G"
    case H = "H"
    case I = "I"
    case J = "J"
    case L = "L"
    case K = "K"
    case M = "M"
    case N = "N"
    case O = "O"
    case P = "P"
    case Z = "Z"
    
    func value() -> UIColor{
        let color : UIColor
        switch self {
        case .A:
            color = R.Colors.grey
        case .B:
            color = UIColor.blue
        case .C:
            color = UIColor.red
        case .D:
            color = UIColor.lightGray
        case .E:
            color = UIColor.cyan
        case .F:
            color = UIColor.darkGray
        case .G:
            color = UIColor.lightGray
        case .H:
            color = UIColor.red
        case .I:
            color = UIColor.red
        case .J:
            color = UIColor.blue
        case .L:
            color = UIColor.blue
        case .K:
            color = UIColor.red
        case .M:
            color = UIColor.brown
        case .N:
            color = UIColor.lightGray
        case .O:
            color = UIColor.red
        case .P:
            color = UIColor.brown
        case .Z:
            color = UIColor.darkGray
        default:
            color = R.Colors.green
        }
        return color
    }
}
