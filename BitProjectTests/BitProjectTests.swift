//
//  BitProjectTests.swift
//  BitProjectTests
//
//  Created by Shauli Algawi on 03/02/2025.
//

import XCTest
import ComposableArchitecture
@testable import BitProject

final class BitProjectTests: XCTestCase {

    var mock: MovieDataNetworkModel = MovieDataNetworkModel(originalTitle: "Sonic the Hedgehog 3", originalLanguage: "en", overview: "Sonic, Knuckles, and Tails reunite against a powerful new adversary, Shadow, a mysterious villain with powers unlike anything they have faced before. With their abilities outmatched in every way, Team Sonic must seek out an unlikely alliance in hopes of stopping Shadow and protecting the planet.", posterPath: "/d8Ryb8AunYAuycVKDp5HpdWPKgC.jpg", voteAverage: 7.5, releaseDate: "2025-01-01", id: 234545)
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFavoriteToggle() {
        let store = TestStore(initialState: MoviesListReducer.State()) {
            MoviesListReducer()
        }
        
        

    }

}
