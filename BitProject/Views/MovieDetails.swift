//
//  MovieDetails.swift
//  LatestMovieApp
//
//  Created by Shauli Algawi on 03/02/2025.
//

import SwiftUI
import ComposableArchitecture

struct MovieDetails: View {
    
    var store: StoreOf<MovieDetailsReducer>
    var body: some View {
       
            VStack {
                AsyncImage(url: URL(string: baseMediaURL + store.movie.posterPath)) { image in
                    image
                        .resizable()
                        .frame(height: 400)
                        .scaledToFit()
                        .ignoresSafeArea()
                        .shadow(radius: 7)
                } placeholder: {
                    
                }
                ScrollView {
                    VStack(alignment: .leading) {
                        RankingView(ranking: store.movie.voteAverage)
                        Text(store.movie.originalTitle)
                            .font(.title)
                        VStack (alignment: .leading){
                            Text("Description")
                                .font(.title)
                            Divider()
                            Text(store.movie.overview)
                                .font(.title2)
                            Spacer()
                        }
                        .padding(.vertical, 5)
                        
                        
                        Divider()
                    }
                    .padding()
                }
                Spacer()
            }
        
        
    }
}

#Preview {
    let networkModel = MovieDataModel(originalTitle: "Sonic the Hedgehog 3", originalLanguage: "en", overview: "Sonic, Knuckles, and Tails reunite against a powerful new adversary, Shadow, a mysterious villain with powers unlike anything they have faced before. With their abilities outmatched in every way, Team Sonic must seek out an unlikely alliance in hopes of stopping Shadow and protecting the planet.", posterPath: "/d8Ryb8AunYAuycVKDp5HpdWPKgC.jpg", voteAverage: 7.5, releaseDate: "2025-01-01", category: "Upcoming", id: 34556, isFavorite: true)
    MovieDetails(store: .init(initialState: MovieDetailsReducer.State(movie: networkModel), reducer: {
        MovieDetailsReducer()
    }))
}
