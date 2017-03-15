//
//  ViewController.swift
//  MapkitDemo
//
//  Created by dhara.patel on 10/03/17.
//  Copyright © 2017 SA. All rights reserved.
//

//hybrid - Satellite photograph data with road maps added. Road and featvar labels are also visible
//standard - Satellite photograph data. Road and feature labels are not visible.


import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController , CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var IBmkMapView: MKMapView!
    var latitude: Double?
    var longitude:Double?
    let locationManager = CLLocationManager()
    var myLocation = CLLocationCoordinate2D()
    var location = [CLLocationCoordinate2D]()
    let imageArray = ["imgPhoto","images","imgPhoto","images","imgPhoto"]
    let placeName = ["Ahmedabad", "Udaupur", "Kashmir", "Gandhinagar", "Mohali"]
    let addressArray = ["Hariyana","Rajstan","Jammu","Gujarat","Punjab"]
    let latitudeArray = [27.8236356,28.619570,34.1490875,22.258652,9.931233]
    let longitudeArray = [88.556531,77.088104,74.0789389, 71.1923805,76.267303]
    var sName = String()
    var sAddress = String()
    var sImage = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        self.IBmkMapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
       // locationManager.startUpdatingLocation()
        IBmkMapView.mapType = MKMapType.standard
    
        for i in 0..<5{
            myLocation = CLLocationCoordinate2D(latitude: latitudeArray[i], longitude: longitudeArray[i])
            let region = MKCoordinateRegion(center: myLocation, span: MKCoordinateSpan(latitudeDelta: 25.0, longitudeDelta: 25.0))
            IBmkMapView.setRegion(region, animated: true)
            location.append(myLocation)
            let point = AnnotationCallOut(coordinate: myLocation)
            point.coordinate = myLocation
            point.name = placeName[i]
            point.address = addressArray[i]
            point.iTag = i
            point.image = UIImage(named: imageArray[i])
            IBmkMapView.addAnnotation(point)
        }
        let clocationDistance = CLLocation(latitude: 27.8236356, longitude: 88.556531)
        let distance =  clocationDistance.distance(from: CLLocation(latitude: 28.619570, longitude: 77.088104))
       print(distance *  0.000621371)
    
        let polyline = MKPolyline(coordinates: location, count: location.count)
        IBmkMapView.add(polyline)
    }
    
    //-------------------------------------------------------------------
    //-------------------------corelocation delegate method---------------
    //--------------------------------------------------------------------
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let latestLocation: AnyObject = locations[locations.count - 1]
//        latitude = latestLocation.coordinate.latitude
//        longitude = latestLocation.coordinate.longitude
//        myLocation = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = myLocation
//        annotation.title = "Mumbai"
//        IBmkMapView.addAnnotation(annotation)
//        let region = MKCoordinateRegion(center: myLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        self.IBmkMapView.setRegion(region, animated: true)
//        locationManager.stopUpdatingLocation()
//    }
//
    

    //---------------------------------------------------------------
    //-------------------------MapView delegate method---------------
    //----------------------------------------------------------------
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation
        {
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if annotationView == nil{
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = false
        }else{
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "placeholder")
        
        return annotationView
        
//   ----------------Default callout--------------------------
//       var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
//
//            if annotationView == nil {
//                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
//                annotationView?.canShowCallout = true
//                
//                let cview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//                cview.backgroundColor = UIColor.gray
//                let clabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
//                clabel.text = "Taj Hotel"
//                clabel.textAlignment = .center
//                clabel.textColor = UIColor.blue
//                cview.addSubview(clabel)
//                annotationView?.leftCalloutAccessoryView = cview
//                
//                let iview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//                iview.backgroundColor = UIColor.gray
//                let img = UIImageView(frame: CGRect(x: 5, y: 0, width: 80, height: 50))
//                img.image = UIImage(named: "imgPhoto")
//                iview.addSubview(img)
//                annotationView?.rightCalloutAccessoryView = iview
//           } else {
//                annotationView!.annotation = annotation
//            }
//        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        if view.annotation is MKUserLocation
        {
        return
        }
         let annotationcallout = view.annotation as! AnnotationCallOut
        let myview = Bundle.main.loadNibNamed("CallOutView", owner: nil, options: nil)
        let calloutView = myview?[0] as! CalloutView
        calloutView.IBimgView.image = annotationcallout.image
        calloutView.IBlblImageName.text = annotationcallout.name
        calloutView.IBlblAddress.text = annotationcallout.address
        calloutView.IBbtnClick.tag = annotationcallout.iTag
        calloutView.IBbtnClick.addTarget(self, action: #selector(btnTapped(sender:)), for: .touchUpInside)
        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
        view.addSubview(calloutView)
        sName = annotationcallout.name
        sAddress = annotationcallout.address
        sImage = annotationcallout.image
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)

    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: AnnotationView.self)
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.blue
        polylineRenderer.lineWidth = 2
        return polylineRenderer
    }
    //---------------------------------------------------------------
    //-------------------------Action method-------------------------
    //----------------------------------------------------------------
  
    func btnTapped(sender : UIButton){
        let secondVC = SecondViewController(nibName: "SecondViewController", bundle: nil)
        secondVC.sName = sName
        secondVC.sAddress = sAddress
        secondVC.sImage = sImage
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


