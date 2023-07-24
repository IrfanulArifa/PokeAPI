//
//  FavoriteViewController.swift
//  PokeAPI
//
//  Created by Irfanul Arifa on 17/07/23.
//

import UIKit
import CoreData

var isChange: Bool = false

class FavoriteViewController: UIViewController, UITableViewDelegate {
  let appDelegate = UIApplication.shared.delegate as? AppDelegate
  var viewModel = ViewModel()
  
  @IBOutlet weak var favoriteTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    favoriteTableView.dataSource = self
    favoriteTableView.delegate = self
    favoriteTableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoriteTableViewCell")
    viewModel.retrieve()
    favoriteTableView.reloadData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if isChange == true{
      viewModel.retrieve()
      favoriteTableView.reloadData()
      isChange = false
    }
  }
}

extension FavoriteViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.data.count
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let pokemonData = viewModel.data[indexPath.row]
    let deleteData = UIContextualAction(style: .destructive,
                                        title: "Delete") { [weak self] (action, view, completionHandler) in
      self?.viewModel.deleteData(pokemonData.name, indexPath: indexPath)
      self?.viewModel.favoritAction = { [weak self] in
        self?.viewModel.retrieve()
        self?.favoriteTableView.deleteRows(at: [indexPath], with: .left)
      }
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
          self?.viewModel.updateData(name: pokemonData.name, with: newData)
          self?.viewModel.retrieve()
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
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell", for: indexPath) as? FavoriteTableViewCell else { return UITableViewCell() }
    let pokemonData = viewModel.data[indexPath.row]
    cell.pokemonImage.image = pokemonData.image.imageFromBase64
    cell.pokemonName.text = pokemonData.name
    cell.pokemonId.text = "#"+String(pokemonData.id)
    return cell
  }
}
