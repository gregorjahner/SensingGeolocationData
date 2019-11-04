//
//  ViewController.swift
//  GeolocationScraper
//
//  Created by Gregor Jahner on 31.10.19.
//  Copyright © 2019 Gregor Jahner. All rights reserved.
//

import UIKit
import CoreLocation
import MessageUI


class ViewController: UIViewController, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate {

    let locationManager:CLLocationManager = CLLocationManager()
    var timer = Timer()
    let frequency:Double = 5.0

    let fileName = "test.csv"
    let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(fileName)

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func startTapped(_ sender: Any) {
        var csvText = "Latitude, Longitude, Altitude, Timestamp\n"

        print("started location process.")

        self.locationManager.requestAlwaysAuthorization()
        //self.locationManager.requestWhenInUseAuthorization()

        if (CLLocationManager.locationServicesEnabled()) {
          locationManager.delegate = self
          locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
          locationManager.startUpdatingLocation()
        }

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
      var locValue:CLLocationCoordinate2D = manager.location.coordinate
      print("locations = \(locValue.latitude) \(locValue.longitude)")

      /**
      if let currentLocation = locations.first{
        print("locations = \(currentLocation.coordinate)")
        print("altitude = \(currentLocation.altitude)")
        print("timestamp = \(currentLocation.timestamp)")
        print("")
      }
      */
    }

    @objc func timerAction() {
      /*
      locationManager.startUpdatingLocation()
      //locationManager(_, manager: CLLocationManager, didUpdateLocations, locations: [CLLocation])
      locationManager.stopUpdatingLocation()
      */
      locationManager.requestLocation()
      var locValue:CLLocationCoordinate2D = locationManager.location.coordinate

      let newLine = "\(locValue.latitude), \(locValue.longitude), \(locationManager.altitude), \(locationManager.timestamp)\n"
      csvText.appendContentsOf(newLine)
    }


}
