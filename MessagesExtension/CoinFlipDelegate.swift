//
//  CoinFlipDelegate.swift
//  MatchUp
//
//  Created by Drew Lanning on 10/30/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import Messages
import Foundation

protocol CoinFlipDelegate {
  func composeMessage(forState state: CoinGameState, index: Int, pick: CoinFlipPick?, result: String?)
  func nextGameState(from state: CoinGameState?) -> CoinGameState
}
