//
//  ColourMapsView.swift
//  MandelbrotApp
//
//  Created by gary on 10/06/2021.
//  Copyright © 2021 Gary Kerr. All rights reserved.
//

import SwiftUI

import MandelbrotEngine

struct ColourMapsView: View {
    @Environment(\.presentationMode) var presentationMode

    private let maps = ColourMapFactory.maps
    @Binding var current: ColourMapProtocol


    var body: some View {
        NavigationView {
            List(maps, id: \.id) { map in
                Button(action: { select(map: map) }) {
                    HStack {
                        Image(uiImage: image(for: map))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .cornerRadius(8)
                        
                        Text(map.title)

                        Spacer()

                        if map.id == current.id {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            .listStyle(InsetListStyle())
            .navigationBarTitle(Text("Colour Maps"))
        }
    }


    private func select(map: ColourMapProtocol) {
        current = map
        presentationMode.wrappedValue.dismiss()
    }


    private func image(for map: ColourMapProtocol) -> UIImage {
        if map.preview.isEmpty {
            return UIImage(systemName: "questionmark.circle")!
        } else {
            return UIImage.from(pixels: map.preview)
        }
    }
}


#if DEBUG
struct ColourMapsView_Previews: PreviewProvider {
    static var previews: some View {
        ColourMapsView(current: .constant(ColourMapFactory.maps[0]))
    }
}
#endif
