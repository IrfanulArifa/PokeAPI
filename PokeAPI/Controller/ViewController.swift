//
//  ViewController.swift
//  PokeAPI
//
//  Created by Irfanul Arifa on 12/07/23.
//

import UIKit

// Comment

class ViewController: UIViewController{
  let viewModel = ViewModel()
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let selectedObject = viewModel.pokemonData[indexPath.row]
    if collectionView.cellForItem(at: indexPath) is PokemonCollectionViewCell{
      let storyboard = UIStoryboard(name: "DetailView", bundle: nil)
      guard let newMove = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
      newMove.pokemon = selectedObject
      navigationController?.pushViewController(newMove, animated: true)
      navigationItem.title = ""
      viewModel.moveToAbout(selectedObject.url)
      viewModel.moveToBase(selectedObject.url)
      viewModel.moveToMoves(selectedObject.url)
    }
  }
  
  @IBOutlet weak var pokemonCollectionView: UICollectionView!

  override func viewDidLoad() {
    super.viewDidLoad()
    pokemonCollectionView.dataSource = self
    pokemonCollectionView.delegate = self
    pokemonCollectionView.register(UINib(nibName: "PokemonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PokemonCollectionViewCell")
    viewModel.loadPokemon()
    
    viewModel.reloadAction = { [weak self] in
      DispatchQueue.main.async {
        self?.pokemonCollectionView.reloadData()
      }
    }
  }
  override func viewWillAppear(_ animated: Bool) {
    viewModel.reloadAction = { [weak self] in
      DispatchQueue.main.async {
        self?.pokemonCollectionView.reloadData()
      }
    }
  }
  
}

extension ViewController: UICollectionViewDelegateFlowLayout{
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 150, height: 150)
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 30
  }
  
  public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if indexPath.item == viewModel.pokemonData.count-1 {
      viewModel.loadPokemon()
    }
  }
}

extension ViewController: UICollectionViewDataSource {
  
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.pokemonData.count
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCollectionViewCell", for: indexPath) as? PokemonCollectionViewCell else {
      return UICollectionViewCell()
    }
    let pokemon = viewModel.pokemonData[indexPath.item]
    cell.pokemonName.text = pokemon.name.capitalized
    let imageUrl = viewModel.imageToView(indexPath.item+1)
    cell.pokemonPict.sd_setImage(with: URL(string: imageUrl))
    cell.pokemonID.text = "#" + String(indexPath.item+1)
    return cell
  }
  
}
