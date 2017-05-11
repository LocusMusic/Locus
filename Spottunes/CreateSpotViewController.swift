//
//  CreateSpotViewController.swift
//  Spottunes
//
//  Created by Leo Wong on 4/26/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit
import Parse
import CoreLocation


/*
class CreateSpotViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createSpotButton: UIButton!
    @IBOutlet weak var selectedLocationLabel: UILabel!
    
    let FourSq = FoursquareClient.shared
    var recommendedPlaces : [Location] = []
    var selectedLocation : Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //37.7884° N, 122.4076° W Union Square
//        let currentLocation = CLLocationCoordinate2DMake(CLLocationDegrees(exactly: 37.7884)!, CLLocationDegrees(exactly: 122.4076)!)
        
        //New York Liberty Statue
//        let currentLocation = CLLocationCoordinate2DMake(CLLocationDegrees(exactly: 40.6892)!, CLLocationDegrees(exactly: 74.0445)!)
        
        // UCSD Location
        let currentLocation = CLLocationCoordinate2DMake(CLLocationDegrees(exactly: 32.877741)!, CLLocationDegrees(exactly: -117.234327)!)
        
        FoursquareClient.fetchRecommendedPlaces(ll: currentLocation, success: { (locations: [Location]) in
            self.recommendedPlaces = locations
            for location in locations {
                print(location.name!)
            }
            self.tableView.reloadData()
        })
        print("HERE ARE THE LOCATIONS:")
        getNearbyLocations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getNearbyLocations() {
        let userGeoPoint = PFGeoPoint(latitude: 32.877741, longitude: -117.234327)
        let query = PFQuery(className:"TuneSpot")
        query.whereKey("location", nearGeoPoint:userGeoPoint, withinMiles: 5)
        query.limit = 10
        do {
            if let placesObjects = try? query.findObjects() {
                print(placesObjects)
            }
        } catch {
            print("ERROR")
        }
    }
    
    @IBAction func createSpotTapped(_ sender: Any) {
        print("createSpotTapped")
        let tunespot = TuneSpot()
        tunespot.saveTuneSpot(name: (self.selectedLocation?.name!)!, long: (self.selectedLocation?.lng)!, lat: (self.selectedLocation?.lat)!)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension CreateSpotViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = self.recommendedPlaces[indexPath.row].name
        print(self.recommendedPlaces[indexPath.row].name ?? "Fudge")
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("NUMBER OF LOCATIONS: \(self.recommendedPlaces.count)")
        return self.recommendedPlaces.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
        self.selectedLocationLabel.text = self.recommendedPlaces[indexPath.row].name ?? "No Location"
        self.selectedLocation = self.recommendedPlaces[indexPath.row]
    }

}*/
