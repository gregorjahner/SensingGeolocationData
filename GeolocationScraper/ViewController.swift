//
//  ViewController.swift
//  GeolocationScraper
//
//  Created by Gregor Jahner on 31.10.19.
//  Copyright © 2019 Gregor Jahner. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager:CLLocationManager = CLLocationManager()
    var timer = Timer()
    let frequency:Double = 5.0

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func startTapped(_ sender: Any) {
        print("started location process.")

        //locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        //locationManager.startUpdatingLocation()

        // start the timer
        timer = Timer.scheduledTimer(timeInterval: frequency, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }


    @IBAction func endTapped(_ sender: Any) {
      locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
      /**
      for currentLocation in locations{
        print("locations = \(currentLocation.coordinate)")
        print("altitude = \(currentLocation.altitude)")
        print("timestamp = \(currentLocation.timestamp)")
      }
      */
      if let currentLocation = locations.first{
        print("locations = \(currentLocation.coordinate)")
        print("altitude = \(currentLocation.altitude)")
        print("timestamp = \(currentLocation.timestamp)")
      }
    }

    func timerAction() {
      locationManager.startUpdatingLocation()
      //locationManager.stopUpdatingLocation()
    }


}
