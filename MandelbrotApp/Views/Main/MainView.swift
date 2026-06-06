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
#if os(iOS)
            content(proxy: proxy)
                .ignoresSafeArea()
#else
            content(proxy: proxy)
#endif
        }
    }
}


// MARK: - Private

private extension MainView {
    func content(proxy: GeometryProxy) -> some View {
        let canvasSize = canvasSize(proxy: proxy)

        return ZStack {
            ZStack(alignment: .topTrailing) {
                mandelbrotImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: canvasSize.width, height: canvasSize.height)
                    .background(Color.black)
                    .clipped()
                    .contentShape(Rectangle())
                    .gesture(makeGesture())

                MenuView(viewModel: viewModel)
                    .padding(.top, proxy.safeAreaInsets.top)
                    .padding(.trailing, proxy.safeAreaInsets.trailing)
            }

            ProgressView(viewModel.progress)
                .frame(width: 250, height: 5)
                .padding()
                .background(Color(.displayP3, white: 1, opacity: 0.15))
                .cornerRadius(16)
                .opacity(viewModel.isInProgress ? 1 : 0)
                .progressViewStyle(MyProgressViewStyle())
        }
        .overlay(alignment: .bottomLeading) {
            DisclosureInfoView(viewModel: viewModel)
                .padding(.leading, proxy.safeAreaInsets.leading)
                .padding(.bottom, proxy.safeAreaInsets.bottom)
        }
        .background(Color.black)
        .onAppear {
            viewModel.onAppear(size: canvasSize)
        }
        .onChange(of: proxy.size) { value in
            viewModel.onAppear(size: canvasSize)
        }
        .sheet(isPresented: $viewModel.isSelectingColourMap, onDismiss: viewModel.updateColourMap) {
            ColourMapsView(current: $viewModel.colourMap)
        }
    }


    func canvasSize(proxy: GeometryProxy) -> CGSize {
#if os(iOS)
        CGSize(
            width: proxy.size.width + proxy.safeAreaInsets.leading + proxy.safeAreaInsets.trailing,
            height: proxy.size.height + proxy.safeAreaInsets.top + proxy.safeAreaInsets.bottom
        )
#else
        proxy.size
#endif
    }


    var mandelbrotImage: Image {
#if os(macOS)
        Image(nsImage: viewModel.image)
#else
        Image(uiImage: viewModel.image)
#endif
    }


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
