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
    
    //MARK : Properties
    var addCustomConstraints = true
    //MARK: Views initialization
    private let activityInicator : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = R.Colors.grey
        return indicator
    }()
    let label : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor=R.Colors.grey
        label.font=Theme.getNormalFont()
        return label
    }()
    private lazy var stackview :UIStackView = { [unowned self] in
        let stackview = UIStackView(arrangedSubviews: [self.label,
                                                       self.activityInicator])
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.distribution = .equalCentering
        return stackview
        }()
    
    //MARK : Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    override func updateConstraints() {
        if(addCustomConstraints){
            debugPrint("Inserting items constrains!")
            addCustomConstraints = false
            NSLayoutConstraint.activate([stackview.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                                         stackview.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                                         activityInicator.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 16)
                                         ])
        
        }
        super.updateConstraints()
    }
    
    //MARK: Private methods
    
    private func initializeSubviews() {
        debugPrint("initializing subviews")
        self.backgroundColor = R.Colors.white
        self.addSubview(stackview)
        self.setNeedsUpdateConstraints()
        activityInicator.startAnimating()
    }
    
    
}
