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

    private let vm = ColourMapsViewModel(maps: ColourMapFactory.maps)
    @Binding var current: ColourMapProtocol


    var body: some View {
#if os(macOS)
        macOSBody
#else
        NavigationView {
            VStack {
                ScrollView {
                    LazyVGrid(columns: vm.gridItems) {
                        ForEach(vm.maps, id: \.title) { map in
                            ColourMapButtonView(map: map, action: select)
                        }
                    }
                }
            }
            .padding()
            .navigationTitle(Text("Colour Maps"))
        }
#endif
    }



    private func select(map: ColourMapProtocol) {
        current = map
        presentationMode.wrappedValue.dismiss()
    }
}


// MARK: - macOS

#if os(macOS)
private extension ColourMapsView {
    var macOSBody: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Colour Map")
                        .font(.headline)

                    Text(current.title)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .keyboardShortcut(.defaultAction)
            }

            LazyVGrid(columns: macOSGridItems, spacing: 14) {
                ForEach(vm.maps, id: \.title) { map in
                    ColourMapButtonView(
                        map: map,
                        isSelected: map.title == current.title,
                        tileSize: 132,
                        action: select
                    )
                }
            }
        }
        .padding(22)
        .frame(width: macOSPanelWidth)
        .background(.regularMaterial)
    }


    var macOSGridItems: [GridItem] {
        [
            GridItem(.fixed(132), spacing: 14),
            GridItem(.fixed(132), spacing: 14),
            GridItem(.fixed(132), spacing: 14),
        ]
    }


    var macOSPanelWidth: CGFloat {
        132 * 3 + 14 * 2 + 44
    }
}
#endif


#if DEBUG
struct ColourMapsView_Previews: PreviewProvider {
    static var previews: some View {
        ColourMapsView(current: .constant(ColourMapFactory.maps[0]))
    }
}
#endif
