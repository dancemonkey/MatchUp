//
//  Die.swift
//  MatchUp
//
//  Created by Drew Lanning on 10/26/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import GameplayKit
import Foundation

class Die {
  
  private var _numSides: Int
  var numSides: Int {
    return _numSides
  }
  
  private var _faceColor: UIColor
  var faceColor: UIColor {
    return _faceColor
  }
  
  private var _pipColor: UIColor
  var pipColor: UIColor {
    return _pipColor
  }
  
  private var _frozen = false
  var frozen: Bool {
    return _frozen
  }
  
  init(sides: Int, faceColor: UIColor = .white, pipColor: UIColor = .black) {
    self._numSides = sides
    self._faceColor = faceColor
    self._pipColor = pipColor
  }
  
  func roll(withModifier modifier: Int = 0) -> Int {
    return GKRandomDistribution.init(forDieWithSideCount: self._numSides).nextInt() + modifier
  }
  
  func freeze() {
    self._frozen = !_frozen
  }
  
}
