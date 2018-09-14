//
//  ViewController.swift
//  MandelbrotApp
//
//  Created by gary on 13/09/2018.
//  Copyright © 2018 Gary Kerr. All rights reserved.
//

import UIKit

final class MainVC: UIViewController {
    var data: MainVCData!

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var mandelbrotImage: UIImageView!


    @IBAction func reset(_ sender: Any) {
        data.reset()
        generateImage()
    }


    @IBAction func recolour(_ sender: Any) {
        print("recolour")
    }


    @IBAction func tapImage(recogniser: UITapGestureRecognizer) {
        let imageCoords = recogniser.location(in: mandelbrotImage)
        data.zoomIn(at: imageCoords)
        generateImage()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        let size = view.frame.size
        data = MainVCData(width: Int(size.width), height: Int(size.height))
        generateImage()
    }
}


private extension MainVC {
    func generateImage() {
        let progress = configureProgress()
        data.makeImage(progress: progress, completion: generateImageCompletion)
    }


    func configureProgress() -> Progress {
        let progress = Progress(totalUnitCount: 100)
        progressView.observedProgress = progress
        progressView.isHidden = false
        return progress
    }


    func generateImageCompletion(image: UIImage) {
        mandelbrotImage.image = image
        progressView.isHidden = true
    }
}
