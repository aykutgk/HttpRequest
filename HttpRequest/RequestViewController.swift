//
//  ViewController.swift
//  HttpRequest
//
//  Created by Aykut Gedik on 4/13/17.
//
//

import UIKit
import MapKit
import os.log

class RequestViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    
    //MARK: - Properties
    
    var latitude: Double?
    var longitude: Double?
    var radius = 400
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var latTextField: UITextField!
    @IBOutlet weak var lonTextField: UITextField!
    @IBOutlet weak var radiusTextField: UITextField!
    @IBOutlet weak var consoleTextField: UITextView!
    @IBOutlet weak var requestButton: UIButton!
    
    var defaultButtonColor: UIColor?
    
    
    //MARK: - Actions
    
    @IBAction func getCurrentLocation(_ sender: UIBarButtonItem) {
        consoleTextField.insertText("Getting Current Location...\n")
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways:
                consoleTextField.insertText("AuthorizedAlways\n")
            case .authorizedWhenInUse:
                consoleTextField.insertText("AuthorizedWhenInUse\n")
            case .denied:
                consoleTextField.insertText("Denied")
                // When it is denied show alert
                let deniedAlertView = UIAlertController(
                    title: "Location Request is Denied",
                    message: "Enable location access -> Settings -> HttpRequest -> Location -> While using the app",
                    preferredStyle: .alert
                )
                let deniedAlertViewOkAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                    return
                })
                deniedAlertView.addAction(deniedAlertViewOkAction)
                present(deniedAlertView, animated: true, completion: {
                    return
                })
            case .notDetermined:
                consoleTextField.insertText("notDetermined\n")
                 self.locationManager.requestAlwaysAuthorization()
            case .restricted:
                // Company phones
                consoleTextField.insertText("restricted\n")
            }
            if let location = self.locationManager.location {
                latitude = location.coordinate.latitude
                longitude = location.coordinate.longitude
                consoleTextField.insertText("Location Coordinates:\n")
                consoleTextField.insertText("\tLatitude: \(latitude!)\n")
                consoleTextField.insertText("\tLatitude: \(longitude!)\n")
                latTextField.text = String(latitude!)
                lonTextField.text = String(longitude!)
                radiusTextField.text = String(radius)
                validateParams()
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
    }
    
    @IBAction func getNearbyPlaces(_ sender: UIButton) {
        consoleTextField.insertText("Preparing Request...\n")
        os_log("Getting Nearby places by using restful api", log: .default, type: .info)
        var params = [String:String]()
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        guard let url = URL(string: "http://test.nearapp.us/api/v1/nearby/place/create/") else {
            print("Error: can not create url")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        params["lat"] = String(latitude!)
        params["lon"] = String(longitude!)
        params["radius"] = String(radius)
        let bodyData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = TimeInterval(30)
        request.httpBody = bodyData
        
        consoleTextField.insertText("Request Details:\n")
        consoleTextField.insertText("\tURL: \(url.absoluteString)\n")
        consoleTextField.insertText("\tParams: \(params)\n")
        consoleTextField.insertText("\tMethod: \(request.httpMethod!)\n")
        
        // This will run async
        let task = session.dataTask(with: request) { (data, response, error) in
            var log = ""
            if let error = error {
                print(error)
                log += "\(error.localizedDescription)\n"
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    if let data = data {
                        guard let data = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                            log += "Json parsing error to any object\n"
                            return
                        }
                        if let result = data as? NSMutableDictionary {
                            for (key, value) in result {
                                log += "Key: \(key), Value: \(value)\n"
                            }
                        }
                    }
                case 400:
                    log += "Bad Request\n"
                    if let data = data {
                        guard let data = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                            log += "Json parsing error to any object\n"
                            return
                        }
                        if let result = data as? NSMutableDictionary {
                            for (key, value) in result {
                                log += "Key: \(key), Value: \(value)\n"
                                
                            }
                        }
                    }
                case 405:
                    log += "Method is not allowed\n"
                default:
                    log += "Unkown Request Error\n"
                }
            }
            DispatchQueue.main.async {
                self.consoleTextField.insertText(log)
                self.consoleTextField.flashScrollIndicators()
            }
            
        }
        //consoleTextField.insertText("Starting Async Request...\n")
        // This will run async
        task.resume()
    }
    
    
    //MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        latTextField.delegate = self
        lonTextField.delegate = self
        radiusTextField.delegate = self
        locationManager.delegate = self
        
        defaultButtonColor = requestButton.backgroundColor
        
        validateParams()
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Do your validation here
        switch textField.tag {
        case latTextField.tag:
            consoleTextField.insertText("Latitude value changed!\n")
        case lonTextField.tag:
            consoleTextField.insertText("Longitude value changed!\n")
        case radiusTextField.tag:
            consoleTextField.insertText("Radius value changed!\n")
        default:
            print("Unknown text")
        }
        textField.resignFirstResponder()
        validateParams()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        validateParams()
    }
    
    
    //MARK: - Private Functions
    
    private func validateParams() {
        if (latTextField.text!.isEmpty || lonTextField.text!.isEmpty || radiusTextField.text!.isEmpty) {
            requestButton.isEnabled = false
            requestButton.backgroundColor = UIColor.darkGray
        } else {
            requestButton.isEnabled = true
            requestButton.backgroundColor = defaultButtonColor
        }
    }
    
    
    
}

