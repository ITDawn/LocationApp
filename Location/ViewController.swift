//
//  ViewController.swift
//  Location
//
//  Created by Dany on 30.10.2021.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25
        button.setImage(UIImage(systemName: "paperclip.circle.fill"), for: .normal)
        button.imageView?.tintColor = .black
        button.imageView?.contentMode = .scaleAspectFill
        button.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        return button
    }()
  
    public func locationName(with location: CLLocation,
                             complition: @escaping((String?) -> Void)) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location, preferredLocale: .current) { placemarks,
                                                                               error in
            guard let place = placemarks?.first, error == nil else {
                complition(nil)
                return
            }
            print(place)
            
            var name = ""
            
            if let locality = place.locality {
                name += locality
            }
            if let adminRegion = place.administrativeArea {
                name += ", \(adminRegion)"
            }
            complition(name)
        }
    }
    let manager = CLLocationManager()
    
    var pins: [Pin] = []
  
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: self.mapView)
        let coordinate = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        addPin(at: coordinate)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.desiredAccuracy =  kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.addSubview(button)
        let constraints = [
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -17),
            button.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -70)
        ]
        NSLayoutConstraint.activate(constraints)
        loadPins()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            
           render(location)
        }
    }
    
    func render(_ location: CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        locationName(with: location) { [weak self] locationName in
            self?.title = locationName
        }
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
       
    }
    
    func addPin(at coordinate: CLLocationCoordinate2D) {
        let alert = UIAlertController(title: "New Pin", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Name"
        }
        alert.addTextField { textField in
            textField.placeholder = "Caption"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            guard let textFields = alert.textFields else { return }
            let name = textFields[0].text ?? ""
            let description = textFields[1].text ?? ""

           
            let pin = Pin(name: name, description: description, latitude: coordinate.latitude, longitude: coordinate.longitude)

       
            self.add(pin: pin)
            self.mapView.addAnnotation(pin)
        }
        
        alert.addAction(saveAction)
        
        self.present(alert, animated: true)
    }
    
    
    func add(pin: Pin) {
        self.pins.append(pin)
        Pin.save(pins: self.pins)
    }
    
    // выгрузка пинов в карту
    func loadPins() {
        if let pins = Pin.loadPins() {
           
            self.pins = pins
            self.mapView.addAnnotations(pins)
        }
    }
    @objc func tap() {
            let vc = PinsViewController()
            let vcNav = UINavigationController(rootViewController: vc)
            self.present(vcNav, animated: true, completion: nil)
            
        }
}



extension ViewController: MKMapViewDelegate {
   
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            annotationView.annotation = annotation
            return annotationView
        }
        
        return nil
    }
}
