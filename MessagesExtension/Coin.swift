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
  case heads, tails
}

class Coin: Die {
  
  init(faceColor: UIColor = .lightGray) {
    super.init(sides: 2, faceColor: faceColor, pipColor: .black)
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
      fatalError("this shouldn't happen")
    }
  }
  
}
