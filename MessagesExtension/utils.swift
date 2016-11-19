//
//  utils.swift
//  MatchUp
//
//  Created by Drew Lanning on 10/27/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import AVFoundation

let btnAnimTiming: Double = 0.05

enum SoundFileName: String {
  case button_click = "button_click.mp3"
  case die_click = "die_click.mp3"
  case lost_round = "lost_round_moan.wav"
  case won_round = "won_round_cheer.wav"
  case lost_game = "lost_game_moan.mp3"
  case won_game = "won_game_cheer.mp3"
  case dice = "dice1.mp3"
}

class Utils {
  
  static func delay(_ delay: Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(
      deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
      execute: closure
    )
  }
  
  static func animateButton(_ view: UIView, withTiming timing: Double, completionClosure: (() -> ())?) {
    UIView.animate(withDuration: timing  ,
                   animations: {
                    view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
      },
                   completion: { finish in
                    UIView.animate(withDuration: timing/2){
                      view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    }
                    if let closure = completionClosure {
                      closure()
                    }
    })
  }
  
}

@IBDesignable class DesignableView: UIView {}
extension UIView {
  @IBInspectable var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
      layer.masksToBounds = newValue > 0
    }
  }
}

@IBDesignable class DesignableButton: UIButton {}


