//
//  BottomWeatherView.swift
//  WeatherApp
//
//  Created by Korisnik on 09/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//

import UIKit

class BottomWeatherView: UIStackView {
    
    let title : UILabel = {
        let label = UILabel()
        label.font = Theme.getNormalFont()
        label.textColor = R.Colors.transparentWhite
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    private func setupView() {
        self.axis = .vertical
        self.distribution = .equalSpacing
        self.addArrangedSubview(title)
        self.addArrangedSubview(imageView)
        //setup constraints
        let constraints = [
            //setup title
            title.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            title.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 8),
            title.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -8),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}
