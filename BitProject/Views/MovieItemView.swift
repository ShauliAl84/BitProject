//
//  MovieItemView.swift
//  LatestMovieApp
//
//  Created by Shauli Algawi on 03/02/2025.
//

import SwiftUI
import ComposableArchitecture
import ImageCacheKit
import SwiftData

struct MovieItemView: View {
    
    var movieItem: PersistantMovieData
    var favoriteTapeed: () -> ()
    var movieTapeed: () -> ()
    
    @Environment(ImageCacheManager.self) private var cacheManager
    var body: some View {
        ZStack(alignment: .topTrailing) {
            CachedAsyncImage(url:  URL(string: baseMediaURL + movieItem.posterPath), imageCacheManager: cacheManager)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Menu {
                Button {
                    movieTapeed()
                } label: {
                    Text("Show details")
                }
                
                Button {
                    favoriteTapeed()
                } label: {
                    Text(movieItem.isFavorite ? "Remove from favorites" : "Add to favorites")
                }

            } label: {
                Image(systemName: "ellipsis.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .background(Circle().fill(Color.black.opacity(0.7)))
                    .padding(5)
            }

            
        }
        .onTapGesture {
            movieTapeed()
        }
        .shadow(radius: 8)
        .padding()
        
    }
}

#Preview {
    let schema = Schema([PersistantMovieData.self, CachedImage.self])
    let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    let container = try! ModelContainer(for: schema, configurations: [config])
    let imageCacheManager = ImageCacheManager(container: container)
    
    MovieItemView(movieItem: PersistantMovieData(isFavorite: false, category: .nowPlaying, movieDataModel: MovieDataModel.mock)) {
        
    } movieTapeed: {
        
    }.environment(imageCacheManager)
}
