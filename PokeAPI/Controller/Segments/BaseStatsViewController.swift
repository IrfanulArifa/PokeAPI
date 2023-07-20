//
//  BaseStatsViewController.swift
//  PokeAPI
//
//  Created by Irfanul Arifa on 13/07/23.
//

import UIKit

var linkBase = ""

class BaseStatsViewController: UIViewController {
  var baseDetail: Detail?
  let logic = LogicFunction()
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
    Task { await getDetail()
      guard let unwrappedBase = baseDetail else { return }
      hpStat.text = String(unwrappedBase.stats[0].base_stat)
      atkStat.text = String(unwrappedBase.stats[1].base_stat)
      defStat.text = String(unwrappedBase.stats[2].base_stat)
      specialAtkStat.text = String(unwrappedBase.stats[3].base_stat)
      specialDefStat.text = String(unwrappedBase.stats[4].base_stat)
      speedStat.text = String(unwrappedBase.stats[5].base_stat)
      
      let hpValue = unwrappedBase.stats[0].base_stat
      let atkValue = unwrappedBase.stats[1].base_stat
      let defValue = unwrappedBase.stats[2].base_stat
      let specialAtkValue = unwrappedBase.stats[3].base_stat
      let specialDefValue = unwrappedBase.stats[4].base_stat
      let speedValue = unwrappedBase.stats[5].base_stat
      
      logic.ProgressColor(view: hpProgressView, value: hpValue)
      logic.ProgressColor(view: atkProgressView, value: atkValue)
      logic.ProgressColor(view: defProgressView, value: defValue)
      logic.ProgressColor(view: specialAtkProgressView, value: specialAtkValue)
      logic.ProgressColor(view: specialDefProgressView, value: specialDefValue)
      logic.ProgressColor(view: speedProgressView, value: speedValue)
      
      
      hpProgressView.progress = Float(unwrappedBase.stats[0].base_stat)/100
      atkProgressView.progress = Float(unwrappedBase.stats[1].base_stat)/100
      defProgressView.progress = Float(unwrappedBase.stats[2].base_stat)/100
      specialAtkProgressView.progress = Float(unwrappedBase.stats[3].base_stat)/100
      specialDefProgressView.progress = Float(unwrappedBase.stats[4].base_stat)/100
      speedProgressView.progress = Float(unwrappedBase.stats[5].base_stat)/100
      
    }
  }
  
  func getDetail() async {
    let network = NetworkServices()
    do {
      baseDetail = try await network.getDetail(linkBase)
    } catch {
      print("Error Data")
    }
  }
  
}
