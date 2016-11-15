//
//  CoinFlipDelegate.swift
//  MatchUp
//
//  Created by Drew Lanning on 10/30/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import Messages
import Foundation

//protocol CoinFlipDelegate {
//  func composeMessage(forState state: CoinGameState, index: Int, pick: CoinFlipPick?, result: String?)
//  func nextGameState(from state: CoinGameState?) -> CoinGameState
//}

protocol ExpandViewDelegate {
  func expand(toPresentationStyle presentationStyle: MSMessagesAppPresentationStyle)
  func getPresentationStyle() -> MSMessagesAppPresentationStyle
}

protocol DiceGameDelegate {
  func composeMessage(forScore score: Int, totalScore: Int, oppScore: Int, withWinner: Bool)
}

