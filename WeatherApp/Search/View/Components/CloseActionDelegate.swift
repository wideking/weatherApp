//
//  CloseActionDelegate.swift
//  WeatherApp
//
//  Created by Korisnik on 10/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//

import Foundation
protocol CloseActionDelegate {
    
}
extension CloseActionDelegate where Self: ViewController {
    
    func onCloseClicked(){
        debugPrint("On close action is clicked!")
        self.navigationController?.popViewController(animated: true)
    }
}
