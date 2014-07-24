//
//  MovieSelectionViewController.swift
//  MovieLookUp
//
//  Created by Dan Isacson on 16/07/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit
import CoreData

class MovieSelectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    //Variables
    var movies : [Movie] = []
    
    @IBOutlet var movieCollectionView: UICollectionView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        setUpMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        var movieViewController: MovieViewController = segue.destinationViewController as MovieViewController
        let movieIndex = movieCollectionView.indexPathForCell(sender as UICollectionViewCell).row
        var selectedMovie = self.movies[movieIndex]
        movieViewController.movie = selectedMovie
    }
    
    func setUpMovies(){
        movies = []
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context : NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "MovieSelection")
        request.returnsObjectsAsFaults = false
        
        var results : NSArray = context.executeFetchRequest(request, error: nil)
        if( results.count > 0){
            println(results.count)
            for res in results{
                let movie : Movie = Movie()
                movie.imgURL = (res as MovieSelection).posterurl
                movie.bgURL = movie.imgURL
                movie.title = (res as MovieSelection).name
                movie.id = (res as MovieSelection).id.toInt()
                movies.append(movie)
            }
        }else
        {
        }
        
        for movie in movies{
            println(movie.title)
        }
        movieCollectionView.reloadData()
    }

    
    //CollectionView
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int
    {
        return movies.count
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell!
    {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieSelectionCell", forIndexPath: indexPath) as UICollectionViewCell
        
        let movie: Movie = movies[indexPath.row]
        
        let poster: UIImageView = cell.viewWithTag(300) as UIImageView
        
        if let url = movie.imgURL {
            poster.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "default.jpeg"))
        }else {
            poster.image = UIImage(named: "default.jpeg")
        }
        return cell
    }
    
    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}