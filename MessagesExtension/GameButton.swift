//
//  GameButton.swift
//  MatchUp
//
//  Created by Drew Lanning on 11/5/16.
//  Copyright © 2016 Drew Lanning. All rights reserved.
//

import UIKit

@IBDesignable class GameButton: DesignableButton {

  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.backgroundColor = UIColor(red:1.00, green:0.64, blue:0.02, alpha:1.0)
    self.setTitleColor(.black, for: .normal)
    self.layer.borderWidth = 1.0
    self.layer.borderColor = UIColor.black.cgColor
    
  }

}
