//
//  MovieListViewModelTests.swift
//  iOSTestTask
//
//  Created by Zhanna Komar on 09.12.2023.
//

import XCTest
@testable import iOSTestTask

final class MovieListViewModelTests: XCTestCase {
    let sut = MovieListViewModel()
    
    func testFetchMoviesWithSuccessResult() {
        let expectation = XCTestExpectation()
        var actualResult = [Movie]()
        sut.fetchMovies { result in
            switch result {
            case .success(let movies):
                actualResult = movies
                expectation.fulfill()
            case .failure(_):
                XCTFail("Method should return success result")
            }
        }
        wait(for: [expectation], timeout: 5)
        XCTAssertTrue(!actualResult.isEmpty)
        XCTAssertTrue(actualResult.count == 20)
    }
    
    func testGetImageSuccess() {
        let expectation = XCTestExpectation()
        sut.fetchMovies {result in
            switch result {
            case .success(_):
                expectation.fulfill()
            case .failure(_):
                XCTFail("Method should return success result")
            } }
        wait(for: [expectation], timeout: 5)
        var actualResult = sut.getImageData(by: 0)
        XCTAssertTrue(actualResult != nil)
    }
    
    func testGetImageFail() {
        var actualResult = sut.getImageData(by: 0)
        XCTAssertTrue(actualResult == nil)
    }
}
