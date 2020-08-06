
# Never Lost Hoodie--App
This App is built for My Senior Design Project -- Never Lost Hoodie.  This project is supported Hanes brand. The pupose of this project is to develop a demountable module with GPS onto a auto-cinching hoodie for children, along with companion app for parents to monitor their child’s activity. For a full version of documentation, click [here](https://docs.google.com/document/d/1JR1hO1vg48MkxcifPFJS8aZZV-iJQGwwwRiTRAQhHGM/edit?usp=sharing)

## Getting Started
Following Instructions will get you a copy of this App and run on your local machine for testing and development purpose. 

### Prerequisites
1. Download [Xcode] (https://developer.apple.com/xcode/)
2. Download all the files

### Installing
1. Open Xcode
2. Choose the Device as iPhone11, then run

### Use cases
1. The "Buzz" switch on the left send Boolen value to Firebase to control the Haptic Motor on the module 
2. The "Hood" switch on the left send Boolean value to Firebase to control the motor on the module for cinching purpose
3. The "Navigation" button on the right top will draw a route between parents and the children
4. The "H" button will grab location information from the server and show on the map, which is the children location
5. The "Me" button will show the location of the App itself, which is the parents location.

### Sample screenshot of the App
![alt text](https://github.com/Ji1998/SeniorDesignApp/blob/master/Screen%20Shot%202020-04-02%20at%2021.43.56.png)
![alt text](https://github.com/Ji1998/SeniorDesignApp/blob/master/Screen%20Shot%202020-04-02%20at%2021.49.51.png)
![alt text](https://github.com/Ji1998/SeniorDesignApp/blob/master/Screen%20Shot%202020-04-03%20at%2009.58.43.png)

## For Developers
### This App has the following functions:
(parents = who is using the app), (child = server)
1. Build Connection with Firebase through POD file and GCP instructions, which bulild the brige for data exchange between server and local. 
2. Obtain the GPS information from Firebase(Child Location), and show this GPS information on the App.This will update automatically as long as the GPS information changes in the server. 
3. Obtain the GPS information for the person who is using it, and show this GPS information on the App. This will update automatically as long as the GPS information changes in the server. 
4. show the GPS location of Child and Parents simutaneously on the App
5. show Battery information of the module on the hoodie
6. Parents can set Geofencing distance through the App. Once the child exceed the geofencing distance, the App will alert
7. Parents can navigate through the App from their location to the location of the children
8. Parents can control the motor on the hoodie

### Build with
* [Firebase](https://firebase.google.com/docs/ios/setup): The App will send data to the Firebase and grab data from the Firebase
* [UIKit](https://developer.apple.com/documentation/uikit): The UIKit draw the UI and as a layer between user and system which handling every operation made by user
* [MapKit](https://developer.apple.com/documentation/mapkit): The MapKit draw the map on the App and gain GPS permission from system. 
* [Xcode] (https://developer.apple.com/xcode/): The Xcode compile all files together including the POD file, and build connection with Firebase

### Functions of each file
* "FirstViewController.swift" : 


