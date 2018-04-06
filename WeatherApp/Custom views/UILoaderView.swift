//
//  LoaderView.swift
//  WeatherApp
//
//  Created by Korisnik on 06/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//

import UIKit
//todo how to make view that just wraps content?
class UILoaderView: UIView {
    private let activityInicator = UIActivityIndicatorView()
    let label = UILabel()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    private func initializeSubviews() {
        self.backgroundColor = UIColor.blue
        activityInicator.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(label)
        self.addSubview(activityInicator)
        let viewDict = [
            "label":label,
            "indicator":activityInicator
        ]
        /**
         view should look like this: (all content centered)
         |
         |
         |---(picture-rating)---|
         |
         |
         */
        //center vertically
         self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(<=1)-[label]-|", options: [.alignAllCenterX], metrics: nil, views: viewDict))
         self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[indicator]-(<=1)-|", options: [.alignAllCenterX], metrics: nil, views: viewDict))
        //group horizontally
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[label]-[indicator]", options: [.alignAllLastBaseline], metrics: nil, views: viewDict))
         //self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[label]-[indicator]", options: [.alignAllCenterY,.ali], metrics: nil, views: viewDict))
        
  
        activityInicator.startAnimating()
        label.textColor=UIColor.gray
        label.font=Theme.getNormalFont()
    }
    
    
}
