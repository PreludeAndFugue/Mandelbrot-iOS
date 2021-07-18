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

                    MenuView(viewModel: viewModel)
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
            .onChange(of: proxy.size, perform: { value in
                print("proxy size change", proxy.size)
                viewModel.onAppear(size: proxy.size)
            })
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
