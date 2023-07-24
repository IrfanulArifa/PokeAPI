//
//  DetailViewController.swift
//  PokeAPI
//
//  Created by Irfanul Arifa on 12/07/23.
//

import UIKit
import SDWebImage
import CoreData

var id = ""

class DetailViewController: UIViewController {
  var pokemon: Result?
  var abilityPokemon: Detail?
  var data : [FavPokemon] = []
  
  @IBOutlet weak var loveButton: UIBarButtonItem!
  @IBOutlet weak var pictSegmentedControl: UISegmentedControl!
  @IBOutlet weak var pokemonName: UILabel!
  @IBOutlet weak var pokemonID: UILabel!
  @IBOutlet weak var pokemonPict: UIImageView!
  @IBOutlet weak var segmentDetailOutlet: UISegmentedControl!
  @IBOutlet weak var aboutSegmentView: UIView!
  @IBOutlet weak var baseStatsSegmentView: UIView!
  @IBOutlet weak var movesSegmentView: UIView!
  
  private var isExists = false
  
  func sendDataToDetail(_ data: String){
    id = data
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    pokemonName.text = pokemon?.name
    aboutSegmentView.isHidden = false
    baseStatsSegmentView.isHidden = true
    movesSegmentView.isHidden = true
    self.loveButton.isEnabled = false
    
    checkData(pokemonName.text!) { [weak self] isExists in
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
    let network = ViewModel()
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
      deleteData(savingName)
      self.loveButton.image = UIImage(systemName: "heart")
      self.isExists = false
    } else {
      create(savingData.id, image.base64 ?? "", savingName)
      self.loveButton.image = UIImage(systemName: "heart.fill")
      self.isExists = true
    }
    isChange = true
  }
  
  private func checkData(_ name: String, completion: @escaping (Bool) -> Void) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let manageContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pokemon")
    fetchRequest.predicate = NSPredicate(format: "name = %@", name)
    
    do {
      let result = try manageContext.fetch(fetchRequest)
      let isExists = result.count > 0
      completion(isExists)
      print(isExists)
    } catch {
      print(isExists)
    }
  }
  
  private func create(_ id: Int, _ image: String, _ name: String){
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
  
  private func deleteData(_ name: String) {
    
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
        retrieve()
      }
    } catch let err {
      print("Unable to update data: ",err)
    }
    isChange = true
  }
  
  
  private func retrieve(){
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
  
}
