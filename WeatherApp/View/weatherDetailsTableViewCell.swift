//
//  weatherDetailsTableViewCell.swift
//  WeatherApp
//
//  Created by Mithun on 08/04/20.
//  Copyright © 2020 Mithun. All rights reserved.
//

import UIKit

class weatherDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var valueOne: UILabel!
    @IBOutlet weak var headingTwo: UILabel!
    @IBOutlet weak var valueTwo: UILabel!
    
    @IBOutlet weak var headingOne: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
