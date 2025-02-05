//
//  MovieItemView.swift
//  LatestMovieApp
//
//  Created by Shauli Algawi on 03/02/2025.
//

import SwiftUI
import ComposableArchitecture
import ImageCacheKit

struct MovieItemView: View {
    
    var movieItem: MovieDataModel
    var favoriteTapeed: (Int) -> ()
    var movieTapeed: (MovieDataModel) -> ()
    
    @Environment(ImageCacheManager.self) private var cacheManager
    var body: some View {
        VStack {
            CachedAsyncImage(url:  URL(string: NetworkManager.baseMediaURL + movieItem.posterPath), imageCacheManager: cacheManager)
                .clipShape(RoundedRectangle(cornerRadius: 8))
//            AsyncImage(url: URL(string: NetworkManager.baseMediaURL + movieItem.posterPath)) { image in
//                image
//                    .resizable()
//                    .scaledToFit()
//                    .clipShape(RoundedRectangle(cornerRadius: 8))
//            } placeholder: {
//                ProgressView()
//            }
            VStack {
                Button {
                    favoriteTapeed(movieItem.id)
                } label: {
                    Image(systemName: "star.fill")
                        .foregroundStyle(Color.yellow)
                        .font(.largeTitle)
                }
            }
        }
        .onTapGesture {
            movieTapeed(movieItem)
        }
        .shadow(radius: 8)
        .padding()
        
    }
}

#Preview {
    MovieItemView(movieItem: MovieDataModel.mock) { movieItemId in
        
    } movieTapeed: { movieItemId in
        
    }
}
