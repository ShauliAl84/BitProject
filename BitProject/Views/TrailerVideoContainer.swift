//
//  TrailerVideoContainer.swift
//  BitProject
//
//  Created by Shauli Algawi on 07/02/2025.
//

import SwiftUI
import YouTubePlayerKit

struct TrailerVideoContainer: View {
    let youTubePlayer: YouTubePlayer
    
    init(videoId: String) {
        self.youTubePlayer = YouTubePlayer(urlString: "https://youtube.com/watch?v=\(videoId)")
    }
    
    var body: some View {
        YouTubePlayerView(youTubePlayer) { state in
            switch state {
            case .idle:
                ProgressView()
            case .ready:
                EmptyView()
            case .error(let error):
                ContentUnavailableView("Error", systemImage: "exclamationmark.triangle.fill", description: Text("YouTube player couldn't be loaded: \(error)"))
            }
        }
    }
}

#Preview {
    TrailerVideoContainer(videoId: "Kp6WlyxBHBM")
}
