//
//  ViewController.swift
//  TrendingMovies
//
//  Created by Магжан Бекетов on 20.04.2021.
//

import UIKit
import Alamofire

class TrendingMoviesViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
    
    private var movies : [MovieModel.Movie] = [MovieModel.Movie]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.register(MovieCell.nib, forCellReuseIdentifier: MovieCell.identifier)
        
        
        
        getTrendingMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
}

//MARK: - Internal function
extension TrendingMoviesViewController {
    private func getTrendingMovies() {
        AF.request("\(Constants.TRENDING_MOVIES_URL)\(Constants.API_KEY)", method: .get, parameters: [:]).responseJSON { (response) in
            switch response.result {
            case .success :
                if let data = response.data {
                    do{
                     
                        let movieJSON = try JSONDecoder().decode(MovieModel.self, from: data)
                        self.movies = movieJSON.results
                        print(".....\(self.movies)")
                    }catch let JSONError{
                        print(JSONError)
                    }
                }
            case .failure :
                print("TRENDING_MOVIES_URL retrive data")
            }
        }
    }
}

//MARK: - UITableViewDelegate
extension TrendingMoviesViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("taped \(indexPath)")
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailedViewController") as! MovieDetailedViewController
        vc.idOfMovie = movies[indexPath.row].id
        //print("...... movies[indexPath.row].id \(movies[indexPath.row].id)")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

//MARK: - UITableViewDataSource
extension TrendingMoviesViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        
        cell.movie = movies[indexPath.row]
        
        return cell
    }
    
}

