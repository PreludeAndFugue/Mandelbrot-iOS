//
//  MandelbrotSet.swift
//  Mandelbrot
//
//  Created by gary on 29/04/2017.
//  Copyright © 2017 Gary Kerr. All rights reserved.
//

// Notes for improvements
//
// https://en.wikibooks.org/wiki/Fractals/Iterations_in_the_complex_plane/Mandelbrot_set#Real_Escape_Time
// http://www.mrob.com/pub/muency/speedimprovements.html
//

import Foundation
import UIKit

struct MandelbrotSet {

    let config: MandelbrotSetConfig

    private var grid: [MandelbrotSetPoint] = []
    private var imageSize: (width: Int, height: Int)


    init(config: MandelbrotSetConfig, progress: Progress) {
        self.config = config
        let ys = Array(stride(from: config.yMin, to: config.yMax, by: config.dy))
        let xs = Array(stride(from: config.xMin, to: config.xMax, by: config.dx))
        imageSize = (xs.count, ys.count)

        let countFraction = Double(100) / Double(imageSize.height)

        for (i, y) in ys.enumerated() {
            for x in xs {
                let z = ComplexNumber(x: x, y: y)
                grid.append(MandelbrotSetPoint(point: z, test: isInSetFast(point: z)))
            }

            let completedUnitCount = Int64(Double(i)*countFraction)
            progress.completedUnitCount = completedUnitCount
        }
    }


    func image(with colourMap: ColourMapProtocol) -> UIImage {
        let pixels = grid.map({ colourMap.pixel(from: $0.test )})
//        let sampledPixels = resample(pixels: pixels)
        return UIImage.from(pixels: pixels, width: imageSize.width, height: imageSize.height)
    }


    func gridIterations(config: MandelbrotSetConfig) -> Int {
        var total = 0
        for point in grid {
            switch point.test {
            case .inSet:
                total += config.iterations
            case .notInSet(let iterations, _):
                total += iterations
            }
        }
        return total
    }
}


// MARK: - Private

private extension MandelbrotSet {
    func isInSet(point: ComplexNumber) -> MandelbrotSetPoint.Test {
        var z = point
        for i in 0 ..< config.iterations {
            if z.modulus() >= 4 {
                return .notInSet(iterations: i, finalPoint: z)
            }
            z = z*z + point
        }
        return .inSet
    }


    // Maybe this could be faster because not using operator overloading on the ComplexNumber struct
    func isInSetFast(point: ComplexNumber) -> MandelbrotSetPoint.Test {
        let (u, v) = (point.x, point.y)
        var (x, y) = (point.x, point.y)
        for i in 0 ..< config.iterations {
            if x*x + y*y >= 4 {
                return .notInSet(iterations: i, finalPoint: ComplexNumber(x: x, y: y))
            }
            (x, y) = (x*x - y*y + u, 2*x*y + v)
        }
        return .inSet
    }
}


// MARK: - Private: average pixel colour

private extension MandelbrotSet {
    func resample(pixels: [Pixel]) -> [Pixel] {
        var newPixels: [Pixel] = []
        let width = config.imageWidth
        let maxValue = config.imageWidth * config.imageHeight
        for (i, pixel) in pixels.enumerated() {
            if pixel.isBlack {
                newPixels.append(pixel)
                continue
            }
            var neighbours = getNeighbours(index: i, pixels: pixels, width: width, maxValue: maxValue)
            neighbours.append(pixel)
            let averagePixel = getAverage(pixels: neighbours)
            newPixels.append(averagePixel)
        }
        return newPixels
    }


    func getNeighbours(index: Int, pixels: [Pixel], width: Int, maxValue: Int) -> [Pixel] {
        var neighbours: [Pixel] = []
        // Left
        let left = index - 1
        if index % width != 0 {
            neighbours.append(pixels[left])
        }
        // Right
        let right = index + 1
        if right % width != 0 && right < maxValue {
            neighbours.append(pixels[right])
        }
        // Top
        let top = index - width
        if top >= 0 {
            neighbours.append(pixels[top])
        }
        // Bottom
        let bottom = index + width
        if bottom < maxValue {
            neighbours.append(pixels[bottom])
        }
        return neighbours
    }


    func getAverage(pixels: [Pixel]) -> Pixel {
        var r = 0
        var g = 0
        var b = 0
        for pixel in pixels {
            r += Int(pixel.r)
            g += Int(pixel.g)
            b += Int(pixel.b)
        }
        let count = Double(pixels.count)
        let averageR = UInt8(Double(r)/count)
        let averageG = UInt8(Double(g)/count)
        let averageB = UInt8(Double(b)/count)
        return Pixel(r: averageR, g: averageG, b: averageB)
    }
}
