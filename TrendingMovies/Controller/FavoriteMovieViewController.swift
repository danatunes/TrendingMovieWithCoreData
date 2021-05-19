//
//  FavoriteMovieViewController.swift
//  TrendingMovies
//
//  Created by Магжан Бекетов on 17.05.2021.
//

import UIKit

class FavoriteMovieViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private var movies : [MovieModel.Movie] = [] {
        didSet{
            if movies.count != oldValue.count{
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MovieCell.nib, forCellReuseIdentifier: MovieCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAllFavoriteMovies()
    }
    
    private func fetchAllFavoriteMovies(){
        movies = CoreDataManager.shared.allMovies()
    }
    
}

extension FavoriteMovieViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        cell.movie = movie
        cell.delegate = self
        return cell
    }
}

extension FavoriteMovieViewController : MovieCellProtocol{
    func reloadStarFromFavorite() {
        fetchAllFavoriteMovies()
    }
}
