//
//  ViewController.swift
//  MapkitDemo
//
//  Created by dhara.patel on 10/03/17.
//  Copyright © 2017 SA. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController , CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var IBmkMapView: MKMapView!
    var latitude: Double?
    var longitude:Double?
    let locationManager = CLLocationManager()
    var myLocation = CLLocationCoordinate2D()
    var currentLocation: MKUserLocation?
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        self.IBmkMapView.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        //hybrid - Satellite photograph data with road maps added. Road and feature labels are also visible
        //standard - Satellite photograph data. Road and feature labels are not visible.
        
        IBmkMapView.mapType = MKMapType.standard
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation: AnyObject = locations[locations.count - 1]
        latitude = latestLocation.coordinate.latitude
        longitude = latestLocation.coordinate.longitude
        myLocation = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        let annotation = MKPointAnnotation()
        annotation.coordinate = myLocation
        annotation.title = "Mumbai"
        IBmkMapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: myLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.IBmkMapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
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
        //annotationView?.image = UIImage(named: "pin")
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        if view.annotation is MKUserLocation
        {
        return
        }
        let myview = Bundle.main.loadNibNamed("CallOutView", owner: nil, options: nil)
        let calloutView = myview?[0] as! CalloutView
        calloutView.IBimgView.image = UIImage(named: "imgPhoto")
        calloutView.IBlblImageName.text = "India Gate"
        calloutView.IBlblAddress.text = "Mumbai,India"
        calloutView.IBbtnClick.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
        view.addSubview(calloutView)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    func btnTapped(){
        let secondVC = SecondViewController(nibName: "SecondViewController", bundle: nil)
        self.navigationController?.pushViewController(secondVC, animated: true)
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
}

