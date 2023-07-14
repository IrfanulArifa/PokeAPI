//
//  MovesTableViewCell.swift
//  PokeAPI
//
//  Created by Irfanul Arifa on 13/07/23.
//

import UIKit

class MovesTableViewCell: UITableViewCell {

  @IBOutlet weak var moveValue: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
