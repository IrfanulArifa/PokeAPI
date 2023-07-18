//
//  NetworkServices.swift
//  PokeAPI
//
//  Created by Irfanul Arifa on 12/07/23.
//

import Foundation

class NetworkServices {
  let offset = "0"
  let limit = "1280"
  func getPokemon() async throws -> [Result]{
    var component = URLComponents(string: "https://pokeapi.co/api/v2/pokemon")!
    component.queryItems = [
      URLQueryItem(name: "offset", value: offset),
      URLQueryItem(name: "limit", value: limit)
    ]
    let request = URLRequest(url:component.url!)
    let (data, responses) = try await URLSession.shared.data(for: request)
    guard (responses as? HTTPURLResponse)?.statusCode == 200 else {
      fatalError("Error Can't Fetching Data")
    }
    let decoder = JSONDecoder()
    let result = try decoder.decode(Welcome.self, from: data)
    return result.results
  }

  
  func getDetail(_ detailLink: String) async throws -> Detail {
    let component = URLComponents(string: detailLink)!
    let request = URLRequest(url:component.url!)
    let (data, responses) = try await URLSession.shared.data(for: request)
    guard (responses as? HTTPURLResponse)?.statusCode == 200 else {
      fatalError("Error Can't Fetching Data")
    }
    let decoder = JSONDecoder()
    let result = try decoder.decode(Detail.self, from: data)
    return result
  }
  
  func getMove(_ detailLink: String) async throws -> [Move] {
    let component = URLComponents(string: detailLink)!
    let request = URLRequest(url:component.url!)
    let (data, responses) = try await URLSession.shared.data(for: request)
    guard (responses as? HTTPURLResponse)?.statusCode == 200 else {
      fatalError("Error Can't Fetching Data")
    }
    let decoder = JSONDecoder()
    let result = try decoder.decode(Detail.self, from: data)
    return result.moves
  }
}
