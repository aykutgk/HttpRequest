//
//  PlaceTableViewController.swift
//  HttpRequest
//
//  Created by Aykut Gedik on 4/14/17.
//
//

import UIKit
import MapKit

class PlaceTableViewController: UITableViewController {
    
    //MARK: - Properties
    
    var places = [Place]()
    
    let locationManager = CLLocationManager()
    
    //MARK: - Private Functions
    
    private func getNearByPlaces() {
        if let location = self.locationManager.location {
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let radius = 400
            
            let end_point = "http://test.nearapp.us/api/v1/nearby/place/list/?radius=\(radius)&lat=\(latitude)&lon=\(longitude)&page_size=20"
            
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            
            
            guard let url = URL(string: end_point) else {
                print("Error: can not create url")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            // This will run async
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    let errorAlertView = UIAlertController(
                        title: "Opps, Something went wrong!",
                        message: "Please check your internet connection!",
                        preferredStyle: .alert
                    )
                    let errorAlertViewOkAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                        return
                    })
                    errorAlertView.addAction(errorAlertViewOkAction)
                    self.present(errorAlertView, animated: true, completion: {
                        return
                    })
                } else {
                    if let response = response as? HTTPURLResponse {
                        if response.statusCode == 200 {
                            if let data = data {
                                guard let data = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                                    print("Json parsing error to any object\n")
                                    return
                                }
                                if let data = data as? NSMutableDictionary {
                                    let count = data["count"]
                                    if let results = data["results"] as? NSArray {
                                        for value in results {
                                            if let placeInfo = value as? NSDictionary {
                                                
                                                guard let place = Place(name: placeInfo["name"] as! String , photo: UIImage(named: "place1")!, latitude: placeInfo["lat"] as! Float, longitude: placeInfo["lon"] as! Float, distance: placeInfo["distance"] as! Double) else {
                                                    fatalError("problem here")
                                                }
                                                self.places.append(place)
                                            }
                                        }
                                    }
                                    self.tableView.reloadData()
                                }
                            }
                        } else {
                            print("not success")
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getNearByPlaces()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(places.count)
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceTableViewCell", for: indexPath) as? PlaceTableViewCell else {
            fatalError("cant find the cell")
        }
        print(indexPath)
        print(indexPath.row)
        
        let place = places[indexPath.row]
        cell.placeNameLabel.text = place.name!
        cell.placePhotoImageView.image = place.photo!
        cell.distanceLabel.text = "\(Int(place.distance!)) m."
        
        return cell
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
