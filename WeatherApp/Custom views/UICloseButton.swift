//
//  UICloseButton.swift
//  WeatherApp
//
//  Created by Korisnik on 11/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//

import UIKit
import SnapKit
class UICloseButton: UIControl {
    let imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView(){
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        let image = UIImage(named: "clear_icon")
        //todo check why image does not scale.
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = R.Colors.green
        //setup constraints
        //make imageview same as parent.
        imageView.snp.makeConstraints { [unowned self] (make) in
            make.edges.equalTo(self.snp.edges)
        }
    }
  /*  override var tintColor: UIColor! {
        get {
            return super.tintColor
        }
        set {
            super.tintColor = newValue
            imageView.tintColor = newValue
        }
    }
 */
    
    
}
