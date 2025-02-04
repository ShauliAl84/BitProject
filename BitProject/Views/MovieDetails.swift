//
//  MovieDetails.swift
//  LatestMovieApp
//
//  Created by Shauli Algawi on 03/02/2025.
//

import SwiftUI

struct MovieDetails: View {
    var movieItem: MovieDataModel
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500" + movieItem.posterPath)) { image in
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
                    RankingView(ranking: movieItem.voteAverage)
                    Text(movieItem.originalTitle)
                        .font(.title)
                    VStack (alignment: .leading){
                        Text("Description")
                            .font(.title)
                        Divider()
                        Text(movieItem.overview)
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
    MovieDetails(movieItem: MovieDataModel.mock)
}
