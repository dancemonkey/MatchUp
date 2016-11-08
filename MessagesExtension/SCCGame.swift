//
//  SCCGame.swift
//  MatchUp
//
//  Created by Drew Lanning on 11/4/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import Foundation

class SCCGame {
  
  let maxRolls = 3
  let maxHand = 5
  
  var score: Int
  var totalRolls: Int
  var currentHand: Int
  var currentDice: [D6]
  
  var shipIndex: Int?
  var captainIndex: Int?
  var crewIndex: Int?
  
  init() {
    self.score = 0
    self.totalRolls = 0
    self.currentHand = maxHand
    self.currentDice = [D6]()
    for _ in 0..<currentHand {
      let die = D6()
      currentDice.append(die)
    }
  }
  
  func roll() -> [Int]? {
    guard roundIsOver() == false else {
      endRound()
      return nil
    }
    
    totalRolls = totalRolls + 1
    var results = [Int]()
    for die in currentDice {
      if die.frozen == false {
        results.append(die.roll())
      } else {
        results.append(die.value)
      }
    }
    return results
    
  }
  
  private func scoreCargo() -> Int {
    
    var cargo = [Die]()
    for (index, die) in currentDice.enumerated() {
      if index != shipIndex && index != captainIndex && index != crewIndex {
        cargo.append(die)
      }
    }
    
    return cargo.reduce(0, { (value, die) -> Int in
      return value + die.value
    })
    
  }
  
  func roundIsOver() -> Bool {
    return totalRolls >= maxRolls
  }
  
  func endRound() {
    guard shipIndex != nil, captainIndex != nil, crewIndex != nil else {
      self.score = 0
      return
    }
    
    self.score = scoreCargo()
  }
  
  func shipCapCrewHeld() -> Bool {
    return shipIndex != nil && captainIndex != nil && crewIndex != nil
  }
  
  func hold(die: D6, atIndex index: Int) -> Bool {
    if canHoldResult(forDie: die, atIndex: index) {
      die.freeze()
      return true
    }
    return false
  }
  
  private func canHoldResult(forDie die: D6, atIndex index: Int) -> Bool {
    
    if shipCapCrewHeld() == true && roundIsOver() == false {
      return true
    }
    
    switch die.value {
    case 6:
      if shipCapCrewHeld() == false, shipIndex == nil {
        shipIndex = index
        return true
      }
      return false
    case 5:
      if shipIndex != nil {
        captainIndex = index
        return true
      }
      return false
    case 4:
      if shipIndex != nil && captainIndex != nil {
        crewIndex = index
        return true
      }
      return false
    default:
      return false
    }
    
  }
  
}
