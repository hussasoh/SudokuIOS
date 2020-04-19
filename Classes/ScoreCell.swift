//
//  ScoreCell.swift
//
//  Created by Tomislav Busic on 2020-04-11.
//  Copyright © 2020 Tomislav Busic. All rights reserved.
//

import UIKit

class ScoreCell: UITableViewCell {
    
    let primaryLabel = UILabel()        // primary label on the individual cell
    let secondaryLabel = UILabel()      // secondary label on the individual cell
    let myImageView = UIImageView()     // image that is shown on the cell
    
    // Style for each cell, and adding content to each cell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        primaryLabel.textAlignment = .left                      // align this text to the left of the cell
        primaryLabel.font = UIFont.boldSystemFont(ofSize: 30)   // bold style, with 30 style font
        primaryLabel.backgroundColor = .clear                   // clear background color
        primaryLabel.textColor = .black                         // text color black
        
        secondaryLabel.textAlignment = .left
        secondaryLabel.font = UIFont.boldSystemFont(ofSize: 16)
        secondaryLabel.backgroundColor = .clear
        secondaryLabel.textColor = .blue
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // adding onto subview our primary label, secondary label, image view
        contentView.addSubview(primaryLabel)
        contentView.addSubview(secondaryLabel)
        contentView.addSubview(myImageView)
    }
    
    // layout / dimensions of each of the properties in the cell (Height, width, and x and y axis)
    override func layoutSubviews() {
        primaryLabel.frame = CGRect(x: 100, y: 5, width: 460, height: 30)
        secondaryLabel.frame = CGRect(x: 100, y: 40, width: 460, height: 30)
        myImageView.frame = CGRect(x: 5, y: 5, width: 45, height: 45)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Selected view animation
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
