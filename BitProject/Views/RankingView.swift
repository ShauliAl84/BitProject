//
//  RankingView.swift
//  BitProject
//
//  Created by Shauli Algawi on 04/02/2025.
//

import SwiftUI
struct CircularProgressView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.gray.opacity(0.5),
                    lineWidth: 10
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.pink,
                    style: StrokeStyle(
                        lineWidth: 10,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
            
        }
    }
}

struct RankingView: View {
    var ranking: Float

    var body: some View {
        VStack {
            Spacer()
            ZStack {
                
                CircularProgressView(progress: Double(ranking / 10))
                
                Text("\(ranking * 10, specifier: "%.0f")")
                    .foregroundStyle(Color.black)
                    .font(.largeTitle)
                    .bold()
                    
            }.frame(width: 100, height: 100)
            Spacer()
        }
    }
}

#Preview {
    RankingView(ranking: 6.6)
}
