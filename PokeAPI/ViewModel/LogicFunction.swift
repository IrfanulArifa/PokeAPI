//
//  LogicFunction.swift
//  PokeAPI
//
//  Created by Irfanul Arifa on 20/07/23.
//

import UIKit

class LogicFunction {
  func ProgressColor(view:UIProgressView, value: Int){
    if value > 100 {
      return view.progressTintColor = .green
    } else if value > 50{
      return view.progressTintColor = .blue
    } else {
      return view.progressTintColor = .red
    }
  }
}
