//
//  CGPoint+Extension.swift
//  MandelbrotApp
//
//  Created by gary on 13/09/2018.
//  Copyright © 2018 Gary Kerr. All rights reserved.
//

import UIKit

extension CGPoint {
    func invertY(height: Int) -> CGPoint {
        return CGPoint(x: self.x, y: CGFloat(height) - self.y)
    }
}
