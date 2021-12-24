//
//  weatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Mithun on 09/04/20.
//  Copyright © 2020 Mithun. All rights reserved.
//

import UIKit

class weatherCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var timelabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
