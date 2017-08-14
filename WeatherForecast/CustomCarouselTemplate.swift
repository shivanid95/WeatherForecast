//
//  CustomCarouselTemplate.swift
//  WeatherForecast
//
//  Created by Shivani Dosajh on 08/08/17.
//  Copyright © 2017 Shivani Dosajh. All rights reserved.
//

import UIKit

protocol CustomCarouselTemplateDelegate: class {
    func changeTempratureUnit(toCelius celsius:Bool , forIndex index:Int)
}

class CustomCarouselTemplate: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet  private weak var pressureLabel: UILabel!
    @IBOutlet private weak var tempratureLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet  private weak var imageIcon: UIImageView!
    
    // overriding initializer to load view with nib
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("CustomCarouselTemplate", owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
    }
    //MARK: Data Computation
    
    /*
     * To populate the carousel view with the weather data
     *  @param data dictionary containing weather information
     */
    func populateData(withData data:[String: AnyObject])
    {
        
        let dateAndTime = (data["dt_txt"] as? String)?.components(separatedBy: " ")
        dateLabel.text = dateAndTime?[0]
        timeLabel.text = dateAndTime?[1]
        
        if let item = data["main"] as? [String: AnyObject]
        {
            if let val = item["temp"] as? Double {
                let tempVal = convertTempratureUnit(toCelsius: WeatherDataModel.sharedInstance.isCelcius, forTemprature: val)
                
                let unitSymbol =  WeatherDataModel.sharedInstance.isCelcius ? "°C":"°F "
                tempratureLabel.text = "\(tempVal) \(unitSymbol)"
            }
            else{
                tempratureLabel.text = ""
            }
            
            if let val = item["humidity"] as? Float{
                humidityLabel.text = "\(val)"
            }
            else{
                humidityLabel.text = "humid"
            }
            
            if let val = item["pressure"] as? Float{
                pressureLabel.text = "\(val)"
            }
            else{
                pressureLabel.text = "pressure"
            }
        }

        if let item = data["weather"]?[0] as? [String: AnyObject] , let icon = item["icon"] as? String,let description = item["description"] as? String
        {
           descriptionLabel.text = description
            let weatherIconString = icon
            let imageUrl = "https://openweathermap.org/img/w/\(weatherIconString).png"
            let url = URL(string: imageUrl)
            
            do{
                let imageData = try Data(contentsOf:url!)
                imageIcon.image = UIImage(data: imageData)
            }
            catch{  print("invalid  url") }
        }
        
        
    }
    /* func to convert the temprature units (to Farenhiet/ Celsius)
     * Aparam isCelsius : returns true if celsius selected
     */
    
    func convertTempratureUnit(toCelsius isCelsius:Bool , forTemprature temp:Double?) -> Double
    {
        let value = isCelsius ?temp! - 273 : 9.0/5 * (temp! - 273) + 32
        return value
    }
    
    
    
}
