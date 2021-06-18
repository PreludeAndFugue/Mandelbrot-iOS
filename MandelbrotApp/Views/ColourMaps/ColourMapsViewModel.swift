//
//  ColourMapsViewModel.swift
//  MandelbrotApp
//
//  Created by gary on 18/06/2021.
//  Copyright © 2021 Gary Kerr. All rights reserved.
//

import MandelbrotEngine

import SwiftUI

final class ColourMapsViewModel {
    let maps: [ColourMapProtocol]

    let gridItems: [GridItem] = [
        GridItem(.fixed(100), spacing: 8, alignment: .center),
        GridItem(.fixed(100), spacing: 8, alignment: .center),
        GridItem(.fixed(100), spacing: 8, alignment: .center),
    ]


    init(maps: [ColourMapProtocol]) {
        self.maps = maps
    }
}
