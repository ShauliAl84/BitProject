//
//  MovieDetails.swift
//  LatestMovieApp
//
//  Created by Shauli Algawi on 03/02/2025.
//

import SwiftUI

struct MovieDetails: View {
    var body: some View {
        VStack {
            Rectangle()
                .frame(height: 300)
                .foregroundStyle(Color.clear)
                .ignoresSafeArea()
            
            AsyncImage(url: URL(string: "https://picsum.photos/id/119/200/200")) { image in
                CircleImage(image: image)
                    .offset(y: -180)
                    .padding(.bottom, -170)
            } placeholder: {
                CircleImage(image: Image(systemName: "person.fill"))
                    .offset(y: -180)
                    .padding(.bottom, -170)
            }
            
            VStack(alignment: .leading) {
                Text("teacher.fullName")
                    .font(.title)
                
                
                HStack {
                    Text("Ranking")
                    Spacer()
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.vertical, 5)
                
                
                Divider()
            }
            .padding()
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
    MovieDetails()
}
