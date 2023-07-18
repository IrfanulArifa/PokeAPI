//
//  FavoriteViewController.swift
//  PokeAPI
//
//  Created by Irfanul Arifa on 17/07/23.
//

import UIKit
import CoreData

var isChange: Bool = false

class FavoriteViewController: UIViewController, UITableViewDataSource {
  private var dataPokemon: FavPokemon?
  var data : [FavPokemon] = []
  let appDelegate = UIApplication.shared.delegate as? AppDelegate
  
  @IBOutlet weak var favoriteTableView: UITableView!
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell", for: indexPath) as? FavoriteTableViewCell else { return UITableViewCell() }
    let pokemonData = data[indexPath.row]
    cell.pokemonImage.image = pokemonData.image.imageFromBase64
    cell.pokemonName.text = pokemonData.name
    cell.pokemonId.text = "#"+String(pokemonData.id)
    return cell
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let pokemonData = data[indexPath.row]
    let deleteData = UIContextualAction(style: .destructive,
                                   title: "Delete") { [weak self] (action, view, completionHandler) in
      self?.deleteData(pokemonData.name, indexPath: indexPath)
      completionHandler(true)
    }
    deleteData.backgroundColor = .systemRed
    let updateData = UIContextualAction(style: .normal,
                                        title: "Edit") { [weak self] (action, view, completionHandler) in
      let alertController = UIAlertController(title: "Change Name", message: nil, preferredStyle: .alert)
      alertController.addTextField()
      let submit = UIAlertAction(title: "Change", style: .default) { (alert) in
        
        if let textField = alertController.textFields?.first {
          let newData = textField.text ?? "No Name"
          self?.updateData(name: pokemonData.name, with: newData)
          self?.retrieve()
          self?.favoriteTableView.reloadData()
        }
      }
      alertController.addAction(submit)
      self?.present(alertController, animated: true, completion: nil)
      
      completionHandler(true)
    }
    updateData.backgroundColor = .systemGreen
    
    let configuration = UISwipeActionsConfiguration(actions: [deleteData, updateData])
    isChange = true

    return configuration
  }
  
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    let selectedObject = data[indexPath.row]
//    if tableView.cellForRow(at: indexPath) is FavoriteTableViewCell {
//      let storyboard = UIStoryboard(name: "DetailView", bundle: nil)
//      guard let newMove = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
//      
//      newMove.sendDataToDetail(selectedObject.name)
//      navigationController?.pushViewController(newMove, animated: true)
//      navigationItem.title = ""
//    }
//  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    
    favoriteTableView.dataSource = self
    favoriteTableView.delegate = self
    
    favoriteTableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoriteTableViewCell")
    retrieve()
    favoriteTableView.reloadData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if isChange == true{
      retrieve()
      favoriteTableView.reloadData()
      isChange = false
    }
  }
  
  private func retrieve(){
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
        retrieve()
        favoriteTableView.deleteRows(at: [indexPath], with: .left)
      }
    } catch let err {
      print("Unable to update data: ",err)
    }
    isChange = true
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
}
