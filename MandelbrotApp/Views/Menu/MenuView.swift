//
//  MenuView.swift
//  MandelbrotApp
//
//  Created by gary on 18/07/2021.
//  Copyright © 2021 Gary Kerr. All rights reserved.
//

import SwiftUI

struct MenuView: View {
    @StateObject var viewModel: MainViewModel

    var body: some View {
        VStack(alignment: .trailing, spacing: 10) {
            Button(action: viewModel.reset) {
                Text("Reset")
                    .padding(8)
            }
            .foregroundColor(.white)
            .background(Color(.displayP3, white: 0, opacity: 0.2))
            .cornerRadius(8)

            Button(action: viewModel.selectColourMap) {
                Text("Colour")
                    .padding(8)
            }
            .foregroundColor(.white)
            .background(Color(.displayP3, white: 0, opacity: 0.2))
            .cornerRadius(8)

            Button(action: viewModel.info) {
                Text("Info")
                    .padding(8)
            }
            .foregroundColor(.white)
            .background(Color(.displayP3, white: 0, opacity: 0.2))
            .cornerRadius(8)
        }
        .padding(4)
        .background(Color(.displayP3, white: 0, opacity: 0.1))
        .cornerRadius(9)
        .padding(.top, 4)
    }
}


#if DEBUG
struct MenuView_Previews: PreviewProvider {
    private static let model = MainViewModel()
    static var previews: some View {
        MenuView(viewModel: model)
    }
}
#endif
