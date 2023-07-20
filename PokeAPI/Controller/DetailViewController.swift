//
//  DetailViewController.swift
//  PokeAPI
//
//  Created by Irfanul Arifa on 12/07/23.
//

import UIKit
import SDWebImage
import CoreData

class DetailViewController: UIViewController {
  var pokemon: Result?
  var abilityPokemon: Detail?
  var crud = CrudSystem()
  private var isExists = false
  
  @IBOutlet weak var loveButton: UIBarButtonItem!
  @IBOutlet weak var pictSegmentedControl: UISegmentedControl!
  @IBOutlet weak var pokemonName: UILabel!
  @IBOutlet weak var pokemonID: UILabel!
  @IBOutlet weak var pokemonPict: UIImageView!
  @IBOutlet weak var segmentDetailOutlet: UISegmentedControl!
  @IBOutlet weak var aboutSegmentView: UIView!
  @IBOutlet weak var baseStatsSegmentView: UIView!
  @IBOutlet weak var movesSegmentView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    pokemonName.text = pokemon?.name
    aboutSegmentView.isHidden = false
    baseStatsSegmentView.isHidden = true
    movesSegmentView.isHidden = true
    
    self.loveButton.isEnabled = false
    crud.CheckData(pokemonName.text!) { [weak self] isExists in
      self?.isExists = isExists
      let iconName = isExists ? "heart.fill" : "heart"
      self?.loveButton.image = UIImage(systemName: iconName)
      self?.loveButton.isEnabled = true
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    Task{ await getDetail()
      guard let unwrappedAbilityPokemon = abilityPokemon else { return }
      pokemonName.text = unwrappedAbilityPokemon.species.name.capitalized
      pokemonID.text = "#"+String(unwrappedAbilityPokemon.id)
      pokemonPict.sd_setImage(with: URL(string: unwrappedAbilityPokemon.sprites.other.officialArtwork.front_default))
    }
    
  }
  
  func getDetail() async {
    let network = NetworkServices()
    do {
      abilityPokemon = try await network.getDetail(pokemon!.url)
    } catch {
      print("Error Data")
    }
  }
  
  @IBAction func pictSegmentedAction(_ sender: UISegmentedControl) {
    guard let unwrappedAbilityPokemon = abilityPokemon else { return }
    switch pictSegmentedControl.selectedSegmentIndex
    {
    case 0:
      pokemonPict.sd_setImage(with: URL(string: unwrappedAbilityPokemon.sprites.other.officialArtwork.front_default))
    case 1:
      pokemonPict.sd_setImage(with: URL(string: unwrappedAbilityPokemon.sprites.other.officialArtwork.front_shiny))
    default:
      break
    }
  }
  
  @IBAction func detailSegmentAction(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex{
    case 0:
      aboutSegmentView.isHidden = false
      baseStatsSegmentView.isHidden = true
      movesSegmentView.isHidden = true
    case 1:
      aboutSegmentView.isHidden = true
      baseStatsSegmentView.isHidden = false
      movesSegmentView.isHidden = true
    case 2:
      aboutSegmentView.isHidden = true
      baseStatsSegmentView.isHidden = true
      movesSegmentView.isHidden = false
    default:
      break
    }
  }
  
  @IBAction func loveButtonClicked(_ sender: Any) {
    guard let savingData = abilityPokemon else { return }
    guard let savingName = pokemon?.name else { return }
    guard let image = pokemonPict.image else { return }
    if isExists {
      crud.DeleteData(savingName)
      self.loveButton.image = UIImage(systemName: "heart")
    } else {
      crud.Create(savingData.id, image.base64 ?? "", savingName)
      self.loveButton.image = UIImage(systemName: "heart.fill")
    }
    isChange = true
  }
}
