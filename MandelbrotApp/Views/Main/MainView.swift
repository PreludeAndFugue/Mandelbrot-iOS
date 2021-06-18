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
                        .gesture(makeGesture())

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

                ProgressView(viewModel.progress)
                    .frame(width: 250, height: 5)
                    .padding()
                    .background(Color(.displayP3, white: 1, opacity: 0.15))
                    .cornerRadius(16)
                    .opacity(viewModel.isInProgress ? 1 : 0)
                    .progressViewStyle(MyProgressViewStyle())
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


// MARK: - Private

private extension MainView {
    func makeGesture() -> _ChangedGesture<DragGesture> {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged() { value in
                print(value.location)
                viewModel.zoomIn(at: value.location)
            }
    }
}


#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
#endif
