//
//  MovieDetailedViewController.swift
//  TrendingMovies
//
//  Created by Магжан Бекетов on 23.04.2021.
//

import UIKit
import Alamofire
import Kingfisher

class MovieDetailedViewController: UIViewController {
    
    public var idOfMovie : Int?
    private var details : MovieDetailedModel?
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var ratingView: UIView!
    @IBOutlet private weak var rattingLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var releaseDate: UILabel!
    @IBOutlet private weak var goBackButton: UIButton!
    @IBOutlet weak var textViewDesc: UITextView!
    @IBOutlet private weak var favoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ratingView.layer.cornerRadius = 20
        ratingView.layer.masksToBounds = true
        
        goBackButton.layer.cornerRadius = 10
        getDetailedInformation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let movieId = idOfMovie{
            if let _ = CoreDataManager.shared.findMovie(with: movieId){
                favoriteButton.setImage(UIImage(named:"starFilled"), for: .normal)
            }else{
                favoriteButton.setImage(UIImage(named: "star"), for: .normal)
            }
        }
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        if let movieId = idOfMovie{
            if let _ = CoreDataManager.shared.findMovie(with: movieId){
                CoreDataManager.shared.deleteMovie(with: movieId)
                favoriteButton.setImage(UIImage(named:"star"), for: .normal)
            }else{
                if var details = details{
                    details.id = movieId
                    CoreDataManager.shared.addMovie(details)
                    favoriteButton.setImage(UIImage(named: "starFilled"), for: .normal)
                }
            }
        }
    }
}

extension MovieDetailedViewController {
    private func getDetailedInformation(){
        if let id = idOfMovie{
        AF.request("\(Constants.DETAILED_MOVIE_URL)\(id)\(Constants.API_KEY)", method: .get, parameters: [:]).responseJSON { [weak self] (response) in
            switch response.result {
            case .success :
                
                if let data = response.data {
                    do{
                        
                        let movieJSON = try JSONDecoder().decode(MovieDetailedModel.self, from: data)
                        var movie : MovieDetailedModel?
                        movie = movieJSON
                        if let movie = movie{
                            self?.details = movie
                            self?.setData(movie)
                        }
                        
                        //                        print(".... \(movie)")
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
    
    
    private func setData(_ movie : MovieDetailedModel){
        
        guard let poster = movie.poster else {
            print("... poster nil")
            return
        }
        
        let url = URL(string: "https://image.tmdb.org/t/p/w300\(poster)")
        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 20)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(3)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
        
        rattingLabel.text = "\(movie.rating)"
        titleLabel.text = movie.title
        releaseDate.text = movie.releaseDate
        textViewDesc.text = movie.description
    }
}
