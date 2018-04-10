//
//  SearchResultViewCell.swift
//  WeatherApp
//
//  Created by Korisnik on 10/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//

import UIKit

class SearchResultViewCell: UITableViewCell {
    //MARK : Outlets
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var firstCharacterLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //MARK: Private functions
    /**
     Load Nib file and setup view our references
     */
    private func setupView(){
        Bundle.main.loadNibNamed("SearchResultViewCell", owner: self, options: nil)
        addSubview(view)
        view.frame = self.frame
    }
    
}
