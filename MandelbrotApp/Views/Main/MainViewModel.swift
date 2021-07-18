//
//  MainViewModel.swift
//  MandelbrotApp
//
//  Created by gary on 10/06/2021.
//  Copyright © 2021 Gary Kerr. All rights reserved.
//

import Combine
import CoreGraphics
import Foundation
import UIKit

import MandelbrotEngine

class MainViewModel: ObservableObject {
    struct Info {
        let maxIterations: Int
        let totalIterations: Int
        let time: TimeInterval
    }

    private var width = 0
    private var height = 0
    private let colourMaps = ColourMapFactory.maps
    private var config = MandelbrotSetConfig(imageWidth: 0, imageHeight: 0)
    private var mandelbrotSet: MandelbrotSet!

    var colourMap = ColourMapFactory.maps[0]

    @Published var loadingProgress = 0.0
    @Published var progress = Progress(totalUnitCount: 100)
    @Published var isInProgress = false
    @Published var isSelectingColourMap = false
    @Published var image = UIImage()

    @Published var info = Info(maxIterations: 0, totalIterations: 0, time: 0)


    func reset() {
        config = MandelbrotSetConfig(imageWidth: width, imageHeight: height)
        colourMap = colourMaps[0]
        generate()
    }


    func selectColourMap() {
        isSelectingColourMap.toggle()
    }


    func generate() {
        progress = Progress(totalUnitCount: 100)
        isInProgress = true
        DispatchQueue.global().async {
            self.mandelbrotSet = MandelbrotSet(
                config: self.config,
                progress: self.progress,
                timer: self.timerAction(dt:)
            )
            DispatchQueue.main.async {
                self.image = UIImage.from(mandelbrotSet: self.mandelbrotSet, colourMap: self.colourMap)
                self.isInProgress = false
            }
        }
    }


    func updateColourMap() {
        image = UIImage.from(mandelbrotSet: mandelbrotSet, colourMap: colourMap)
    }


    func zoomIn(at point: CGPoint) {
        if isInProgress { return }
        let centre = newCentre(from: point)
        config = config.zoomIn(centre: centre)
        generate()
    }


    func onAppear(size: CGSize) {
        width = Int(size.width)
        height = Int(size.height)
        config = MandelbrotSetConfig(imageWidth: width, imageHeight: height)
        generate()
    }


    func timerAction(dt: TimeInterval) {
        guard let s = mandelbrotSet else { return }
        let total = s.gridIterations(config: config)
        DispatchQueue.main.async {
            self.info = Info(
                maxIterations: self.config.iterations,
                totalIterations: total,
                time: dt
            )
        }
    }
}


// MARK: - Private

private extension MainViewModel {
    func newCentre(from point: CGPoint) -> ComplexNumber {
        let imageRect = Rectangle(xMin: 0, yMin: 0, xMax: config.imageWidth, yMax: config.imageHeight)
        let complexRect = Rectangle(config: config)
        let transform = Transformation(from: imageRect, to: complexRect)
        return transform.transform(point: point)
    }
}
