//
//  ViewController.swift
//  PokeAPI
//
//  Created by Irfanul Arifa on 12/07/23.
//

import UIKit

// Comment

class ViewController: UIViewController, UICollectionViewDataSource{
  private var pokemonData: [Result] = []
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return pokemonData.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCollectionViewCell", for: indexPath) as? PokemonCollectionViewCell else {
      return UICollectionViewCell()
    }
    let pokemon = pokemonData[indexPath.item]
    cell.pokemonName.text = pokemon.name.capitalized
    let imageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(indexPath.item+1).png"
    cell.pokemonPict.sd_setImage(with: URL(string: imageUrl))
    cell.pokemonID.text = "#" + String(indexPath.item+1)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let selectedObject = pokemonData[indexPath.row]
    if collectionView.cellForItem(at: indexPath) is PokemonCollectionViewCell{
      let storyboard = UIStoryboard(name: "DetailView", bundle: nil)
      guard let newMove = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
      newMove.pokemon = selectedObject
      navigationController?.pushViewController(newMove, animated: true)
      navigationItem.title = ""
      
      let storyboardParsing = UIStoryboard(name: "DetailView", bundle: nil)
      guard let about = storyboardParsing.instantiateViewController(withIdentifier: "AboutSegmentViewController") as? AboutSegmentViewController else { return }
      guard let baseStats = storyboardParsing.instantiateViewController(withIdentifier: "BaseStatsViewController") as? BaseStatsViewController else { return }
      guard let moves = storyboardParsing.instantiateViewController(withIdentifier: "MovesSegmentViewController") as? MovesSegmentViewController else { return }
      about.sendConfigurationToAbout(selectedObject.url)
      baseStats.sendConfigurationToBaseStats(selectedObject.url)
      moves.sendConfigurationToMoves(selectedObject.url)
    }
  }
  
  @IBOutlet weak var pokemonCollectionView: UICollectionView!

  override func viewDidLoad() {
    super.viewDidLoad()
    pokemonCollectionView.dataSource = self
    pokemonCollectionView.delegate = self
    pokemonCollectionView.register(UINib(nibName: "PokemonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PokemonCollectionViewCell")
  }
  override func viewWillAppear(_ animated: Bool) {
    Task{ await getPokemon() }
  }
  
  func getPokemon() async {
    let network = NetworkServices()
    do {
      pokemonData = try await network.getPokemon()
      pokemonCollectionView.reloadData()
    } catch {
      print("Error")
    }
  }
}

extension UIViewController: UICollectionViewDelegateFlowLayout{
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 150, height: 150)
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 30
  }
}
