//
//  MapViewController.swift
//  WeatherForecast
//
//  Created by Shivani Dosajh on 06/08/17.
//  Copyright © 2017 Shivani Dosajh. All rights reserved.
//

import UIKit
import MapKit
import  CoreLocation

class MapViewController: UIViewController , MKMapViewDelegate , CLLocationManagerDelegate{
    // To get the pin for location
    private var pointAnnotation:MKPointAnnotation!
    private var pinAnnotationView:MKPinAnnotationView!
    
    // URL string for calling the API
    private var requestString :String? = ""
    
    // To get the user's current location
    let locationManager = CLLocationManager()
    var initialLocation : CLLocation!
    
    var flag = true
    // MARK: view life cyle methods
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.distanceFilter = 3000
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        configureInitialPinLocation()
        initializeAPIData()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        initialLocation = CLLocation(latitude: manager.location!.coordinate.latitude, longitude: manager.location!.coordinate.longitude)
        
        configureInitialPinLocation()
        
        fetchPinLocation(cordinate: manager.location!.coordinate)

        print("locations = \(initialLocation.coordinate.latitude) \(initialLocation.coordinate.longitude)")
        
    }
    
    // MARK: Initialization Functions
    
    func configureInitialPinLocation()
    {
        if initialLocation == nil{
            initialLocation = CLLocation(latitude: 28.7 , longitude: 77.1025)
        }
        
          if self.mapView.annotations.count > 0{
         self.mapView.removeAnnotation(self.pinAnnotationView.annotation!)
         }
        
        // setting up location pin  and visible map region
        self.pointAnnotation =  MKPointAnnotation()
        
        let regionRadius: CLLocationDistance = 3000
        self.pointAnnotation.coordinate = initialLocation.coordinate
        self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate,regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        
        self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        self.pointAnnotation.title = "Location"
        self.pointAnnotation.subtitle = "(\(self.pointAnnotation.coordinate.latitude), \(self.pointAnnotation.coordinate.longitude))"
        
    }
    
    func initializeAPIData()
    {
        if (requestString?.isEmpty )!
        {
            let request = URLObject(latitude: self.pointAnnotation.coordinate.latitude , longitude: self.pointAnnotation.coordinate.longitude)
            self.requestString = request.getURLString()!
        }
        WeatherDataModel.sharedInstance.setWeatherData(urlString: requestString!)
        
    }
    
    // MARK: Map View Delegate Methods
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
        switch newState {
        case .starting:
            view.dragState = .dragging
        case .ending, .canceling:
            view.dragState = .none
            
        default: break
        }
        // Set up after drag ends
        if(view.dragState == .none)
        {
            fetchPinLocation(cordinate: (view.annotation?.coordinate)!)
            self.pointAnnotation.title = "Location"
            self.pointAnnotation.subtitle = "(\(self.pointAnnotation.coordinate.latitude), \(self.pointAnnotation.coordinate.longitude))"
        }
    }
    
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        self.pinAnnotationView.isDraggable = true
        self.pinAnnotationView.canShowCallout = true
        return self.pinAnnotationView
    }
    
    //MARK:-  Fetching Location
    /* To retrieve the current location after any change
     */
    
    func fetchPinLocation(cordinate:CLLocationCoordinate2D){
        
        let request = URLObject(latitude: cordinate.latitude , longitude: cordinate.longitude)
        requestString = request.getURLString()
        WeatherDataModel.sharedInstance.setWeatherData(urlString: requestString!)
        
        // print(requestString ?? "fetch request")
        
    }
    
}

