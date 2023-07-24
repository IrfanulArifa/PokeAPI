//
//  ViewModel.swift
//  PokeAPI
//
//  Created by Irfanul Arifa on 24/07/23.
//

import Foundation
import CoreData
import UIKit

class ViewModel {
  
  let appDelegate = UIApplication.shared.delegate as? AppDelegate
  let storyboardParsing = UIStoryboard(name: "DetailView", bundle: nil)
  var pokemonData: [Result] = []
  var aboutMoves: [Move] = []
  var baseDetail: Detail?
  var data : [FavPokemon] = []
  
  var reloadAction: (() -> Void)?
  var baseOption: (() -> Void)?
  var favoritAction: (() -> Void)?
  
  
  func getPokemonData() async throws -> [Result]{
    let component = URLComponents(string: "https://pokeapi.co/api/v2/pokemon")!
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
  
  func getMoveData(_ detailLink: String) async throws -> [Move] {
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
  
  func updateData( name: String, with newName: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Pokemon")
    fetchRequest.predicate = NSPredicate(format: "name = %@", name)
    do {
      let fetchedResults = try managedContext.fetch(fetchRequest)
      
      if let pokemon = fetchedResults.first {
        pokemon.setValue(newName, forKey: "name")
        
        do {
          try managedContext.save()
          print("Data updated successfully")
        } catch{
          print("Failed to update data: (error), (error.userInfo)", error)
        }
      }
    } catch {
      print("Fetch error: (error), (error.userInfo)", error)
    }
    isChange = true
  }
  
  func moveToAbout(_ selected: String) {
    guard let about = storyboardParsing.instantiateViewController(withIdentifier: "AboutSegmentViewController") as? AboutSegmentViewController else { return }
    return about.sendConfigurationToAbout(selected)
  }
  
  func moveToBase(_ selected: String) {
    guard let baseStats = storyboardParsing.instantiateViewController(withIdentifier: "BaseStatsViewController") as? BaseStatsViewController else { return }
    return baseStats.sendConfigurationToBaseStats(selected)
  }
  
  func moveToMoves(_ selected: String) {
    guard let moves = storyboardParsing.instantiateViewController(withIdentifier: "MovesSegmentViewController") as? MovesSegmentViewController else { return }
    return moves.sendConfigurationToMoves(selected)
  }
  
  func loadPokemon() {
    Task{ await getPokemon() }
  }
  
  func loadDetail(_ url: String) {
    Task{ await getMove(url) }
  }
  
  func loadBase(_ url: String) {
    Task { await getBaseDetail(url)
      baseOption?()
    }
  }
  
  func getMove(_ url: String) async {
    do {
      aboutMoves = try await getMoveData(url)
      reloadAction?()
    } catch {
      print("Error Data")
    }
  }
  
  func getPokemon() async {
    var data : [Result] = []
    do {
      data = try await getPokemonData()
      pokemonData.append(contentsOf: data)
      reloadAction?()
    } catch {
      print("Error")
    }
  }
  
  func getBaseDetail(_ url: String) async {
    do {
      baseDetail = try await getDetail(url)
    } catch {
      print("Error Data")
    }
  }
  
  func imageToView(_ index: Int) -> String {
    let imageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(index).png"
    return imageUrl
  }
  
  func progressColor(view:UIProgressView, value: Int){
    if value > 100 {
      return view.progressTintColor = .green
    } else if value > 50{
      return view.progressTintColor = .blue
    } else {
      return view.progressTintColor = .red
    }
  }
  
  func retrieve(){
    var pokemons = [FavPokemon]()
    let manageContext = appDelegate?.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pokemon")
    do {
      let result = try manageContext?.fetch(fetchRequest) as! [NSManagedObject]
      result.forEach { poke in
        guard let pokeData = poke as? Pokemon else { return }
        let favPokemon = FavPokemon(
          id: Int(pokeData.id),
          image: pokeData.image ?? "",
          name: pokeData.name ?? "")
        
        pokemons.append(favPokemon)
      }
      data = pokemons
    } catch let error {
      print("Tidak Bisa Menampilkan Data, ", error)
    }
  }
  
  func deleteData(_ name: String, indexPath: IndexPath) {
    guard let appDelegeate = UIApplication.shared.delegate as? AppDelegate else { return }
    
    let managedContext = appDelegeate.persistentContainer.viewContext
    
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Pokemon")
    fetchRequest.predicate = NSPredicate(format: "name = %@", name)
    
    do {
      let result = try managedContext.fetch(fetchRequest)
      
      for index in 0..<result.count {
        let dataToDelete = result[index] as! NSManagedObject
        managedContext.delete(dataToDelete)
        print("Delete Data: ",dataToDelete)
        try managedContext.save()
        favoritAction?()
      }
    } catch let err {
      print("Unable to update data: ",err)
    }
    isChange = true
  }
}
