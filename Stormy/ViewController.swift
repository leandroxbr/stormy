//
//  ViewController.swift
//  Stormy
//
//  Created by Leandro Alves De Souza on 09/11/14.
//  Copyright (c) 2014 Leandro Alves De Souza. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let apiKey:String = "1e1bddc152a80f511722a4320eebc14f"
    
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshActivityButton: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refreshActivityButton.hidden = true

        getCurrentWeatherData()
    }

    func getCurrentWeatherData(){
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        let forecastURL = NSURL(string: "-23.6354704,-46.5077589", relativeToURL: baseURL)
        
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask:NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(
            forecastURL!,
            completionHandler: {
                (location: NSURL!, response:NSURLResponse!, error:NSError!) -> Void in
                
                if (error == nil){
                    let dataObject = NSData(contentsOfURL: location, options: nil, error: nil)
                    let weatherDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as NSDictionary
                    
                    let currentWeather = CurrentWeather(weatherDictionary: weatherDictionary)
                    
                    dispatch_async(dispatch_get_main_queue(),{ () -> Void in
                        self.temperatureLabel.text = "\(currentWeather.temperature!)"
                        self.currentTimeLabel.text = "At \(currentWeather.currentTime!)"
                        self.precipitationLabel.text = "\(currentWeather.precipProbability)%"
                        self.summaryLabel.text = "\(currentWeather.summary)"
                        self.humidityLabel.text = "\(currentWeather.humidity)%"
                        self.iconView.image = currentWeather.icon!
                        
                        self.stopRefresh()
                    })
                } else {
                    let networkIssueController = UIAlertController(title: "Error", message: "Unable to load data. Check your internet connection.", preferredStyle: .Alert)
                    
                    let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)

                    networkIssueController.addAction(okButton)
                    networkIssueController.addAction(cancelButton)

                    self.presentViewController(networkIssueController, animated: true, completion: nil)

                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.stopRefresh()
                    })
                }
            }
        )
        downloadTask.resume()
    }
    
    func stopRefresh(){
        self.refreshActivityButton.hidden = true
        self.refreshActivityButton.stopAnimating()
        self.refreshButton.hidden = false
    }
    
    @IBAction func refresh(sender: AnyObject) {
        self.refreshActivityButton.hidden = false
        self.refreshActivityButton.startAnimating()
        self.refreshButton.hidden = true
        getCurrentWeatherData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}