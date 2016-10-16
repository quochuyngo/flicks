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

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var displaySegmented: UISegmentedControl!

    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var viewAlert: UIView!
    var movies:[Movie] = [Movie]()
    let refreshControl = UIRefreshControl()
    var API_URL:String! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        viewAlert.isHidden = true
        
        self.movieTableView.dataSource = self
        self.movieTableView.delegate = self
        self.movieCollectionView.dataSource = self
        self.movieCollectionView.delegate = self
        
        switchViewDisplay()
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

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return movies.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionCell", for: indexPath) as! MovieCollectionViewCell
        let index = indexPath.row
        if let posterURL = movies[index].poster{
            cell.posterImageView.setImageWith(URL(string:URLs.POSTER_BASE_URL + posterURL)!)
        }
        cell.titleLabel.text = self.movies[index].title
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var index:Int
        if displaySegmented.selectedSegmentIndex == 0{
            index = (self.movieTableView.indexPathForSelectedRow?.row)!

        }
        else{
            let cell = sender as! UICollectionViewCell
            index = (self.movieCollectionView.indexPath(for: cell)?.row)!
        }
        let details = segue.destination as! DetailsViewController
        
        details.movie = movies[index]
    }
    
    @IBAction func displaySegmentedChanged(_ sender: AnyObject) {
        switchViewDisplay()
    }
    func refreshData(refreshControl:UIRefreshControl){
        loadMovies()
    }
    func loadMovies(){
        
        let request = URLRequest(
            url: URL(string:API_URL)!,
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
                                        self.viewAlert.isHidden = true
                                        self.movieTableView.reloadData()
                                        self.movieCollectionView.reloadData()
                                        self.refreshControl.endRefreshing()
                                    }
                                }
                                //Network problems
                                if error != nil{
                                    self.viewAlert.isHidden = false
                                }
                                MBProgressHUD.hide(for: self.view, animated: true)
                                
            })
        task.resume()
    }
    
    func switchViewDisplay(){
        if displaySegmented.selectedSegmentIndex == 0{
            self.movieTableView.isHidden = false
            self.movieCollectionView.isHidden = true
        }
        else{
            self.movieTableView.isHidden = true
            self.movieCollectionView.isHidden = false
        }
    }
}
