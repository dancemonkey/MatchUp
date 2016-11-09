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
  
  internal var _numSides: Int
  var numSides: Int {
    return _numSides
  }
  
  internal var _faceColor: UIColor
  var faceColor: UIColor {
    return _faceColor
  }
  
  internal var _value: Int
  var value: Int {
    return _value
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
    self._value = 1
  }
  
  func roll(withModifier modifier: Int = 0) -> Int {
    self._value = GKRandomDistribution.init(forDieWithSideCount: self._numSides).nextInt() + modifier
    return self._value
  }
  
  func freeze() {
    self._frozen = true
  }
  
  func unFreeze() {
    self._frozen = false
  }
  
}

class D6: Die {
  init() {
    super.init(sides: 6)
    self._value = 3
  }
}
