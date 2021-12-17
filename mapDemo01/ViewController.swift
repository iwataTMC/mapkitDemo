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


struct Address {
    var name: String
    var address: String
}


var addresses = [
    Address(name: "JOYSOUND 名駅三丁目店", address: "愛知県名古屋市中村区名駅3丁目14−6"),
    Address(name: "ジャンカラ 名駅東口店", address: "愛知県名古屋市中村区名駅4丁目10−20"),
    Address(name: "ビッグエコー名駅4丁目店", address: "愛知県名古屋市中村区名駅4丁目5−18")
    
]


class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
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
        
        mapView.delegate = self
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let lc2d:CLLocationCoordinate2D = view.annotation?.coordinate as Any as! CLLocationCoordinate2D
        let l:CLLocation = CLLocation(latitude: lc2d.latitude, longitude: lc2d.longitude)
//        print(l)
        
        let location:CLLocation = l
        
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else { return }
            // 市区町村より下の階層が出力
//            print(placemark.name!)
            // 都道府県
//            print(placemark.administrativeArea!)
            // なんとか郡とかがあれば(ない場合もあるのでnull回避)
//            print(placemark.subAdministrativeArea ?? "")
            // 市区町村
//            print(placemark.locality!)
            // これで日本語の住所はいい感じにでる
            print(placemark.administrativeArea! + placemark.locality! + placemark.name!)
        }
        print((view.annotation?.title ?? "no title")! as String)
    }
    
}
