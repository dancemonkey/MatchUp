//
//  Coin.swift
//  MatchUp
//
//  Created by Drew Lanning on 10/26/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import GameplayKit
import Foundation

enum FlipResult: String {
  case heads, tails, oops
}

class Coin {
  
  private var _numSides: Int
  var numSides: Int {
    return _numSides
  }
  
  private var _faceColor: UIColor
  var faceColor: UIColor {
    return _faceColor
  }
  
  private var _frozen = false
  var frozen: Bool {
    return _frozen
  }
  
  init(faceColor: UIColor = .lightGray) {
    self._numSides = 2
    self._faceColor = faceColor
  }
  
  func flip() -> FlipResult {
    switch GKRandomDistribution.init(forDieWithSideCount: self._numSides).nextInt() {
    case 1:
      print("heads")
      return .heads
    case 2:
      print("tails")
      return .tails
    default:
      return .oops
    }
  }
  
  func freeze() {
    self._frozen = !_frozen
  }
  
}
