//
//  AboutSegmentViewController.swift
//  PokeAPI
//
//  Created by Irfanul Arifa on 13/07/23.
//

import UIKit

var linkPoke = ""

class AboutSegmentViewController: UIViewController {
  
  let viewModel = ViewModel()
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
    viewModel.loadBase(linkPoke)
    viewModel.baseOption = {
      DispatchQueue.main.async {
        guard let unwrappedAbout = self.viewModel.baseDetail else { return }
        let jumlah = unwrappedAbout.abilities.count
        var dataArray : [String] = []
        for i in 0..<jumlah{
          dataArray.append(unwrappedAbout.abilities[i].ability.name.capitalized)
        }
        let ability = dataArray.joined(separator: ", ")
        self.abilityValue.text = ability
        self.heightValue.text = String(unwrappedAbout.height)+"ft"
        self.weightValue.text = String(unwrappedAbout.weight)+"lbs"
        self.speciesValue.text = unwrappedAbout.species.name.capitalized
        let jumlahType = unwrappedAbout.types.count
        var typeArray : [String] = []
        for i in 0..<jumlahType{
          typeArray.append(unwrappedAbout.types[i].type.name.capitalized)
        }
        let type = typeArray.joined(separator: ", ")
        self.typesValue.text = type
      }
    }
  }
}
