//
//  DataParser.swift
//  PokeAPI
//
//  Created by Irfanul Arifa on 20/07/23.
//

import UIKit

class DataParser {
  let storyboardParsing = UIStoryboard(name: "DetailView", bundle: nil)
  func SendToAbout(_ selectedURL: String) {
    guard let about = storyboardParsing.instantiateViewController(withIdentifier: "AboutSegmentViewController") as? AboutSegmentViewController else { return }
    return about.sendConfigurationToAbout(selectedURL)
  }
  
  func SendToBase(_ selectedURL: String) {
    guard let baseStats = storyboardParsing.instantiateViewController(withIdentifier: "BaseStatsViewController") as? BaseStatsViewController else { return }
    return baseStats.sendConfigurationToBaseStats(selectedURL)
  }
  
  func SendToMove(_ selectedURL: String) {
    guard let moves = storyboardParsing.instantiateViewController(withIdentifier: "MovesSegmentViewController") as? MovesSegmentViewController else { return }
    return moves.sendConfigurationToMoves(selectedURL)
  }
}
