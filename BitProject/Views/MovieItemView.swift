//
//  MovieItemView.swift
//  LatestMovieApp
//
//  Created by Shauli Algawi on 03/02/2025.
//

import SwiftUI
import ComposableArchitecture

struct MovieItemView: View {
    
    var movieItem: MovieDataModel
    var favoriteTapeed: (Int) -> ()
    var movieTapeed: (Int) -> ()
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: NetworkManager.baseMediaURL + movieItem.posterPath)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } placeholder: {
                ProgressView()
            }
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
            movieTapeed(movieItem.id)
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
