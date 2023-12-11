//
//  TopRatedViewController.swift
//  iOSTestTask
//
//  Created by Zhanna Komar on 08.12.2023.
//

import UIKit

class TopRatedViewController: UIViewController {
    
    @IBOutlet weak var topRatedTableView: UITableView!
    @IBOutlet weak var movieSearchBar: UISearchBar!
    
    let movieViewModel = MovieListViewModel()
    private var movies = [Movie]()
    weak var delegate: TopRatedViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchMovies()
        movieSearchBar.delegate = self
    }
    
    private func setupTableView() {
        topRatedTableView.delegate = self
        topRatedTableView.dataSource = self
    }
    
    private func fetchMovies() {
        movieViewModel.fetchMovies() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let moviesResult):
                self.movies = moviesResult ?? []
                self.topRatedTableView.reloadData()
            case .failure(let error):
                // Handle error gracefully (show alert, log error, etc.)
                print("Error fetching movies: \(error.localizedDescription)")
            }
        }
    }
    
    private func searchMovies(by keyword: String) {
        movieViewModel.searchMovies(by: keyword) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let moviesResult):
                self.movies = moviesResult ?? []
                self.topRatedTableView.reloadData()
            case .failure(let error):
                // Handle error gracefully (show alert, log error, etc.)
                print("Error fetching movies: \(error.localizedDescription)")
            }
        }
    }
    
    private func configureRatingLabel() -> NSMutableAttributedString{
        let imageAttachment = NSTextAttachment()
        let img = UIImage(systemName: "star.fill")?.withTintColor(.systemYellow)
        let font = UIFont.systemFont(ofSize: 17)
        let mid = font.descender + font.capHeight
        imageAttachment.image = img
        imageAttachment.bounds = CGRect(x: 0, y: font.descender - img!.size.height / 2 + mid + 2, width: img!.size.width, height: img!.size.height)
        
        let fullString = NSMutableAttributedString()
        let imageString = NSAttributedString(attachment: imageAttachment)
        fullString.append(imageString)
        return fullString
    }
}

extension TopRatedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "topMovieCell", for: indexPath) as? TopRatedTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = movies[indexPath.row]
        cell.movieImage.image = movieViewModel.getImageData(for: indexPath.row)
        cell.movieLabel.text = movie.title
        let ratingAttributedString = self.configureRatingLabel()
        ratingAttributedString.append(NSAttributedString(string: String(format: "%.2f/10", movie.vote_average)))
        cell.movieVoteAverage.attributedText = ratingAttributedString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MovieDetailVC") as? MovieDetailsViewController else {
            return
        }
        
        vc.movie = movies[indexPath.row]
        vc.movieImage = movieViewModel.getImageData(for: indexPath.row)
        vc.row = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TopRatedViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        movieSearchBar.becomeFirstResponder()
        if searchText == "" {
            self.fetchMovies()
        } else {
            self.searchMovies(by: searchText)
        }
    }
}
