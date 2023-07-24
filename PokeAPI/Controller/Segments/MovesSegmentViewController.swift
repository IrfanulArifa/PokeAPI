//
//  MovesSegmentViewController.swift
//  PokeAPI
//
//  Created by Irfanul Arifa on 13/07/23.
//

import UIKit

var linkMoves = ""

class MovesSegmentViewController: UIViewController {
  let viewModel = ViewModel()
  
  @IBOutlet weak var movesTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    movesTableView.dataSource = self
    movesTableView.delegate = self
    movesTableView.register(UINib(nibName: "MovesTableViewCell", bundle: nil), forCellReuseIdentifier: "MovesCell")
  }
  
  func sendConfigurationToMoves(_ data: String){
    linkMoves = data
  }
  
  override func viewWillAppear(_ animated: Bool) {
    viewModel.loadDetail(linkMoves)
  }
  
}

extension MovesSegmentViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.aboutMoves.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "MovesCell", for: indexPath) as? MovesTableViewCell{
      let moves = viewModel.aboutMoves[indexPath.row]
      cell.moveValue.text = moves.move.name.capitalized
      return cell
    } else {
      return UITableViewCell()
    }
  }
}

extension MovesSegmentViewController: UITableViewDelegate {
  
}
