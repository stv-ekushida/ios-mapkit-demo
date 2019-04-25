//
//  ViewController.swift
//  ios-mapkit-demo
//
//  Created by Eiji Kushida on 2019/04/09.
//  Copyright © 2019年 Eiji Kushida. All rights reserved.
//

import MapKit
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    //ダミーデータ
    let circleRange = Double(1000)
    let currentPosition = CLLocationCoordinate2D(latitude: 35.626159, longitude: 139.723602)
    let pinLocations: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 35.619029, longitude: 139.72841),
        CLLocationCoordinate2D(latitude: 35.622634, longitude: 139.722666)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addCirclePositon(coordinate: currentPosition)
        mapView.setCenter(currentPosition, animated: false)
        setShopLocation(locations: pinLocations)
    }
    
    private func setMapView() {
        
        var region = mapView.region
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        
        mapView.setRegion(region,animated: true)
        mapView.mapType = MKMapType.standard
        mapView.showsUserLocation = true
        mapView.delegate = self
    }
    
    /// 現在地から周辺1Kmにサークルを描画する
    private func addCirclePositon(coordinate: CLLocationCoordinate2D) {
        
        removeCirclePosition()
        let circle = MKCircle(center: coordinate, radius: circleRange)
        
        mapView.addOverlay(circle)
    }
    
    private func removeCirclePosition() {
        
        for overlay in mapView.overlays {
            mapView.removeOverlay(overlay)
        }
    }
    
    private func setShopLocation(locations: [CLLocationCoordinate2D]) {
        
        mapView.removeAnnotations(mapView.annotations)
        
        for (index, location) in locations.enumerated() {
            
            let fromPosition = CLLocation(latitude: currentPosition.latitude, longitude: currentPosition.longitude)
            let toPosition = CLLocation(latitude: location.latitude, longitude: location.longitude)
            let distance = fromPosition.distance(from: toPosition)
            print("2点間の距離を算出する: ", Int(distance), "m")
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
            annotation.title = "\(index + 1)"
            mapView.addAnnotation(annotation)
        }
    }
}

// MARK: - MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView,
                 rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        return setCircle(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {        
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        let annotation = mapView.selectedAnnotations.first
        mapView.deselectAnnotation(annotation, animated: false)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation === mapView.userLocation {
            (annotation as? MKUserLocation)?.title = nil
            return nil
        }
        
        let identifier = "annotation"
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            return annotationView            
        } else {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.image = #imageLiteral(resourceName: "gps_pin")
            return annotationView
        }
        
        return nil
    }
    
    private func setCircle(overlay: MKOverlay) -> MKOverlayRenderer {
        
        let render = MKCircleRenderer(overlay: overlay)
        render.strokeColor = UIColor.blue
        render.fillColor = UIColor.blue.withAlphaComponent(0.05)
        render.lineWidth = 0.5
        return render
    }
}
