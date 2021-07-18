//
//  DisclosureInfoView.swift
//  MandelbrotApp
//
//  Created by gary on 18/07/2021.
//  Copyright © 2021 Gary Kerr. All rights reserved.
//

import SwiftUI

private let nf: NumberFormatter = {
    let nf = NumberFormatter()
    nf.allowsFloats = false
    nf.groupingSize = 3
    nf.numberStyle = .decimal
    return nf
}()


private let tf: MeasurementFormatter = {
    let mf = MeasurementFormatter()
    mf.numberFormatter.allowsFloats = true
    mf.numberFormatter.maximumFractionDigits = 2
    return mf
}()


struct DisclosureInfoView: View {
    @StateObject var viewModel: MainViewModel
    @State var isExpanded = false

    var body: some View {
        DisclosureGroup(
            isExpanded: $isExpanded,
            content: content,
            label: label
        )
        .accentColor(.accentColor)
        .padding(6)
        .foregroundColor(.white)
        .background(Color.black.opacity(0.4))
        .cornerRadius(9)
        .frame(width: 240)
        .padding([.leading, .bottom], 4)
    }
}


// MARK: - Private

private extension DisclosureInfoView {
    func label() -> some View {
        Button("Info") {
            withAnimation {
                isExpanded.toggle()
            }
        }
    }


    func content() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("MAX ITERATIONS ").font(.system(size: 11))
                    + Text(maxIterations)
                Text("TOTAL ITERATIONS ").font(.system(size: 11))
                    + Text(totalIterations)
                Text("TIME ").font(.system(size: 11))
                    + Text(time)
            }
            Spacer()
        }
    }


    var maxIterations: String {
        let n = NSNumber(value: viewModel.info.maxIterations)
        return nf.string(from: n) ?? "0"
    }


    var totalIterations: String {
        let n = NSNumber(value: viewModel.info.totalIterations)
        return nf.string(from: n) ?? "0"
    }


    var time: String {
        let dt = Measurement(value: viewModel.info.time, unit: UnitDuration.seconds)
        return tf.string(from: dt)
    }
}

#if DEBUG
struct DisclosureInfoView_Previews: PreviewProvider {
    private static let model = MainViewModel()
    static var previews: some View {
        DisclosureInfoView(viewModel: model)
    }
}
#endif
