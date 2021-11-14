//
//  CustomSlider.swift
//  Inrix Hacks
//
//  Created by Gavin Ryder on 11/14/21.
//

import Foundation
import UIKit

@IBDesignable
   class CustomSlider: UISlider {
      /// custom slider track height
      @IBInspectable var trackHeight: CGFloat = 3

      override func trackRect(forBounds bounds: CGRect) -> CGRect {
          // Use properly calculated rect
          var newRect = super.trackRect(forBounds: bounds)
          newRect.size.height = trackHeight
          return newRect
      }
}
