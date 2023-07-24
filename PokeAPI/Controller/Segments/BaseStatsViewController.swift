//
//  BaseStatsViewController.swift
//  PokeAPI
//
//  Created by Irfanul Arifa on 13/07/23.
//

import UIKit

var linkBase = ""

class BaseStatsViewController: UIViewController {
  
  let viewModel = ViewModel()
  
  @IBOutlet weak var hpStat: UILabel!
  @IBOutlet weak var atkStat: UILabel!
  @IBOutlet weak var defStat: UILabel!
  @IBOutlet weak var specialAtkStat: UILabel!
  @IBOutlet weak var specialDefStat: UILabel!
  @IBOutlet weak var speedStat: UILabel!
  @IBOutlet weak var hpProgressView: UIProgressView!
  @IBOutlet weak var atkProgressView: UIProgressView!
  @IBOutlet weak var defProgressView: UIProgressView!
  @IBOutlet weak var specialAtkProgressView: UIProgressView!
  @IBOutlet weak var specialDefProgressView: UIProgressView!
  @IBOutlet weak var speedProgressView: UIProgressView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func sendConfigurationToBaseStats(_ data:String){
    linkBase = data
  }
  
  override func viewWillAppear(_ animated: Bool) {
    viewModel.loadBase(linkBase)
    viewModel.baseOption = {
      DispatchQueue.main.async {
        guard let unwrappedBase = self.viewModel.baseDetail else { return }
        self.hpStat.text = String(unwrappedBase.stats[0].base_stat)
        self.atkStat.text = String(unwrappedBase.stats[1].base_stat)
        self.defStat.text = String(unwrappedBase.stats[2].base_stat)
        self.specialAtkStat.text = String(unwrappedBase.stats[3].base_stat)
        self.specialDefStat.text = String(unwrappedBase.stats[4].base_stat)
        self.speedStat.text = String(unwrappedBase.stats[5].base_stat)
        
        let hpValue = unwrappedBase.stats[0].base_stat
        let atkValue = unwrappedBase.stats[1].base_stat
        let defValue = unwrappedBase.stats[2].base_stat
        let specialAtkValue = unwrappedBase.stats[3].base_stat
        let specialDefValue = unwrappedBase.stats[4].base_stat
        let speedValue = unwrappedBase.stats[5].base_stat
        
        self.viewModel.progressColor(view: self.hpProgressView, value: hpValue)
        self.viewModel.progressColor(view: self.atkProgressView, value: atkValue)
        self.viewModel.progressColor(view: self.defProgressView, value: defValue)
        self.viewModel.progressColor(view: self.specialAtkProgressView, value: specialAtkValue)
        self.viewModel.progressColor(view: self.specialDefProgressView, value: specialDefValue)
        self.viewModel.progressColor(view: self.speedProgressView, value: speedValue)
        
        
        self.hpProgressView.progress = Float(unwrappedBase.stats[0].base_stat)/100
        self.atkProgressView.progress = Float(unwrappedBase.stats[1].base_stat)/100
        self.defProgressView.progress = Float(unwrappedBase.stats[2].base_stat)/100
        self.specialAtkProgressView.progress = Float(unwrappedBase.stats[3].base_stat)/100
        self.specialDefProgressView.progress = Float(unwrappedBase.stats[4].base_stat)/100
        self.speedProgressView.progress = Float(unwrappedBase.stats[5].base_stat)/100
      }
    }
  }
}
