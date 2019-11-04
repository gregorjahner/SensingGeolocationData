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

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func startTapped(_ sender: Any) {
        print("started location process.")

        //locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }


    @IBAction func endTapped(_ sender: Any) {
      locationManager.stopUpdatingLocation()
    }


}
