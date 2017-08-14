//
//  URLObject.swift
//  WeatherForecast
//
//  Created by Shivani Dosajh on 06/08/17.
//  Copyright © 2017 Shivani Dosajh. All rights reserved.
//

import UIKit

class URLObject: NSObject {
    
    private var baseURL = "http://api.openweathermap.org/data/2.5/forecast?"
    private  var latitudeInfo: String!
    private  var longitudeInfo: String?
    private  let apiKey = "&appid=82d316e8e5b1aaac532f77fea9e766b4"
    
    init(latitude: Double, longitude: Double)
    {
        latitudeInfo = String(latitude)
        longitudeInfo = String(longitude)
        super.init()
    }
    
    func getURLString()->String?
    {
        if let lat = latitudeInfo, let lon = longitudeInfo
        {
            return baseURL+"lat="+lat+"&lon="+lon+apiKey
        }
        else
        {  return nil }
    }
    
    
}
