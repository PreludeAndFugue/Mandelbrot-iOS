//
//  MainView.swift
//  MandelbrotApp
//
//  Created by gary on 10/06/2021.
//  Copyright © 2021 Gary Kerr. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: viewModel.image)
                        .resizable()
                        .background(Color.black)
                        .ignoresSafeArea()

                    VStack(alignment: .trailing, spacing: 10) {
                        Button(action: viewModel.reset) {
                            Text("Reset")
                                .padding(8)
                        }
                        .foregroundColor(.white)
                        .background(Color.init(.displayP3, white: 1, opacity: 0.1))
                        .cornerRadius(8)

                        Button(action: viewModel.selectColourMap) {
                            Text("Colour")
                                .padding(8)
                        }
                        .foregroundColor(.white)
                        .background(Color.init(.displayP3, white: 1, opacity: 0.05))
                        .cornerRadius(8)

                        Button(action: viewModel.info) {
                            Text("Info")
                                .padding(8)
                        }
                        .foregroundColor(.white)
                        .background(Color.init(.displayP3, white: 1, opacity: 0.05))
                        .cornerRadius(8)
                    }
                }

                ProgressView(viewModel.progress)
                    .frame(width: 250)
                    .opacity(viewModel.isInProgress ? 1 : 0)
            }
            .onAppear {
                viewModel.onAppear(size: proxy.size)
            }
            .sheet(isPresented: $viewModel.isSelectingColourMap, onDismiss: viewModel.updateColourMap) {
                ColourMapsView(current: $viewModel.colourMap)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
