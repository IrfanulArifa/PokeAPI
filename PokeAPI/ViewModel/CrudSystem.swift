//
//  ViewModel.swift
//  PokeAPI
//
//  Created by Irfanul Arifa on 18/07/23.
//

import UIKit
import CoreData

class CrudSystem {
  
  var data : [FavPokemon] = []
  
  func CheckData(_ name: String, completion: @escaping (Bool) -> Void) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let manageContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pokemon")
    fetchRequest.predicate = NSPredicate(format: "name = %@", name)
    
    do {
      let result = try manageContext.fetch(fetchRequest)
      let isExists = result.count > 0
      completion(isExists)
    } catch {
      print("Error", error)
    }
  }
  
  func Create(_ id: Int, _ image: String, _ name: String){
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let manageContext = appDelegate.persistentContainer.viewContext
    let userEntity = NSEntityDescription.entity(forEntityName: "Pokemon", in: manageContext)
    let insert = NSManagedObject(entity: userEntity!, insertInto: manageContext)
    
    insert.setValue(id, forKey: "id")
    insert.setValue(image, forKey: "image")
    insert.setValue(name, forKey: "name")
    
    do {
      try manageContext.save()
    } catch let error {
      print("Penyimpanan data Error, ", error)
    }
  }
  
  func DeleteData(_ name: String) {
    
    guard let appDelegeate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedContext = appDelegeate.persistentContainer.viewContext
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Pokemon")
    fetchRequest.predicate = NSPredicate(format: "name = %@", name)
    
    do {
      let result = try managedContext.fetch(fetchRequest)
      
      for index in 0..<result.count {
        let dataToDelete = result[index] as! NSManagedObject
        managedContext.delete(dataToDelete)
        try managedContext.save()
        Retrieve()
      }
    } catch let err {
      print("Unable to update data: ",err)
    }
    isChange = true
  }
  
  func Retrieve(){
    var pokemons = [FavPokemon]()
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let manageContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pokemon")
    do {
      let result = try manageContext.fetch(fetchRequest) as! [NSManagedObject]
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
  
  func UpdateData( name: String, with newName: String) {
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
  }
}
