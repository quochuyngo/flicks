//
//  TopRatedViewController.swift
//  Flicks
//
//  Created by Quoc Huy Ngo on 10/14/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import MBProgressHUD

class TopRatedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var movies:[Movie] = [Movie]()
    @IBOutlet weak var topRatedTableView: UITableView!
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topRatedTableView.delegate = self
        self.topRatedTableView.dataSource = self
        MBProgressHUD.showAdded(to: self.view, animated: true)
        loadMovies()
        refreshControl.addTarget(self, action: #selector(MoviesViewController.refreshData(refreshControl:)), for: UIControlEvents.valueChanged)
        topRatedTableView.insertSubview(refreshControl, at: 0)
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
    
    @IBAction func onTapScreen(_ sender: AnyObject) {
        self.view.endEditing(true)
    }
    func loadMovies(){
        
        let request = URLRequest(
            url: URL(string:URLs.TOPRATED_URL + URLs.API_KEY)!,
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
                                        //self.viewAlert.isHidden = true
                                        self.topRatedTableView.reloadData()
                                        self.refreshControl.endRefreshing()
                                    }
                                }
                                //Network problems
                                if error != nil{
                                    //self.viewAlert.isHidden = false
                                }
                                MBProgressHUD.hide(for: self.view, animated: true)
                                
            })
        task.resume()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = self.topRatedTableView.indexPathForSelectedRow?.row
        let details = segue.destination as! DetailsViewController
        details.movie = movies[index!]
    }
    
    func refreshData(refreshControl:UIRefreshControl){
        loadMovies()
    }
}
