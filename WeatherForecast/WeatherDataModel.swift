//
//  WeatherDataModel.swift
//  WeatherForecast
//
//  Created by Shivani Dosajh on 07/08/17.
//  Copyright © 2017 Shivani Dosajh. All rights reserved.
//

import UIKit

class WeatherDataModel: NSObject {
    
    /* This is a Singleton Class */
    
    static let sharedInstance = WeatherDataModel()
    private var cityDictionary = [String: AnyObject]()
    private var  weatherListArray = [Dictionary<String, AnyObject>]()
    public var isCelcius:Bool = true
    // MARK: Initialization
    
    private override init() {
        super.init()
    }
    
    // MARK: Retrieving Data
    // returns dictionary of city values
    func getCityInfo() -> [String: AnyObject]      {
        return cityDictionary
    }
    // returns arrayo of weather data dictionaries
    func getWeatherList() -> [Dictionary<String, AnyObject>] {
        return weatherListArray
    }
    // makes API call for the imput URL and parses the json data
    func setWeatherData(urlString: String){
        
        jsonParser(urlString: urlString)
        
    }
    
    
    // MARK: JSON Parsing
    
    private var jsonData: Any?
    func jsonParser(urlString: String)
    {
        // Make API Call for the url session
        if let url = URL(string: urlString)
        {
            let task = URLSession.shared.dataTask(with: url){ (data, response , error) in
                if (error != nil)
                {
                    print(error!.localizedDescription)
                }
                else if data != nil
                {  DispatchQueue.main.async(execute:{self.getMeaningfulDataFromRawData(data: data!)} )}
            }
            
            task.resume()
            
        }
        
    }
    
    func getMeaningfulDataFromRawData(data:Data){
        
        var json: Any?
        do {
            json = try JSONSerialization.jsonObject(with: data)
            if json != nil
            {
                self.jsonData = json!
            }
            
        } catch {
            print(error)
        }
        // Getting the requires data
        if let dict = self.jsonData as? Dictionary<String, AnyObject>
        {
            if let city = dict["city"] as? Dictionary<String, AnyObject>
            {
                self.cityDictionary.updateValue(city as AnyObject,forKey: "city")
            }
            
            if let listData = dict["list"]
            {
                weatherListArray = listData as! Array<[String: AnyObject]>
            }
            
        }
        
    }
    
    
}
