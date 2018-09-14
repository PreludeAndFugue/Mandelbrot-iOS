//
//  ColourChooserVC.swift
//  MandelbrotApp
//
//  Created by gary on 15/09/2018.
//  Copyright © 2018 Gary Kerr. All rights reserved.
//

import UIKit

class ColourChooserVC: UITableViewController {

    var presentr: Presentr?
    let colourMaps = ColourMapFactory.maps

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colourMaps.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ColourChooserCell", for: indexPath)
        cell.textLabel?.text = colourMaps[indexPath.row].title
        return cell
    }
}


// MARK: - Static

extension ColourChooserVC {
    static func present(for viewController: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ColourChooserVC") as? ColourChooserVC else { fatalError() }
        let presentr = Presentr(presentationType: .custom(width: .custom(size: 250), height: .fluid(percentage: 0.8), center: .center))
        presentr.cornerRadius = 4
        vc.presentr = presentr
        viewController.customPresentViewController(presentr, viewController: vc, animated: true)
    }
}
