
# Senior Design App
This App is built for My Senior Design Project. This project is supported Hanes brand. The pupose of this project is to develop a demountable module with GPS onto a auto-cinching hoodie for children, along with companion app for parents to monitor their child’s activity. The basic logic behind this project is that there is a demountable module based on Particle board. The Particle board will connect with the Motor for auto-cinching and the board has GPS sensor. My App will communicate with the board through Firebase Cloud service provided by Google. 


## The funtionalities of this App include:
1. Obtain the GPS information from Firebase(Child Location), and show this GPS information on the App.This will update automatically as long as the GPS information changes in the server. 
2. Obtain the GPS information for the person who is using it, and show this GPS information on the App. This will update automatically as long as the GPS information changes in the server. 
3. show the GPS location of Child and Parents simutaneously on the App
4. Parents can set Geofencing distance through the App. Once the child exceed the geofencing distance, the App will alert
5. Parents can navigate through the App from their location to the location of the children
6. The App is able to send and receive data from the Cloud Server, here I use Firebase <br />
(note:in order to run this App, you have to download all files(indluding the pod file) and run it with Xcode)

## Instructions on how the App work
1. The "Buzz" switch on the left send Boolen value to Firebase to control the Haptic Motor on the module 
2. The "Hood" switch on the left send Boolean value to Firebase to control the motor on the module for cinching purpose
3. The "Navigation" button on the right top will draw a route between parents and the children
4. The "H" button will grab location information from the server and show on the map, which is the children location
5. The "Me" button will show the location of the App itself, which is the parents location.

## Sample screenshot of the App
![alt text](https://github.com/Ji1998/SeniorDesignApp/blob/master/Screen%20Shot%202020-04-02%20at%2021.43.56.png)
![alt text](https://github.com/Ji1998/SeniorDesignApp/blob/master/Screen%20Shot%202020-04-02%20at%2021.49.51.png)

