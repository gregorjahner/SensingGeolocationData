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
        self.locationManager.requestWhenInUseAuthorization()

        if (CLLocationManager.locationServicesEnabled()) {
          locationManager.delegate = self
          locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }

        // start the timer
        timer = Timer.scheduledTimer(timeInterval: frequency, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }


    @IBAction func endTapped(_ sender: Any) {
      //locationManager.stopUpdatingLocation()
      timer.invalidate()
      print(csvText)

      // Sending Data via Email
      let fileName = "locations.csv"
      let fileManager = FileManager.default
      do {
        let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
        let fileURL = path.appendingPathComponent(fileName)
        try csvText.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
          print("error creating file")
        }

      let mailComposeViewController = configuredMailComposeViewController()


        let attachmentData = csvText.data(using: String.Encoding.utf8, allowLossyConversion: false)

      do {
        mailComposeViewController.addAttachmentData(attachmentData!, mimeType: "text/csv", fileName: "location.csv")
        mailComposeViewController.mailComposeDelegate = self
        self.present(mailComposeViewController, animated: true, completion: nil)
      } catch {
        print("We have encountered error.")
      }

      if MFMailComposeViewController.canSendMail() {
        self.present(mailComposeViewController, animated: true, completion: nil)
      } else {
        self.showSendMailErrorAlert()
      }

    }

    @objc func timerAction() {
      //locationManager.requestLocation()
      locationManager.startUpdatingLocation()
      let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
      let altValue:CLLocationDistance = locationManager.location!.altitude
      let timeStamp:Date = locationManager.location!.timestamp
      //print("\(locValue.latitude), \(locValue.longitude), \(altValue), \(timeStamp)")

      let newLine = "\(locValue.latitude), \(locValue.longitude), \(altValue), \(timeStamp)\n"
      csvText.append(contentsOf: newLine)
      print("timer step.")

    }

    func configuredMailComposeViewController() -> MFMailComposeViewController {
      let mailComposerVC = MFMailComposeViewController()
      mailComposerVC.mailComposeDelegate = self
      mailComposerVC.setToRecipients(["gregor.jahner@gmx.de"])
      mailComposerVC.setSubject("Location Data.")
      mailComposerVC.setMessageBody("Sending location data as csv file via e-mail.", isHTML: false)

      return mailComposerVC
    }

    func showSendMailErrorAlert() {
      let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.", preferredStyle: .alert)
      let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
      sendMailErrorAlert.addAction(dismiss)
      self.present(sendMailErrorAlert, animated: true, completion: nil)
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
      controller.dismiss(animated: true, completion: nil)
    }

}
