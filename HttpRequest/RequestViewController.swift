//
//  ViewController.swift
//  HttpRequest
//
//  Created by Aykut Gedik on 4/13/17.
//
//

import UIKit
import os.log

class RequestViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Types
    
    //MARK: - Properties
    @IBOutlet weak var latTextField: UITextField!
    @IBOutlet weak var lonTextField: UITextField!
    @IBOutlet weak var radiusTextField: UITextField!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var consoleTextField: UITextView!
    
    
    //MARK: - Actions
    
    @IBAction func getCurrentLocation(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func getNearbyPlaces(_ sender: UIButton) {
        os_log("Getting Nearby places by using restful api", log: .default, type: .info)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        guard let url = URL(string: "http://test.nearapp.us/api/v1/nearby/place/create/") else {
            print("Error: can not create url")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // This will run async
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    if let data = data {
                        guard let data = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                            print("Json parsing error to any object")
                            return
                        }
                        if let result = data as? NSMutableDictionary {
                            for (key, value) in result {
                                print("Key: \(key), Value: \(value)")
                            }
                        }
                    }
                case 400:
                    print("Bad Request")
                    if let data = data {
                        guard let data = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                            print("Json parsing error to any object")
                            return
                        }
                        if let result = data as? NSMutableDictionary {
                            for (key, value) in result {
                                print("Key: \(key), Value: \(value)")
                            }
                        }
                    }
                case 405:
                    print("Method is not allowed")
                default:
                    print("Unkown Request Error")
                    return
                }
            }
            
        }
        // This will run async
        task.resume()
        
        
        
        
        
        
        
        //        let task = session.dataTask(with: url) { (data, response, error) in
        //            if let error = error {
        //                print(error)
        //            }
        //
        //            if let response = response {
        //                print(response)
        //            }
        //
        //            if let data = data {
        //                //print("Row data:")
        //                //sprint(data)
        //
        //                // .mutableContainers ->  Specifies that arrays and dictionaries are created as mutable objects.
        //
        //                guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
        //                    fatalError("Can not convert the data to json")
        //                }
        //
        //            }
        //        }
        //        task.resume()
    }
    
    
    //MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Private Functions
    
    private func getRequest(url: URL) -> Any? {
        return nil
    }
    
    
    
}

