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
  let winningScore = 15
  
  var score: Int
  var totalScore: Int = 0
  private var _opponentScore: Int
  var opponentScore: Int {
    get {
      return _opponentScore
    }
    set {
      _opponentScore = newValue
    }
  }
  var totalRolls: Int
  var currentHand: Int
  var currentDice: [D6]
  
  var shipIndex: Int?
  var captainIndex: Int?
  var crewIndex: Int?
  
  struct query {
    var sccScore: Int
    var sccTotalScore: Int
    var sccOppScore: Int
    var sccWinner: Bool
  }
  
  init() {
    self.score = 0
    self._opponentScore = 0
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
    
    for (index, die) in currentDice.enumerated() {
      if shipIndex == nil && die.value == 6 {
        shipIndex = index
      }
      if captainIndex == nil && die.value == 5 {
        captainIndex = index
      }
      if crewIndex == nil && die.value == 4 {
        crewIndex = index
      }
    }
    
    guard shipIndex != nil, captainIndex != nil, crewIndex != nil else {
      self.score = 0
      return
    }
    
    self.score = scoreCargo()
    self.totalScore = self.totalScore + self.score
  }
  
  func gameIsOver(totalScore score: Int) -> Bool {
    return score > winningScore
  }
    
  func shipCapCrewHeld() -> Bool {
    return shipIndex != nil && captainIndex != nil && crewIndex != nil
  }
  
  func hasFoundShip() -> Bool {
    return shipIndex != nil
  }
  
  func hasFoundCaptain() -> Bool {
    return captainIndex != nil
  }
  
  func hasFoundCrew() -> Bool {
    return crewIndex != nil
  }
  
  func hold(die: D6, atIndex index: Int) -> Bool {
    if canHoldResult(forDie: die, atIndex: index) {
      die.freeze()
      return true
    }
    return false
  }
  
  func canUnhold(die: D6) -> Bool {
    if die.locked == false {
      die.unFreeze()
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
        die.lockDie()
        return true
      }
      return false
    case 5:
      if shipIndex != nil, captainIndex == nil {
        captainIndex = index
        die.lockDie()
        return true
      }
      return false
    case 4:
      if shipIndex != nil && captainIndex != nil && crewIndex == nil {
        crewIndex = index
        die.lockDie()
        return true
      }
      return false
    default:
      return false
    }
    
  }
  
}
