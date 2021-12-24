//
//  weatherTableViewCell.swift
//  WeatherApp
//
//  Created by Mithun on 08/04/20.
//  Copyright © 2020 Mithun. All rights reserved.
//

import UIKit

class weatherTableViewCell: UITableViewCell {

    @IBOutlet weak var tempMin: UILabel!
    @IBOutlet weak var tempMax: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var dayNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
