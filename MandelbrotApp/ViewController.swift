//
//  ViewController.swift
//  MandelbrotApp
//
//  Created by gary on 13/09/2018.
//  Copyright © 2018 Gary Kerr. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    let colourMaps = ColourMapFactory.maps
    var mandelbrotSet: MandelbrotSet?
    var config: MandelbrotSetConfig!

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var mandelbrotImage: UIImageView!


    @IBAction func reset(_ sender: Any) {
        reset()
    }


    @IBAction func recolour(_ sender: Any) {
        print("recolour")
    }


    @IBAction func tapImage(recogniser: UITapGestureRecognizer) {
        let imageCoords = recogniser.location(in: mandelbrotImage)
        config = config.zoomIn(centre: newCentre(from: imageCoords))
        print(imageCoords)
        print(config)
        makeSet(with: config)
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear", mandelbrotImage.frame.size)
        reset()
    }
}


private extension ViewController {
    func setDefaultConfig() {
        let dims = mandelbrotImage.frame.size
        let width = Int(dims.width)
        let height = Int(dims.height)
        config = MandelbrotSetConfig(imageWidth: width, imageHeight: height)
    }


    func reset() {
        setDefaultConfig()
        makeSet(with: config)
    }


    func makeSet(with config: MandelbrotSetConfig) {

        let progress = Progress(totalUnitCount: 100)
        progressView.observedProgress = progress
        progressView.isHidden = false

        DispatchQueue.global().async {
            self.mandelbrotSet = MandelbrotSet(config: config, progress: progress)
            let colourMap = self.colourMaps[0]
            let pixels = self.mandelbrotSet!.grid.map({ colourMap.pixel(from: $0.test) })
            let image = UIImage.from(
                pixels: pixels,
                width: self.mandelbrotSet!.imageSize.width,
                height: self.mandelbrotSet!.imageSize.height
            )
            DispatchQueue.main.async {
                self.mandelbrotImage.image = image
                self.progressView.isHidden = true
            }
        }
    }


    func newCentre(from imageCoords: CGPoint) -> ComplexNumber {
        let imageRect = Rectangle(xMin: 0, yMin: 0, xMax: config.imageWidth, yMax: config.imageHeight)
        let complexRect = Rectangle(config: config)
        let transform = Transformation(from: imageRect, to: complexRect)
        return transform.transform(point: imageCoords)
    }
}

