//
//  PokeModel.swift
//  PokeAPI
//
//  Created by Irfanul Arifa on 12/07/23.
//

import Foundation

import UIKit

struct Welcome: Codable{
  let results: [Result]
  let next: String
}

struct Result: Codable{
  let name: String
  let url: String
  
  enum CodingKeys: CodingKey {
    case name
    case url
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.url = try container.decode(String.self, forKey: .url)
  }
}

struct Detail: Codable{
  let abilities: [Ability]
  let id: Int
  let species: Species
  let sprites: Sprites
  let height: Int
  let weight: Int
  let stats: [Stat]
  let moves: [Move]
  let types: [TypeElement]
}

struct Ability: Codable{
  let ability: Species
}

struct Species: Codable{
  let name: String
  let url: String
}

struct Sprites: Codable{
  let back_default: String
  let back_shiny: String
  let front_default: String
  let front_shiny: String
  let other: Other
}

struct Stat: Codable{
  let base_stat, effort: Int
  let stat: Species
}

struct Move: Codable{
  let move: Species
}

struct Other: Codable{
  let officialArtwork : OfficialArtwork
  enum CodingKeys: String, CodingKey{
    case officialArtwork = "official-artwork"
  }
}

struct OfficialArtwork: Codable{
  let front_default: String
  let front_shiny: String
}

struct TypeElement: Codable{
  let type: Species
}
