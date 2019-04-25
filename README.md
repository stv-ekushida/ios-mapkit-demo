# ios-mapkit-demo

### アノテーションを表示する。

```:swift

{
    private func setShopLocation(locations: [CLLocationCoordinate2D]) {
        
        mapView.removeAnnotations(mapView.annotations)
        
        for (index, location) in locations.enumerated() {
            
            //2点間の距離を算出する            
            let fromPosition = CLLocation(latitude: currentPosition.latitude, longitude: currentPosition.longitude)
            let toPosition = CLLocation(latitude: location.latitude, longitude: location.longitude)
            let distance = fromPosition.distance(from: toPosition)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
            annotation.title = "\(index + 1)"
            mapView.addAnnotation(annotation)
        }
    }
}

// MARK: - MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
        
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
}
```

### 自分の位置を表示する。

```:swift
mapView.showsUserLocation = true
```

### 現在地から周辺にサークルを描画する。

```:swift
{
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
}

// MARK: - MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView,
                 rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        return setCircle(overlay: overlay)
    }


    private func setCircle(overlay: MKOverlay) -> MKOverlayRenderer {
        
        let render = MKCircleRenderer(overlay: overlay)
        render.strokeColor = UIColor.blue
        render.fillColor = UIColor.blue.withAlphaComponent(0.05)
        render.lineWidth = 0.5
        return render
    }
 }
 ```
