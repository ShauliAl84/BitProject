//
//  MovieDetails.swift
//  LatestMovieApp
//
//  Created by Shauli Algawi on 03/02/2025.
//

import SwiftUI
import ComposableArchitecture
import ImageCacheKit
import SwiftData

struct MovieDetails: View {
    
    var store: StoreOf<MovieDetailsReducer>
    @Environment(ImageCacheManager.self) private var cacheManager
    var body: some View {
        ZStack (alignment: .top){
            CachedAsyncImage(url:  URL(string: baseMediaURL + store.movie.backdropPath), imageCacheManager: cacheManager)
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(0.2)
            
            VStack {
                HStack(alignment: .top) {
                    CachedAsyncImage(url:  URL(string: baseMediaURL + store.movie.posterPath), imageCacheManager: cacheManager)
                        .frame(height: 300)
                        
                    VStack(spacing: 10) {
                        Text(store.movie.originalTitle)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(store.movie.releaseDate.prefix(4))
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        RankingView(ranking: store.movie.voteAverage)
                    }
                }
                .containerRelativeFrame(.horizontal, count: 2, span: 2, spacing: 10)
                VStack {
                    Text("Description")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    ScrollView {
                        Text(store.movie.overview)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.all, 10)
                            .containerRelativeFrame([.horizontal, .vertical])
                    }
                    
                }
                .padding()
                
                
            }
            .padding()
        }
    }
}

#Preview {
    
    let schema = Schema([CachedImage.self])
    let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    let container = try! ModelContainer(for: schema, configurations: [config])
    let imageCacheManager = ImageCacheManager(container: container)
    
    let networkModel = MovieDataModel(originalTitle: "Sonic the Hedgehog 3", originalLanguage: "en", overview: "Sonic, Knuckles, and Tails reunite against a powerful new adversary, Shadow, a mysterious villain with powers unlike anything they have faced before. With their abilities outmatched in every way, Team Sonic must seek out an unlikely alliance in hopes of stopping Shadow and protecting the planet.", posterPath: "/d8Ryb8AunYAuycVKDp5HpdWPKgC.jpg", backdropPath: "/zOpe0eHsq0A2NvNyBbtT6sj53qV.jpg", voteAverage: 7.5, releaseDate: "2025-01-01", category: "Upcoming", id: 34556, isFavorite: true)
    MovieDetails(store: .init(initialState: MovieDetailsReducer.State(movie: networkModel), reducer: {
        MovieDetailsReducer()
    }))
    .environment(imageCacheManager)
}
