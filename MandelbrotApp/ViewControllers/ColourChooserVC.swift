//
//  ColourChooserVC.swift
//  MandelbrotApp
//
//  Created by gary on 15/09/2018.
//  Copyright © 2018 Gary Kerr. All rights reserved.
//

import UIKit

typealias ColourChooserPresenter = UIViewController & ColourChooserVCDelegate

protocol ColourChooserVCDelegate: class {
    func didSelect(_ vc: ColourChooserVC, index: Int)
}


class ColourChooserVC: UITableViewController {

    var presentr: Presentr?
    var colourMapIndex: Int!
    weak var delegate: ColourChooserVCDelegate?
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
        cell.accessoryType = indexPath.row == colourMapIndex ? .checkmark : .none
        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelect(self, index: indexPath.row)
    }
}


// MARK: - Static

extension ColourChooserVC {
    static func present(for presenter: ColourChooserPresenter, colourMapIndex: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ColourChooserVC") as? ColourChooserVC else { fatalError() }
        let presentr = Presentr(presentationType: .custom(width: .custom(size: 250), height: .fluid(percentage: 0.8), center: .center))
        presentr.cornerRadius = 4
        vc.presentr = presentr
        vc.delegate = presenter
        vc.colourMapIndex = colourMapIndex
        presenter.customPresentViewController(presentr, viewController: vc, animated: true)
    }
}
