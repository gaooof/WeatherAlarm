//
//  ViewController.swift
//  WeatherAlarm
//
//  Created by apple on 15/12/11.
//  Copyright © 2015年 Gaooof. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate{
    @IBOutlet weak var text: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getLocationSet()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //获取定位信息
    var mgr:CLLocationManager!
    func getLocationSet(){
        if self.mgr == nil{
        self.mgr=CLLocationManager()
        }
        self.mgr.delegate=self
        //获得应用授权状态
        let status=CLLocationManager.authorizationStatus()
        //NotDetermined 没有打开这个应用
        if(status == CLAuthorizationStatus.NotDetermined) {
            
            print("didChangeAuthorizationStatus:\(status)");
            self.mgr.requestWhenInUseAuthorization()
            self.mgr.requestAlwaysAuthorization()
        }
        mgr.desiredAccuracy = kCLLocationAccuracyKilometer
        mgr.distanceFilter = 1000
        
        // 开始获取位置
        self.mgr.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc:CLLocation = locations.last!
        let lat:CLLocationDegrees = loc.coordinate.latitude // 緯度
        let lng:CLLocationDegrees = loc.coordinate.longitude // 経度
        
        // lbLatLong
        print("\(lat),  \(lng)")
//        var locationLat = NSString(format: "緯度：%.2f", lat) as String
//        var locationLng = NSString(format: "経度：%.2f", lng) as String
        //调用weatherAPI
        request(lat, lng:  lng)

    }
    //weatherAPI
    func  request(lat: CLLocationDegrees, lng: CLLocationDegrees) {
        var url = "http://apis.baidu.com/showapi_open_bus/weather_showapi/point"
        var httpArg = "lng=\(lng)&lat=\(lat)&from=5&needMoreDay=0&needIndex=0&needAlarm=0&need3HourForcast=0"
        var req = NSMutableURLRequest(URL: NSURL(string: url + "?" + httpArg)!)
        req.timeoutInterval = 6
        req.HTTPMethod = "GET"
        req.addValue("5e30aa1fb8d5a5c6538faf2a4590f7df", forHTTPHeaderField: "apikey")
        NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue.mainQueue()) {
            (response, data, error) -> Void in
            let res = response as! NSHTTPURLResponse
            self.text.text=String(res.statusCode)

            
            if let e = error{
                self.text.text="error"
            }
            if let d = data {
                var content = NSString(data: d, encoding: NSUTF8StringEncoding)
                self.text.text=String(content)
            }
        }
    }


}

