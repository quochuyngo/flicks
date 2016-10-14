//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Quoc Huy Ngo on 10/13/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var alertLabel: UILabel!
    var movies:[Movie] = [Movie]()
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        alertLabel.isHidden = true
        
        self.movieTableView.dataSource = self
        self.movieTableView.delegate = self
        
        loadMovies()
        refreshControl.addTarget(self, action: #selector(MoviesViewController.refreshData(refreshControl:)), for: UIControlEvents.valueChanged)
        movieTableView.insertSubview(refreshControl, at: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        let index = indexPath.row
        if let posterURL = movies[index].poster{
            cell.posterImageView.setImageWith(URL(string:URLs.POSTER_BASE_URL + posterURL)!)
        }
        cell.movieTitleLabel.text = self.movies[index].title
        cell.movieOverviewLabel.text = self.movies[index].overview
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = self.movieTableView.indexPathForSelectedRow?.row
        let details = segue.destination as! DetailsViewController
        details.movie = movies[index!]
    }
    
    func refreshData(refreshControl:UIRefreshControl){
        loadMovies()
    }
    func loadMovies(){
        
        let request = URLRequest(
            url: URL(string:URLs.URL + URLs.API_KEY)!,
            cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        let task: URLSessionDataTask =
            session.dataTask(with: request,
                             completionHandler: { (dataOrNil, response, error) in
                                if let data = dataOrNil {
                                    if let responseDictionary = try! JSONSerialization.jsonObject(
                                        with: data, options:[]) as? NSDictionary {
                                        let results = responseDictionary["results"] as? [NSDictionary]
                                        for data in results!{
                                            let movie = Movie(data: data)
                                            self.movies.append(movie)
                                        }
                                        self.alertLabel.isHidden = true
                                        self.movieTableView.reloadData()
                                        self.refreshControl.endRefreshing()
                                    }
                                }
                                //Network problems
                                if error != nil{
                                    self.alertLabel.isHidden = false
                                }
                                MBProgressHUD.hide(for: self.view, animated: true)
                                
            })
        task.resume()
    }
}
