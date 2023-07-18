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

extension UIImage{
  var base64: String?{
    self.pngData()?.base64EncodedString()
  }
}

extension String{
  var imageFromBase64: UIImage?{
    guard let imageData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
      return nil
    }
    return UIImage(data: imageData)
  }
}
