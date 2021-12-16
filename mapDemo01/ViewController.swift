//
//  ViewController.swift
//  mapDemo01
//
//  Created by kai on 2021/12/17.
//
//

import UIKit
import MapKit
import CoreLocation
import SwiftUI


struct Address {
    var name: String
    var address: String
}

var addresses = [
    Address(name: "JOYSOUND 名駅三丁目店", address: "愛知県名古屋市中村区名駅3丁目14−6"),Address(name: "JOYSOUND 名駅二丁目店", address: "愛知県名古屋市中村区名駅2丁目45−11"),Address(name: "ビッグエコー名駅4丁目店", address: "愛知県名古屋市中村区名駅4丁目5−18")
    
]


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager!
    
    func addPin() {
        for i in 0..<addresses.count {
            CLGeocoder().geocodeAddressString(addresses[i].address) { placemarks, error in
                if let coordinate = placemarks?.first?.location?.coordinate {
                    let pin = MKPointAnnotation()
                    pin.title = addresses[i].name
                    pin.coordinate = coordinate
                    self.mapView.addAnnotation(pin)
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager!.requestWhenInUseAuthorization()
        
        // 現在地に照準を合わす
        // 0.01が距離の倍率
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        // Nagoya駅の位置情報をセット
        let nagoyaStation = CLLocationCoordinate2DMake(35.170915, 136.8793482)
        // mapView.userLocation.coordinateで現在地の情報が取得できる
        let region = MKCoordinateRegion(center: nagoyaStation, span: span)
        // ここで照準を合わせている
        mapView.region = region
        
        addPin()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            // 許可されてない場合
        case .notDetermined:
            // 許可を求める
            manager.requestWhenInUseAuthorization()
            // 拒否されてる場合
        case .restricted, .denied:
            // 何もしない
            break
            // 許可されている場合
        case .authorizedAlways, .authorizedWhenInUse:
            // 現在地の取得を開始
            manager.startUpdatingLocation()
            break
        default:
            break
        }
    }
}
