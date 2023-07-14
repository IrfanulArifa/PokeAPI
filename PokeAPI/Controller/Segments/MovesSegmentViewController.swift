//
//  MovesSegmentViewController.swift
//  PokeAPI
//
//  Created by Irfanul Arifa on 13/07/23.
//

import UIKit

var linkMoves = ""

class MovesSegmentViewController: UIViewController, UITableViewDataSource {
  
  private var aboutMoves: [Move] = []
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return aboutMoves.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "MovesCell", for: indexPath) as? MovesTableViewCell{
      let moves = aboutMoves[indexPath.row]
      cell.moveValue.text = moves.move.name.capitalized
      return cell
    } else {
      return UITableViewCell()
    }
  }
  
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
    Task{ await getMove()
    }
  }
  
  func getMove() async {
    let network = NetworkServices()
    do {
      aboutMoves = try await network.getMove(linkMoves)
      movesTableView.reloadData()
    } catch {
      print("Error Data")
    }
  }
}

extension UIViewController: UITableViewDelegate{
  
}
