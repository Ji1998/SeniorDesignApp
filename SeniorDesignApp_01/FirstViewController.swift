//
//  FirstViewController.swift
//  SeniorDesignApp_01
//
//  Created by Steven on 11/22/19.
//  Copyright © 2019 Steven. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Firebase

final class MapAnnotation: NSObject,MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle : String?
    
    
    init (coordinate: CLLocationCoordinate2D, title: String, subtitle: String){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        
        super.init()
        
    }
    
    
}


class FirstViewController: UIViewController {
    
    var FireLongitude = Double()
    var FireLatitude = Double()
    
    var FireCoor = CLLocation.init(latitude: 0, longitude: 0)
    var hoodCoor = CLLocation.init(latitude: 0, longitude: 0)
    
    var ref: DatabaseReference!
    var CoorRef: DatabaseReference!
    
    let locationManager = CLLocationManager()
    //CLLocationManager is predefined class for set location patameters
    //locationManager set location parameters i.e precision
    
    @IBOutlet weak var HoodSw: UISwitch!
    
    @IBOutlet weak var NavigationButton: UIButton!
    @IBOutlet weak var BuzzSw: UISwitch!
    @IBOutlet weak var MapView: MKMapView!
    
    
    //connect UIViewController to Mapview
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Keep funciton of oringinal constructor from UIViewController
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        if CLLocationManager.locationServicesEnabled() {
            //定位服务大开关
            if CLLocationManager.authorizationStatus() != .authorizedAlways{
                //if user not gives me the authorization of location.
                //then ask the user for location authorization
                locationManager.requestAlwaysAuthorization()
            }
        }
        //***navigation//
        MapView.delegate = self
        
        
        
        //***navigation***//
        
        
        MapView.showsUserLocation = true                    //show bluedot
        
   //--------Firebase CloudFirestore--------
        let db = Firestore.firestore()
        let TestCollection = db.collection("Test").document("Coordinate")
        
        TestCollection.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(data)")
                
                self.FireLongitude = document.get("Longitude") as! Double
                self.FireLatitude = document.get("Latitude") as! Double
                
                
                
            } else {
                print("Document does not exist")
            }
        }
        
        print(TestCollection)
        print(type(of: TestCollection))
  //---------Firebase Realtime database
        
        self.ref = Database.database().reference()
        self.CoorRef = self.ref.child("Test").child("Coordinate").child("inventory").child("AppTest")
        
        _ = CoorRef.observe(DataEventType.value, with: { (snapshot) in
            let coor = snapshot.value as? [String : AnyObject] ?? [:]
            print(coor["data"] as! String)
            
            let coorStr = coor["data"] as! String
            
            let coorArray = coorStr.components(separatedBy: ",")
            
            let longitude = Double(coorArray[0])!
            let latitude = Double(coorArray[1])!
            
            self.hoodCoor = CLLocation.init(latitude: longitude, longitude: latitude)
            
            self.clearLabel()
            self.labelMap(location: self.hoodCoor)
            
            if let coordinateFromPhone = self.locationManager.location {
                self.geofencingCheck(me:coordinateFromPhone, target:self.hoodCoor)
            }
        })
        
        
        
        
        
        //        let long = TestCollection.longitude
        
        
        //        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        //            let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        //            renderer.strokeColor = UIColor.blue
        //            return renderer
        //        }
    }
    
    @IBAction func HoodSwitch(_ sender: Any) {
        
        let db = Firestore.firestore()
        if HoodSw.isOn {
            print("On")
            
            db.collection("Test").document("HoodSwitch").setData(["HoodSwitchField": true]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            
            self.ref.child("Test").child("HoodMotor").setValue(["Tigten": true])
            
        } else {
            print("Off")
            
            db.collection("Test").document("HoodSwitch").setData(["HoodSwitchField": false]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            self.ref.child("Test").child("HoodMotor").setValue(["Tigten": false])
        }
        
    }
    
    @IBAction func BuzzSwitch(_ sender: Any){
        
        if BuzzSw.isOn{
            print("On")
            self.ref.child("Test").child("BuzzMotor").setValue(["On": true])
        }else {
            print("Off")
            self.ref.child("Test").child("BuzzMotor").setValue(["On": false])
        }
    }
    
    
    
    @IBAction func MyLocation(_ sender: Any) {
        if let coordinateFromPhone = locationManager.location {
            //let = const
            self.centerMapOn(coordinate: coordinateFromPhone)
            // coorinateFromPhone connect with coordinate
        }
        
        
        
        
    }
    
    
    
    @IBAction func NavigateButtonAction(_ sender: Any) {
        
        if let coordinateFromPhone = locationManager.location {
            //let = const
            
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: coordinateFromPhone.coordinate, addressDictionary: nil))
            
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: hoodCoor.coordinate.latitude, longitude: hoodCoor.coordinate.longitude), addressDictionary: nil))
            request.requestsAlternateRoutes = false
            request.transportType = .automobile
            
            let directions = MKDirections(request: request)
            
            directions.calculate { [unowned self] response, error in
                guard let unwrappedResponse = response else { return }
                
                for route in unwrappedResponse.routes {
                    self.MapView.addOverlay(route.polyline)
                    self.MapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                }
            }
            
            
            
        }
        
    }
            
        
        
        
        @IBAction func TargetLo(_ sender: Any) {
            
//            FireCoor = CLLocation.init(latitude: self.FireLatitude, longitude: self.FireLongitude)
            
            if let coordinateFromPhone = locationManager.location {
                //let = const
                self.centerMap2(me: coordinateFromPhone, target: hoodCoor)
                // coorinateFromPhone connect with coordinate
                
//                self.labelMap(location: FireCoor)
//                geofencingCheck(me:coordinateFromPhone, target:FireCoor)
            }
            
            
        }
            
            
            
            
            
            
            //        let randomNumber = Int.random(in:0...3)
            //        switch randomNumber {
            //        case 0:
            //            print("case 0")
            //            let alert = UIAlertController(title: "Lost Hoodie Signal", message: nil, preferredStyle: .alert)
            //            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            //            self.present(alert, animated: true)
            //            break
            //        case 1:
            //            print("case 1")
            //            self.clearLabel()
            //            let coord = CLLocation.init(latitude: locationPool.Durham[0], longitude: locationPool.Durham[1])
            //            if let coordinateFromPhone = locationManager.location {
            //                      //let = const
            //                self.centerMap2(me: coordinateFromPhone, target: coord)
            //                    // coorinateFromPhone connect with coordinate
            //
            //                 self.labelMap(location: coord)
            //                geofencingCheck(me:coordinateFromPhone, target:coord, Radius: 1000000)
            //            }
            //            break
            //
            //        case 2:
            //            print("case 2")
            //            self.clearLabel()
            //            let loc = locationPool.LA
            //            let coord = CLLocation.init(latitude: loc[0], longitude: loc[1])
            //            if let coordinateFromPhone = locationManager.location {
            //                               //let = const
            //                self.centerMap2(me: coordinateFromPhone, target: coord)
            //                             // coorinateFromPhone connect with coordinate
            //                 geofencingCheck(me:coordinateFromPhone, target:coord, Radius: 1000000)
            //            }
            //            self.labelMap(location: coord)
            //            break
            //
            //        case 3:
            //            print("case 3")
            //            self.clearLabel()
            //            let coord = CLLocation.init(latitude: locationPool.NYC[0], longitude: locationPool.NYC[1])
            //            if let coordinateFromPhone = locationManager.location {
            //                               //let = const
            //                self.centerMap2(me: coordinateFromPhone, target: coord)
            //                             // coorinateFromPhone connect with coordinate
            //                 geofencingCheck(me:coordinateFromPhone, target:coord, Radius: 1000000)
            //            }
            //            self.labelMap(location: coord)
            //            break
            //        default:
            //            break
            //
            //        }
            
            
        
        //memeber functions
        func centerMap2(me:CLLocation, target:CLLocation) {
            // set center of two targets
            let meLati = me.coordinate.latitude
            let meLong = me.coordinate.longitude
            // make the date type of coordinate from CLLocation to double
            let tarLati = target.coordinate.latitude
            let tarLong = target.coordinate.longitude
            let centerLati = self.mean(input1: meLati, input2: tarLati)
            let centerLong = self.mean(input1: meLong, input2: tarLong)
            //calculate center latitude & longitude
            
            let center = CLLocation.init(latitude: centerLati, longitude: centerLong)
            //covert date type back to CLLocation
            let range = target.distance(from: me) + 1000
            //distance from me to target
            let region = MKCoordinateRegion.init(center: center.coordinate, latitudinalMeters: range, longitudinalMeters: range)
            self.MapView.setRegion(region, animated: true)
            
            
        }
        
        func mean(input1:Double, input2:Double) -> Double  {
            return (input1+input2)/2
        }
        
        
        func centerMapOn(coordinate: CLLocation) {
            //CLLocation date type,like struct in c
            let range = coordinate.horizontalAccuracy + 250
            let region = MKCoordinateRegion.init(center: coordinate.coordinate, latitudinalMeters: range, longitudinalMeters: range)
            MapView.setRegion(region, animated: true)
            
        }
        func labelMap(location: CLLocation){
            let annotation = MapAnnotation(coordinate: location.coordinate, title:
                "hoodie", subtitle:""    )
            MapView.addAnnotation(annotation)
            
            
        }
        func clearLabel(){
            let allAnnotations = MapView.annotations
            MapView.removeAnnotations(allAnnotations)
        }
        
        func geofencingCheck(me:CLLocation, target:CLLocation) {
            
            if !SecondViewController.gfOn {return}
            
            let Radius = SecondViewController.gfR
            
            let DIST = target.distance(from: me)
            if DIST > Radius{
                let alert = UIAlertController(title: "OUT OF GEOFENCING", message: "Current Distance:\(DIST)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            
        }
        
        
        
        
        
        
        
    }
    
    extension FirstViewController: CLLocationManagerDelegate {                  //connect OS GPS with my APP
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
            //fetch information from OS
            
            guard let LatestLocation = locations.last else {return}
            
            print(1)
            
            geofencingCheck(me: LatestLocation, target: FireCoor)
            
            //last means latest location
            //LatestLocation is assigned to the latest location fetch from OS GPS
        }
        
        
    }
    
    extension FirstViewController:MKMapViewDelegate{
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation ) -> MKAnnotationView?{
            if let annotation = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView{
                annotation.animatesWhenAdded = true
                annotation.titleVisibility = .visible
                annotation.subtitleVisibility = .hidden
                annotation.isDraggable = false
                
                return annotation
            }
            
            return nil
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
            renderer.strokeColor = UIColor.blue
            return renderer
        }
        
}
