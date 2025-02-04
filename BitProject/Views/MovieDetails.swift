//
//  MovieDetails.swift
//  LatestMovieApp
//
//  Created by Shauli Algawi on 03/02/2025.
//

import SwiftUI
import ComposableArchitecture

struct MovieDetails: View {
    
    let store: StoreOf<MovieDetailsReducer>
    var body: some View {
        WithViewStore(store, observe: {$0}) { viewStore in
            VStack {
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500" + viewStore.movie.posterPath)) { image in
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
                        RankingView(ranking: viewStore.movie.voteAverage)
                        Text(viewStore.movie.originalTitle)
                            .font(.title)
                        VStack (alignment: .leading){
                            Text("Description")
                                .font(.title)
                            Divider()
                            Text(viewStore.movie.overview)
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
}

struct CircleImage: View {
    let image: Image
    var body: some View {
        image
            .resizable()
            .frame(width: 200, height: 200)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
    }
}

#Preview {
//    MovieDetails(store: .init(initialState: MovieDetailsReducer.State(movie: MovieDataModel.mock), reducer: {
//        MovieItemReducer()
//    }))
}
