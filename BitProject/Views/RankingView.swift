//
//  RankingView.swift
//  BitProject
//
//  Created by Shauli Algawi on 04/02/2025.
//

import SwiftUI

struct RankingView: View {
    var ranking: CGFloat
    private let minValue = 1.0
    private let maxValue = 10.0
    
    let gradient = Gradient(colors: [.blue, .green, .pink])
        var body: some View {
            VStack {
                Gauge(value: ranking, in: minValue...maxValue) {
                    Text("Movie Rating")
                } currentValueLabel: {
                    Text(Int(ranking * 10), format: .number)
                        .foregroundColor(.green)
                } minimumValueLabel: {
                    Text("")
                        .foregroundColor(.blue)
                } maximumValueLabel: {
                    Text("")
                        .foregroundColor(.pink)
                }
                .tint(gradient)
            }
            .gaugeStyle(.accessoryCircular)
            .padding()
        }
}

#Preview {
    RankingView(ranking: 6.6)
}
