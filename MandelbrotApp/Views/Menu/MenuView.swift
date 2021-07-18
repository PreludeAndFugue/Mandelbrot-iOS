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
            button(title: "Reset", action: viewModel.reset)

            button(title: "Colour", action: viewModel.selectColourMap)
        }
        .padding(10)
        .background(Color(.displayP3, white: 0, opacity: 0.1))
        .cornerRadius(9)
        .padding([.top, .trailing], 4)
    }
}


// MARK: - Private

private extension MenuView {
    func button(title: String, action: @escaping () -> Void) -> some View{
        Button(action: action) {
            Text(title)
                .padding(8)
        }
        .foregroundColor(.white)
        .background(Color(.displayP3, white: 0, opacity: 0.2))
        .cornerRadius(8)
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
