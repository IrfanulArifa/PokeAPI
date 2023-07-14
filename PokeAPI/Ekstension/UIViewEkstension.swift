//
//  UIViewEkstension.swift
//  PokeAPI
//
//  Created by Irfanul Arifa on 12/07/23.
//

import Foundation
import UIKit

extension UIView{
  @IBInspectable var cornerRadius: CGFloat{
    get { return self.cornerRadius }
    set { self.layer.cornerRadius = newValue}
  }
}
