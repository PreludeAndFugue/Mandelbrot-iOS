//
//  File.swift
//  MandelbrotApp
//
//  Created by gary on 13/09/2018.
//  Copyright © 2018 Gary Kerr. All rights reserved.
//

import UIKit

extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red, green, blue, alpha)
    }


    var rgbaInt: (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        let (r, g, b, a) = rgba
        return (UInt8(255*r), UInt8(255*g), UInt8(255*b), UInt8(255*a))
    }


    var mandelbrotPixel: Pixel {
        let (r, g, b, _) = rgba
        return Pixel(r: UInt8(255*r), g: UInt8(255*g), b: UInt8(255*b))
    }
}
