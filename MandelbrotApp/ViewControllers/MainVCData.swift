//
//  MainVCData.swift
//  MandelbrotApp
//
//  Created by gary on 14/09/2018.
//  Copyright © 2018 Gary Kerr. All rights reserved.
//

import Foundation
import UIKit

final class MainVCData {
    let width: Int
    let height: Int

    let colourMaps = ColourMapFactory.maps
    var colourMap: ColourMapProtocol
    var mandelbrotSet: MandelbrotSet!
    var config: MandelbrotSetConfig


    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        self.colourMap = colourMaps[1]
        self.config = MandelbrotSetConfig(imageWidth: width, imageHeight: height)
    }


    func reset() {
        config = MandelbrotSetConfig(imageWidth: width, imageHeight: height)
    }


    func zoomIn(at point: CGPoint) {
        let centre = newCentre(from: point)
        config = config.zoomIn(centre: centre)
    }


    func makeImage(progress: Progress, completion: @escaping (UIImage) -> ()) {
        DispatchQueue.global().async {
            self.mandelbrotSet = MandelbrotSet(config: self.config, progress: progress)
            let image = self.mandelbrotSet!.image(with: self.colourMap)
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}


// MARK: - Private

private extension MainVCData {
    func newCentre(from point: CGPoint) -> ComplexNumber {
        let imageRect = Rectangle(xMin: 0, yMin: 0, xMax: config.imageWidth, yMax: config.imageHeight)
        let complexRect = Rectangle(config: config)
        let transform = Transformation(from: imageRect, to: complexRect)
        return transform.transform(point: point)
    }
}
