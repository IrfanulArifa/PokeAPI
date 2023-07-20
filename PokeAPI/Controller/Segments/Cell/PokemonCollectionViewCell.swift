//
//  PokemonCollectionViewCell.swift
//  PokeAPI
//
//  Created by Irfanul Arifa on 12/07/23.
//

import UIKit

class PokemonCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var pokemonName: UILabel!
  @IBOutlet weak var pokemonPict: UIImageView!
  @IBOutlet weak var pokemonID: UILabel!
  @IBOutlet weak var viewColor: UIView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
