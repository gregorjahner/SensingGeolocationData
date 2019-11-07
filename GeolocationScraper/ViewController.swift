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
import Foundation


class ViewController: UIViewController, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate {

    let locationManager:CLLocationManager = CLLocationManager()
    var timer = Timer()
    let frequency:Double = 5.0
    var csvText = "Latitude, Longitude, Altitude, Timestamp\n"

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func startTapped(_ sender: Any) {
        print("started location process.")

        self.locationManager.requestAlwaysAuthorization()
        //self.locationManager.requestWhenInUseAuthorization()

        if (CLLocationManager.locationServicesEnabled()) {
          locationManager.delegate = self
          locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }

        // start the timer
        timer = Timer.scheduledTimer(timeInterval: frequency, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }


    @IBAction func endTapped(_ sender: Any) {
      //locationManager.stopUpdatingLocation()
      timer.invalidate()
      print(csvText)


      let fileName = "locations.csv"
      let fileManager = FileManager.default
      do {
        let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
        let fileURL = path.appendingPathComponent(fileName)
        try csvText.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
          print("error creating file")
        }

    
      // Sending Data via Email
      //let fileName = "locations.csv"
      //guard let csvPath = Bundle.main.path(forResource: fileName, ofType: "csv") else { return }

      //let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(fileName)

      //try csvText.writeToURL(path, atomically: true, encoding: NSUTF8StringEncoding)
      /*
      let mailComposeViewController = configuredMailComposeViewController()

      //mailComposeViewController.addAttachmentData(NSData(contentsOfURL: path)!, mimeType: "text/csv", fileName: "locations.csv")
      //presentViewController(emailController, animated: true, completion: nil)
      if MFMailComposeViewController.canSendMail() {
        self.present(mailComposeViewController, animated: true, completion: nil)
      } else {
        self.showSendMailErrorAlert()
      }
      */
    }

    /**
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
      //locationManager.startUpdatingLocation()
      for currentLocation in locations{
        print("locations = \(currentLocation.coordinate)")
        print("altitude = \(currentLocation.altitude)")
        print("timestamp = \(currentLocation.timestamp)")
      }
      var locValue:CLLocationCoordinate2D = manager.location.coordinate
      print("locations = \(locValue.latitude) \(locValue.longitude)")
      if let currentLocation = locations.first{
        print("locations = \(currentLocation.coordinate)")
        print("altitude = \(currentLocation.altitude)")
        print("timestamp = \(currentLocation.timestamp)")
        print("")
      }
    }
    */

    @objc func timerAction() {
      //locationManager.requestLocation()
      locationManager.startUpdatingLocation()
      let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
      let altValue:CLLocationDistance = locationManager.location!.altitude
      let timeStamp:Date = locationManager.location!.timestamp
      //print("\(locValue.latitude), \(locValue.longitude), \(altValue), \(timeStamp)")
      //locationManager.stopUpdatingLocation()

      let newLine = "\(locValue.latitude), \(locValue.longitude), \(altValue), \(timeStamp)\n"
      csvText.append(contentsOf: newLine)
      print("timer step.")

    }

    func configuredMailComposeViewController() -> MFMailComposeViewController {
      let mailComposerVC = MFMailComposeViewController()
      mailComposerVC.mailComposeDelegate = self
      mailComposerVC.setToRecipients(["daniel.illner@outlook.de"])
      mailComposerVC.setSubject("Sending you the location data..")
      mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)

      return mailComposerVC
    }

    func showSendMailErrorAlert() {
      let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
      sendMailErrorAlert.show()
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
      controller.dismiss(animated: true, completion: nil)
    }

    /**
    @IBAction func export(sender: AnyObject) {
      let fileName = "locations.csv"
      let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(fileName)

      let mailComposeViewController = configuredMailComposeViewController()

      mailComposeViewController.addAttachmentData(NSData(contentsOfURL: path)!, mimeType: "text/csv", fileName: "locations.csv")
      //presentViewController(emailController, animated: true, completion: nil)
      if MFMailComposeViewController.canSendMail() {
        self.present(mailComposeViewController, animated: true, completion: nil)
      } else {
        self.showSendMailErrorAlert()
      }
    }
    */


}
