//
//  BaseBtn.swift
//  Famous Quote Quiz
//
//  Created by admin on 12/8/15.
//  Copyright © 2015 Oraganization. All rights reserved.
//

import Foundation
import UIKit

class BaseBtn : UIButton {
    
    override func awakeFromNib() {
  
        self.layer.cornerRadius = 8
        
        self.clipsToBounds = true
      
    }
}