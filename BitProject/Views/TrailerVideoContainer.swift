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
    @Environment(\.dismiss) private var dismiss
    
    init(videoId: String) {
        self.youTubePlayer = YouTubePlayer(urlString: "https://youtube.com/watch?v=\(videoId)")
    }
    
    var body: some View {
        NavigationStack {
            VStack {
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation {
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color.gray)
                    }

                }
            }
            .presentationDragIndicator(.hidden)
            .interactiveDismissDisabled(true)
        }
    }
}

#Preview {
    TrailerVideoContainer(videoId: "Kp6WlyxBHBM")
}
