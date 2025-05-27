//
//  UIViewController+ext.swift
//  RickandMorty
//
//  Created by Elnur Valizada on 20.05.25.
//

import UIKit


extension UIViewController {
  func applyGradientBackground() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = self.view.bounds
    gradientLayer.colors = [
      UIColor.bgStart.cgColor,
      UIColor.bgEnd.cgColor
    ]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.5)
    
    self.view.layer.insertSublayer(gradientLayer, at: 0)
  }
}


