//
//  NSImage+Extension.swift
//  Mandelbrot
//
//  Created by gary on 05/05/2017.
//  Copyright © 2017 Gary Kerr. All rights reserved.
//

import UIKit

import MandelbrotEngine

extension UIImage {

    // http://blog.human-friendly.com/drawing-images-from-pixel-data-in-swift
    static func from(pixels: [Pixel], width: Int, height: Int) -> UIImage {
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)

        let bitsPerComponent: Int = 8
        let bitsPerPixel: Int = 32

        assert(pixels.count == Int(width * height))

        // Need mutable copy
        var data = pixels
        let dataForProvider = NSData(bytes: &data, length: data.count * MemoryLayout<Pixel>.size)
        guard
            let providerRef = CGDataProvider(data: dataForProvider)
        else {
            fatalError("no cg data provider")
        }

        guard let image = CGImage(
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bitsPerPixel,
            bytesPerRow: width * MemoryLayout<Pixel>.size,
            space: rgbColorSpace,
            bitmapInfo: bitmapInfo,
            provider: providerRef,
            decode: nil,
            shouldInterpolate: true,
            intent: CGColorRenderingIntent.defaultIntent
        ) else { fatalError("Couldn't create CGImage") }

        return UIImage(cgImage: image)
    }


    static func from(mandelbrotSet: MandelbrotSet, colourMap: ColourMapProtocol) -> UIImage {
        let pixels = mandelbrotSet.grid.map({ colourMap.pixel(from: $0.test) })
        return from(
            pixels: pixels,
            width: mandelbrotSet.imageSize.width,
            height: mandelbrotSet.imageSize.height
        )
    }


//    func saveAsJpg(to url: URL) {
//        UIBitmap
//        let options: [NSBitmapImageRep.PropertyKey: Any] = [NSBitmapImageRep.PropertyKey.compressionFactor: 1.0]
//        guard
//            let imageData = tiffRepresentation,
//            let bitmapImageRep = NSBitmapImageRep(data: imageData),
//            let data = bitmapImageRep.representation(using: .jpeg, properties: options)
//        else { return }
//        try? data.write(to: url, options: [])
//    }
}
