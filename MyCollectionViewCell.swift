//
//  MyCollectionViewCell.swift
//  fitnessPro
//
//  Created by Nathan Chen on 5/28/17.
//  Copyright © 2017 Nathan Chen. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var backgroundPic: UIImageView!
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var likeButton: DOFavoriteButton!
    override func awakeFromNib() {
        likeButton.imageColorOn = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
        likeButton.circleColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
        likeButton.lineColor = UIColor(red: 41/255, green: 128/255, blue: 185/255, alpha: 1.0)
    }
    @IBAction func buttonTapped(_ sender: DOFavoriteButton) {
        if sender.isSelected {
            sender.deselect()
        } else {
            sender.select()
        }

    }
}
