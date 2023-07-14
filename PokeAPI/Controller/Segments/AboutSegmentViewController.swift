//
//  AboutSegmentViewController.swift
//  PokeAPI
//
//  Created by Irfanul Arifa on 13/07/23.
//

import UIKit

var linkPoke = ""

class AboutSegmentViewController: UIViewController {
  var aboutDetail: Detail?
  @IBOutlet weak var speciesValue: UILabel!
  @IBOutlet weak var abilityValue: UILabel!
  @IBOutlet weak var heightValue: UILabel!
  @IBOutlet weak var weightValue: UILabel!
  @IBOutlet weak var typesValue: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func sendConfigurationToAbout(_ data: String){
    linkPoke = data
  }
  
  override func viewWillAppear(_ animated: Bool) {
    Task{ await getDetail()
      guard let unwrappedAbout = aboutDetail else { return }
      let jumlah = unwrappedAbout.abilities.count
      var dataArray : [String] = []
      for i in 0..<jumlah{
        dataArray.append(unwrappedAbout.abilities[i].ability.name.capitalized)
      }
      let ability = dataArray.joined(separator: ", ")
      abilityValue.text = ability
      heightValue.text = String(unwrappedAbout.height)
      weightValue.text = String(unwrappedAbout.weight)
      speciesValue.text = unwrappedAbout.species.name.capitalized
      let jumlahType = unwrappedAbout.types.count
      var typeArray : [String] = []
      for i in 0..<jumlahType{
        typeArray.append(unwrappedAbout.types[i].type.name.capitalized)
      }
      let type = typeArray.joined(separator: ", ")
      typesValue.text = type
    }
  }
  
  func getDetail() async {
    let network = NetworkServices()
    do {
      aboutDetail = try await network.getDetail(linkPoke)
    } catch {
      print("Error Data")
    }
  }
  
  
}
