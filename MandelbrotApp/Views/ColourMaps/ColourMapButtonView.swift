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
    var isSelected = false
    var tileSize: CGFloat = 100
    var action: (ColourMapProtocol) -> Void

    var body: some View {
        Button(action: { action(map) }) {
            ZStack(alignment: .bottom) {
                imageView(for: map)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: tileSize, height: tileSize)
                    .clipped()

                Text(map.title)
                    .font(.caption)
                    .lineLimit(1)
                    .padding(4)
                    .frame(maxWidth: .infinity)
                    .background(Color("ColourMapNameBackground"))
            }
            .frame(width: tileSize, height: tileSize)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .strokeBorder(isSelected ? Color.accentColor : Color.clear, lineWidth: 3)
            }
            .contentShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(PlainButtonStyle())
    }


    func imageView(for map: ColourMapProtocol) -> Image {
#if os(macOS)
        Image(nsImage: image(for: map))
#else
        Image(uiImage: image(for: map))
#endif
    }


    func image(for map: ColourMapProtocol) -> PlatformImage {
        if map.preview.isEmpty {
#if os(macOS)
            return NSImage(systemSymbolName: "questionmark.circle", accessibilityDescription: nil)!
#else
            return UIImage(systemName: "questionmark.circle")!
#endif
        } else {
            return PlatformImage.from(pixels: map.preview)
        }
    }
}


#if DEBUG
struct ColourMapButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ColourMapButtonView(map: ColourMapFactory.maps[2], action: { _ in })
                .previewLayout(.fixed(width: 100, height: 100))
            ColourMapButtonView(map: ColourMapFactory.maps[2], action: { _ in })
                .preferredColorScheme(.dark)
                .previewLayout(.fixed(width: 100, height: 100))
        }
    }
}
#endif
