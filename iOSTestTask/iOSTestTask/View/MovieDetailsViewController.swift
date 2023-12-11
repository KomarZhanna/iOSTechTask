//
//  MovieDetailsViewController.swift
//  iOSTestTask
//
//  Created by Zhanna Komar on 09.12.2023.
//

import Foundation
import UIKit

protocol TopRatedViewControllerDelegate: AnyObject {
    func didSelectMovie(movie: Movie, row: Int)
}

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var moviePosterImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var occurrencesLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    
    var movie: Movie?
    var row: Int?
    var movieImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let movieImage = movieImage{
            moviePosterImage.image = movieImage
        }
        movieTitleLabel.text = movie?.title
        movieOverviewLabel.text = movie?.overview
        occurrencesLabel.text = self.countOccurrencesOfCharacters(in: movie?.title ?? "")
    }
    
    private func countOccurrencesOfCharacters(in text: String) -> String {
        var characterCounts = [Character: Int]()

        for char in text.lowercased() {
            characterCounts[char, default: 0] += 1
        }

        let sortedCharactersCount = characterCounts.sorted { $0.key < $1.key }

        let stringResult = sortedCharactersCount.reduce(into: "") { result, pair in
            result.append("\"\(pair.key)\": \(pair.value),\n")
        }
        return stringResult
    }
}
