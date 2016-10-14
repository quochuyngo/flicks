//
//  DetailsViewController.swift
//  Flicks
//
//  Created by Quoc Huy Ngo on 10/13/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import AFNetworking

class DetailsViewController: UIViewController {
    var movie:Movie!
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!

    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var oldLabelSize:Float = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //scrollView.contentSize.width = scrollView.frame.size.width
        //scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: overviewRect.origin.y + overviewRect.size.height + 10)
        oldLabelSize = Float(overviewLabel.frame.size.height)
        setData()
    }
    
    func setData(){
        if let posterURL = movie.poster{
            self.posterImageView.setImageWith(URL(string: URLs.POSTER_BASE_URL + posterURL)!)
        }
        self.overviewLabel.text = movie.overview
        self.titleLabel.text = movie.title
        self.popularityLabel.text = String(format:"%2.0f%%",movie.popularity)
        self.voteAverageLabel.text = String(format:"%1.1f", movie.voteAverage)
        self.overviewLabel.sizeToFit()
        let overviewRect = self.overviewLabel.frame;
        let height = overviewRect.origin.y + overviewRect.size.height + 360
        scrollView.contentSize.height = height
        self.detailsView.sizeToFit()
    }
}
