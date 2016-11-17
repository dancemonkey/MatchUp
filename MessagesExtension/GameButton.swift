//
//  GameButton.swift
//  MatchUp
//
//  Created by Drew Lanning on 11/5/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit
import AVFoundation

@IBDesignable class GameButton: DesignableButton {
  
  var clickSound: AVAudioPlayer? = nil

  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.backgroundColor = UIColor(red:1.00, green:0.64, blue:0.02, alpha:1.0)
    self.setTitleColor(.black, for: .normal)
    self.layer.borderWidth = 1.0
    self.layer.borderColor = UIColor.black.cgColor
    
  }

}

extension GameButton {
  override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    
    let path = Bundle.main.path(forResource: SoundFileName.button_click.rawValue, ofType: nil)!
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
