//
//  MovieDataModel.swift
//  LatestMovieApp
//
//  Created by Shauli Algawi on 03/02/2025.
//

import Foundation

struct MovieDataModel: Decodable, Equatable, Identifiable {
    let originalTitle: String
    let originalLanguage: String
    let overview: String
    let posterPath: String
    let voteAverage: CGFloat
    let releaseDate: String
    var id: Int = Int.random(in: 1...100000)
    
    enum CodingKeys: String, CodingKey {
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case overview = "overview"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case id = "id"
    }
}

extension MovieDataModel {
    static var mock: MovieDataModel = MovieDataModel(originalTitle: "Sonic the Hedgehog 3", originalLanguage: "en", overview: "Sonic, Knuckles, and Tails reunite against a powerful new adversary, Shadow, a mysterious villain with powers unlike anything they have faced before. With their abilities outmatched in every way, Team Sonic must seek out an unlikely alliance in hopes of stopping Shadow and protecting the planet.", posterPath: "/d8Ryb8AunYAuycVKDp5HpdWPKgC.jpg", voteAverage: 7.5, releaseDate: "2025-01-01")
    
    static var mockList: [MovieDataModel] = [
        
        MovieDataModel(originalTitle: "Sonic the Hedgehog 3", originalLanguage: "en", overview: "Sonic, Knuckles, and Tails reunite against a powerful new adversary, Shadow, a mysterious villain with powers unlike anything they have faced before. With their abilities outmatched in every way, Team Sonic must seek out an unlikely alliance in hopes of stopping Shadow and protecting the planet.", posterPath: "/d8Ryb8AunYAuycVKDp5HpdWPKgC.jpg", voteAverage: 7.5, releaseDate: "2025-01-01"),
        MovieDataModel(originalTitle: "Sonic the Hedgehog 3", originalLanguage: "en", overview: "Sonic, Knuckles, and Tails reunite against a powerful new adversary, Shadow, a mysterious villain with powers unlike anything they have faced before. With their abilities outmatched in every way, Team Sonic must seek out an unlikely alliance in hopes of stopping Shadow and protecting the planet.", posterPath: "/d8Ryb8AunYAuycVKDp5HpdWPKgC.jpg", voteAverage: 7.5, releaseDate: "2025-01-01"),
        MovieDataModel(originalTitle: "Sonic the Hedgehog 3", originalLanguage: "en", overview: "Sonic, Knuckles, and Tails reunite against a powerful new adversary, Shadow, a mysterious villain with powers unlike anything they have faced before. With their abilities outmatched in every way, Team Sonic must seek out an unlikely alliance in hopes of stopping Shadow and protecting the planet.", posterPath: "/d8Ryb8AunYAuycVKDp5HpdWPKgC.jpg", voteAverage: 7.5, releaseDate: "2025-01-01"),
        MovieDataModel(originalTitle: "Sonic the Hedgehog 3", originalLanguage: "en", overview: "Sonic, Knuckles, and Tails reunite against a powerful new adversary, Shadow, a mysterious villain with powers unlike anything they have faced before. With their abilities outmatched in every way, Team Sonic must seek out an unlikely alliance in hopes of stopping Shadow and protecting the planet.", posterPath: "/d8Ryb8AunYAuycVKDp5HpdWPKgC.jpg", voteAverage: 7.5, releaseDate: "2025-01-01"),
        MovieDataModel(originalTitle: "Sonic the Hedgehog 3", originalLanguage: "en", overview: "Sonic, Knuckles, and Tails reunite against a powerful new adversary, Shadow, a mysterious villain with powers unlike anything they have faced before. With their abilities outmatched in every way, Team Sonic must seek out an unlikely alliance in hopes of stopping Shadow and protecting the planet.", posterPath: "/d8Ryb8AunYAuycVKDp5HpdWPKgC.jpg", voteAverage: 7.5, releaseDate: "2025-01-01"),
        MovieDataModel(originalTitle: "Sonic the Hedgehog 3", originalLanguage: "en", overview: "Sonic, Knuckles, and Tails reunite against a powerful new adversary, Shadow, a mysterious villain with powers unlike anything they have faced before. With their abilities outmatched in every way, Team Sonic must seek out an unlikely alliance in hopes of stopping Shadow and protecting the planet.", posterPath: "/d8Ryb8AunYAuycVKDp5HpdWPKgC.jpg", voteAverage: 7.5, releaseDate: "2025-01-01"),
        MovieDataModel(originalTitle: "Sonic the Hedgehog 3", originalLanguage: "en", overview: "Sonic, Knuckles, and Tails reunite against a powerful new adversary, Shadow, a mysterious villain with powers unlike anything they have faced before. With their abilities outmatched in every way, Team Sonic must seek out an unlikely alliance in hopes of stopping Shadow and protecting the planet.", posterPath: "/d8Ryb8AunYAuycVKDp5HpdWPKgC.jpg", voteAverage: 7.5, releaseDate: "2025-01-01")
        
    ]
    
    static var topRatedMockList: [MovieDataModel] = [
        MovieDataModel(originalTitle: "The Shawshank Redemption", originalLanguage: "en", overview: "To stop an arms dealer from unleashing a deadly superweapon, Ace sniper Brandon Beckett and Agent Zero are deployed to Costa Verde to lead a group of elite soldiers against an unrelenting militia. Taking an untested sniper under his wing, Beckett faces his newest challenge: giving orders instead of receiving them. With both time and ammo running low in a race to save humanity, the team must overcome all odds just to survive.", posterPath: "/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg", voteAverage: 6.656, releaseDate: "2025-01-21"),
        MovieDataModel(originalTitle: "The Shawshank Redemption", originalLanguage: "en", overview: "To stop an arms dealer from unleashing a deadly superweapon, Ace sniper Brandon Beckett and Agent Zero are deployed to Costa Verde to lead a group of elite soldiers against an unrelenting militia. Taking an untested sniper under his wing, Beckett faces his newest challenge: giving orders instead of receiving them. With both time and ammo running low in a race to save humanity, the team must overcome all odds just to survive.", posterPath: "/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg", voteAverage: 6.656, releaseDate: "2025-01-21"),
        MovieDataModel(originalTitle: "The Shawshank Redemption", originalLanguage: "en", overview: "To stop an arms dealer from unleashing a deadly superweapon, Ace sniper Brandon Beckett and Agent Zero are deployed to Costa Verde to lead a group of elite soldiers against an unrelenting militia. Taking an untested sniper under his wing, Beckett faces his newest challenge: giving orders instead of receiving them. With both time and ammo running low in a race to save humanity, the team must overcome all odds just to survive.", posterPath: "/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg", voteAverage: 6.656, releaseDate: "2025-01-21"),
        MovieDataModel(originalTitle: "The Shawshank Redemption", originalLanguage: "en", overview: "To stop an arms dealer from unleashing a deadly superweapon, Ace sniper Brandon Beckett and Agent Zero are deployed to Costa Verde to lead a group of elite soldiers against an unrelenting militia. Taking an untested sniper under his wing, Beckett faces his newest challenge: giving orders instead of receiving them. With both time and ammo running low in a race to save humanity, the team must overcome all odds just to survive.", posterPath: "/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg", voteAverage: 6.656, releaseDate: "2025-01-21"),
        MovieDataModel(originalTitle: "The Shawshank Redemption", originalLanguage: "en", overview: "To stop an arms dealer from unleashing a deadly superweapon, Ace sniper Brandon Beckett and Agent Zero are deployed to Costa Verde to lead a group of elite soldiers against an unrelenting militia. Taking an untested sniper under his wing, Beckett faces his newest challenge: giving orders instead of receiving them. With both time and ammo running low in a race to save humanity, the team must overcome all odds just to survive.", posterPath: "/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg", voteAverage: 6.656, releaseDate: "2025-01-21"),
        
        
    ]
    
    
    static var upComingMockList: [MovieDataModel] = [
        MovieDataModel(originalTitle: "Alarum", originalLanguage: "en", overview: "To stop an arms dealer from unleashing a deadly superweapon, Ace sniper Brandon Beckett and Agent Zero are deployed to Costa Verde to lead a group of elite soldiers against an unrelenting militia. Taking an untested sniper under his wing, Beckett faces his newest challenge: giving orders instead of receiving them. With both time and ammo running low in a race to save humanity, the team must overcome all odds just to survive.", posterPath: "/ckyYZf5cGTSOwF8LWIRqeThyh18.jpg", voteAverage: 6.656, releaseDate: "2025-01-21"),
        MovieDataModel(originalTitle: "Alarum", originalLanguage: "en", overview: "To stop an arms dealer from unleashing a deadly superweapon, Ace sniper Brandon Beckett and Agent Zero are deployed to Costa Verde to lead a group of elite soldiers against an unrelenting militia. Taking an untested sniper under his wing, Beckett faces his newest challenge: giving orders instead of receiving them. With both time and ammo running low in a race to save humanity, the team must overcome all odds just to survive.", posterPath: "/ckyYZf5cGTSOwF8LWIRqeThyh18.jpg", voteAverage: 6.656, releaseDate: "2025-01-21"),
        MovieDataModel(originalTitle: "Alarum", originalLanguage: "en", overview: "To stop an arms dealer from unleashing a deadly superweapon, Ace sniper Brandon Beckett and Agent Zero are deployed to Costa Verde to lead a group of elite soldiers against an unrelenting militia. Taking an untested sniper under his wing, Beckett faces his newest challenge: giving orders instead of receiving them. With both time and ammo running low in a race to save humanity, the team must overcome all odds just to survive.", posterPath: "/ckyYZf5cGTSOwF8LWIRqeThyh18.jpg", voteAverage: 6.656, releaseDate: "2025-01-21"),
        MovieDataModel(originalTitle: "Alarum", originalLanguage: "en", overview: "To stop an arms dealer from unleashing a deadly superweapon, Ace sniper Brandon Beckett and Agent Zero are deployed to Costa Verde to lead a group of elite soldiers against an unrelenting militia. Taking an untested sniper under his wing, Beckett faces his newest challenge: giving orders instead of receiving them. With both time and ammo running low in a race to save humanity, the team must overcome all odds just to survive.", posterPath: "/ckyYZf5cGTSOwF8LWIRqeThyh18.jpg", voteAverage: 6.656, releaseDate: "2025-01-21"),
        MovieDataModel(originalTitle: "Alarum", originalLanguage: "en", overview: "To stop an arms dealer from unleashing a deadly superweapon, Ace sniper Brandon Beckett and Agent Zero are deployed to Costa Verde to lead a group of elite soldiers against an unrelenting militia. Taking an untested sniper under his wing, Beckett faces his newest challenge: giving orders instead of receiving them. With both time and ammo running low in a race to save humanity, the team must overcome all odds just to survive.", posterPath: "/ckyYZf5cGTSOwF8LWIRqeThyh18.jpg", voteAverage: 6.656, releaseDate: "2025-01-21"),
        MovieDataModel(originalTitle: "Alarum", originalLanguage: "en", overview: "To stop an arms dealer from unleashing a deadly superweapon, Ace sniper Brandon Beckett and Agent Zero are deployed to Costa Verde to lead a group of elite soldiers against an unrelenting militia. Taking an untested sniper under his wing, Beckett faces his newest challenge: giving orders instead of receiving them. With both time and ammo running low in a race to save humanity, the team must overcome all odds just to survive.", posterPath: "/ckyYZf5cGTSOwF8LWIRqeThyh18.jpg", voteAverage: 6.656, releaseDate: "2025-01-21"),
        
        
    ]
}
