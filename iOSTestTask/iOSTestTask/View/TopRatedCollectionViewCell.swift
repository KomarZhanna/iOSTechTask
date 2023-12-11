//
//  TopRatedCollectionViewCell.swift
//  iOSTestTask
//
//  Created by Zhanna Komar on 08.12.2023.
//

import Foundation
import UIKit

class TopRatedTableViewCell: UITableViewCell {
    @IBOutlet weak var movieLabel: UILabel!
    @IBOutlet weak var movieVoteAverage: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor.white
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 15, left: 5, bottom: 15, right: 5))
    }
}
