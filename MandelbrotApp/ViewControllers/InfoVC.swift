//
//  InfoVC.swift
//  MandelbrotApp
//
//  Created by gary on 15/09/2018.
//  Copyright © 2018 Gary Kerr. All rights reserved.
//

import UIKit

class InfoVC: UIViewController {

    var presentr: Presentr?
    var info: String!

    @IBOutlet weak var infoLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        infoLabel.text = info
    }
}


// MARK: - Static

extension InfoVC {
    static func present(for viewController: UIViewController, info: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "InfoVC") as? InfoVC else {
            fatalError()
        }
        let presentr = Presentr(presentationType: .dynamic(center: .center))
        vc.presentr = presentr
        vc.info = info
        viewController.customPresentViewController(presentr, viewController: vc, animated: true)
    }
}
