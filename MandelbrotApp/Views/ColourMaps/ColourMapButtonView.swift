//
//  ColourMapButtonView.swift
//  MandelbrotApp
//
//  Created by gary on 18/06/2021.
//  Copyright © 2021 Gary Kerr. All rights reserved.
//

import SwiftUI

import MandelbrotEngine

struct ColourMapButtonView: View {
    var map: ColourMapProtocol
    var action: (ColourMapProtocol) -> Void

    var body: some View {
        Button(action: { action(map) }) {
            ZStack(alignment: .bottomLeading) {
                Image(uiImage: image(for: map))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .cornerRadius(8)

                Text(map.title)
                    .font(.caption)
                    .padding(4)
                    .frame(maxWidth: .infinity)
                    .background(Color.init(.displayP3, white: 1, opacity: 0.4))
            }
        }
        .buttonStyle(PlainButtonStyle())
    }


    func image(for map: ColourMapProtocol) -> UIImage {
        if map.preview.isEmpty {
            return UIImage(systemName: "questionmark.circle")!
        } else {
            return UIImage.from(pixels: map.preview)
        }
    }
}


#if DEBUG
struct ColourMapButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ColourMapButtonView(map: ColourMapFactory.maps[0], action: { _ in })
    }
}
#endif
