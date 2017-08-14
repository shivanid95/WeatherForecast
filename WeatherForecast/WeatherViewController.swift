//
//  WeatherViewController.swift
//  WeatherForecast
//
//  Created by Shivani Dosajh on 08/08/17.
//  Copyright © 2017 Shivani Dosajh. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, iCarouselDelegate, iCarouselDataSource {
    
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var latitudeLabel: UILabel!
    @IBOutlet private weak var longitudeLabel: UILabel!
    @IBOutlet weak var carouselView: iCarousel!
    
    
    private var weatherArray:[[String:AnyObject]]!
    private var cityData:[String:AnyObject]?
    
    
    
// MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        carouselView.type = .coverFlow2
        configureCityValues()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "weatherBackground.jpeg")!)
        
    }
    
    override func awakeFromNib() {
        
        weatherArray = WeatherDataModel.sharedInstance.getWeatherList()
        cityData =  WeatherDataModel.sharedInstance.getCityInfo()
        
    }

    
    func configureCityValues()
    {
        if let item = cityData?["city"] as? [String:AnyObject], let value = item["name"] as? String
        {
            cityLabel.text = value
            
            if let element = item["coord"] as? [String: AnyObject], let val1 = element["lat"] as? Double , let val2 = element["lon"] as? Double {
                latitudeLabel.text = "Latitude : \(val1)"
                longitudeLabel.text = "Longitude : \(val2)"
            }
        }
    }
    
   @IBAction func convertTempratureUnit(_ sender: UIButton) {
        
        
        if(WeatherDataModel.sharedInstance.isCelcius)
        {
            sender.setTitle("Convert to °C", for: .normal)
        }
        else{
            sender.setTitle("Convert to °F", for: .normal)
        }
        WeatherDataModel.sharedInstance.isCelcius = !WeatherDataModel.sharedInstance.isCelcius
        carouselView.reloadData() ;
        
    }
    
    
//MARK: Carousel Datasource
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        
        return weatherArray.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        var tempView: CustomCarouselTemplate!
        if(tempView == nil)
        {
            tempView = CustomCarouselTemplate(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
            //  tempView.initializeSubviews()
        }
        
        tempView.populateData(withData: weatherArray[index] )
        
        return tempView
        
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if( option == iCarouselOption.spacing)
        {
            return value*1.1
        }
        return value
    }
    
}
