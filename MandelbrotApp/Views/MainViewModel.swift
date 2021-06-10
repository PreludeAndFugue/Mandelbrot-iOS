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

class MainViewModel: ObservableObject {
    private var width = 0
    private var height = 0
    private let colourMaps = ColourMapFactory.maps
    private var colourMap = ColourMapFactory.maps[0]
    private var config = MandelbrotSetConfig(imageWidth: 0, imageHeight: 0)
    private var mandelbrotSet: MandelbrotSet!

    @Published var loadingProgress = 0.0
    @Published var progress = Progress(totalUnitCount: 100)
    @Published var isInProgress = false
    @Published var image = UIImage()


    func reset() {
        config = MandelbrotSetConfig(imageWidth: width, imageHeight: height)
        colourMap = colourMaps[1]
        generate()
    }


    func colour() {
        print("colour")
    }


    func info() {
        print("info")
    }


    func generate() {
        progress = Progress(totalUnitCount: 100)
        isInProgress = true
        DispatchQueue.global().async {
            self.mandelbrotSet = MandelbrotSet(config: self.config, progress: self.progress)
            DispatchQueue.main.async {
                self.image = self.mandelbrotSet.image(with: self.colourMap)
                self.isInProgress = false
            }
        }
    }


    func onAppear(size: CGSize) {
        width = Int(size.width)
        height = Int(size.height)
        config = MandelbrotSetConfig(imageWidth: width, imageHeight: height)
        generate()
    }
}
