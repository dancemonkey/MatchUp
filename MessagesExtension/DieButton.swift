//
//  DieButton.swift
//  MatchUp
//
//  Created by Drew Lanning on 11/17/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import AVFoundation

class DieButton: UIButton {

  var clickSound: AVAudioPlayer? = nil
  
  override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    
    let path = Bundle.main.path(forResource: SoundFileName.die_click.rawValue, ofType: nil)!
    let url = URL(fileURLWithPath: path)
    do {
      let sound = try AVAudioPlayer(contentsOf: url)
      clickSound = sound
      clickSound?.prepareToPlay()
      clickSound?.play()
    } catch {
      print("error playing sound")
    }
  }

}
