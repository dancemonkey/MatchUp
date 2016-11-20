//
//  CoinFlipDelegate.swift
//  MatchUp
//
//  Created by Drew Lanning on 10/30/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import Messages
import Foundation

protocol ExpandViewDelegate {
  func expand(toPresentationStyle presentationStyle: MSMessagesAppPresentationStyle, tutorial: Bool)
  func getPresentationStyle() -> MSMessagesAppPresentationStyle
}

protocol DiceGameDelegate {
  //func composeMessage(forScore score: Int, totalScore: Int, oppScore: Int, withWinner: Bool)
  func composeMessage(fromGame game: SCCGame, hasWinner: Bool)
}

