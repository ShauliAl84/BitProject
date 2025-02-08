//
//  MovieDetails.swift
//  LatestMovieApp
//
//  Created by Shauli Algawi on 03/02/2025.
//

import SwiftUI
import ComposableArchitecture
import SwiftData
import NukeUI

struct MovieDetails: View {
    
    @Bindable var store: StoreOf<MovieDetailsReducer>
    var body: some View {
        ZStack (alignment: .top) {
            
            LazyImage(url: URL(string: Endpoints.imageFromPath(store.movie?.posterPath ?? "").path)) { state in
                if let image = state.image {
                    image
                        .scaledToFill()
                        .ignoresSafeArea()
                        .opacity(0.2)
                }
            }
            
            
            VStack {
                HStack(alignment: .top) {
                    LazyImage(url: URL(string: Endpoints.imageFromPath(store.movie?.posterPath ?? "").path)) { state in
                        if let image = state.image {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                        }
                    }
                        
                    VStack(spacing: 10) {
                        Text(store.movie?.originalTitle ?? "Not Available")
                            .font(.system(size: 17))
                            .fontWeight(.bold)
                        
                        Text(store.movie?.releaseDate.prefix(4) ?? "")
                            .font(.title2)
                            .fontWeight(.bold)
                        Button {
                            store.send(.showTrailer)
                        } label: {
                            HStack {
                                Text("Play Trailer")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Image(systemName: "play.fill")
                                    .font(.largeTitle)
                            }
                        }

                        RankingView(ranking: store.movie?.voteAverage ?? 0)
                    }
                }
                .containerRelativeFrame(.horizontal, count: 2, span: 2, spacing: 10)
                VStack {
                    Text("Description")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    ScrollView {
                        VStack {
                            Text(store.movie?.overview ?? "")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        .padding(.all, 10)
                        .containerRelativeFrame([.horizontal])
                    }
                }
                .padding()
                
                
            }
            .padding()
        }
        .overlay(content: {
            if store.loadingTrailer {
                
                Rectangle()
                    .foregroundStyle(Color.black.opacity(0.8))
                    .ignoresSafeArea()
                    .overlay {
                        ProgressView("Loading Trailer")
                            .font(.largeTitle)
                            .foregroundStyle(Color.white)
                            .tint(Color.white)
                        
                    }
            }
            
        })
        .sheet(isPresented: $store.shouldShowTrailer, content: {
            TrailerVideoContainer(videoId: store.trailerId)
                .onDisappear {
                    store.shouldShowTrailer = false
                }
        })
        .alert("Trailer Fetching Error", isPresented: $store.shouldDisplayError) {
            
        } message: {
            Text(store.errorString)
        }
        

    }
}

//#Preview {
//    
//    
//    let networkModel = MovieDataModel(originalTitle: "Sonic the Hedgehog 3", originalLanguage: "en", overview: "Sonic, Knuckles, and Tails reunite against a powerful new adversary, Shadow, a mysterious villain with powers unlike anything they have faced before. With their abilities outmatched in every way, Team Sonic must seek out an unlikely alliance in hopes of stopping Shadow and protecting the planet.", posterPath: "/d8Ryb8AunYAuycVKDp5HpdWPKgC.jpg", backdropPath: "/zOpe0eHsq0A2NvNyBbtT6sj53qV.jpg", voteAverage: 7.5, releaseDate: "2025-01-01", category: "Upcoming", id: 34556, isFavorite: true)
//    MovieDetails(store: .init(initialState: MovieDetailsReducer.State(movie: networkModel), reducer: {
//        MovieDetailsReducer()
//    }))
//}
