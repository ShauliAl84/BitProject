//
//  MovieItemView.swift
//  LatestMovieApp
//
//  Created by Shauli Algawi on 03/02/2025.
//

import SwiftUI
import ComposableArchitecture
import NukeUI
import Nuke

struct MovieItemView: View {
    
    var movieItem: MovieDataModel
    var favoriteTapeed: () -> ()
    var movieTapeed: () -> ()
    
    var cache: ImageCache {
        var instance = ImageCache()
        instance.ttl = 60 * 60 * 24
        return instance
    }
    
    var pipeline: ImagePipeline {
        let instance = ImagePipeline {
            $0.dataCache = try? DataCache(name: "com.shauli.latestmovieapp")
            $0.dataCachePolicy = .automatic
            $0.imageCache = cache
        }
        
        return instance
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            LazyImage(url: URL(string: baseMediaURL + movieItem.posterPath)) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .scaledToFit()
                }
            }
            .pipeline(pipeline)

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

//#Preview {
//    let schema = Schema([CachedImage.self])
//    let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//    let container = try! ModelContainer(for: schema, configurations: [config])
//    let imageCacheManager = ImageCacheManager(container: container)
//    
//    MovieItemView(movieItem: MovieDataModel(isFavorite: false, category: .nowPlaying, model: MovieDataModel)) {
//        
//    } movieTapeed: {
//        
//    }.environment(imageCacheManager)
//}
