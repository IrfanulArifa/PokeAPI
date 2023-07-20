//
//  FavoriteTableViewCell.swift
//  PokeAPI
//
//  Created by Irfanul Arifa on 17/07/23.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

  @IBOutlet weak var pokemonImage: UIImageView!
  @IBOutlet weak var pokemonName: UILabel!
  @IBOutlet weak var pokemonId: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
